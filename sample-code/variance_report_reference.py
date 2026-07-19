"""
variance_report_reference.py

Known-good reference for the Claude Code demo (docs/02b-claude-code-demo.md).
During the live demo, Claude Code writes its own version of this script. Use
this one to sanity-check the live output during your dry run, or as a fallback.

Usage (from the folder containing the two sample CSVs):
    pip install pandas openpyxl
    python variance_report_reference.py

Outputs: variance_report.xlsx with tabs Clean TB, Variance Analysis, Exceptions.
"""

import re
from pathlib import Path

import pandas as pd

CURRENT_FILE = "trial_balance_current.csv"
PRIOR_FILE = "trial_balance_prior.csv"
OUTPUT_FILE = "variance_report.xlsx"

FLAG_PCT = 0.10       # flag moves over 10 percent...
FLAG_DOLLARS = 5000   # ...AND over $5,000


def normalize_account_number(raw: str) -> str:
    """Strip prefixes/suffixes like 'ACCT1010' or '1000-00' down to the 4-digit core."""
    digits = re.sub(r"\D", "", str(raw))
    return digits[:4].zfill(4) if digits else str(raw).strip()


def load_current(path: str):
    """Load and clean the messy current-period TB. Returns (clean_df, exceptions)."""
    df = pd.read_csv(path)
    exceptions = []

    df.columns = [c.strip() for c in df.columns]
    amount_col = [c for c in df.columns if "Amount" in c][0]

    df["Account Number"] = df["Account Number"].map(normalize_account_number)
    df["Account Name"] = df["Account Name"].astype(str).str.strip().str.title()
    df["Amount"] = pd.to_numeric(
        df[amount_col].astype(str).str.strip(), errors="coerce"
    )

    bad = df[df["Amount"].isna()]
    for _, row in bad.iterrows():
        exceptions.append(
            {"Account": row["Account Number"], "Issue": "Non-numeric amount", "Action": "Excluded"}
        )
    df = df.dropna(subset=["Amount"])

    dupes = df[df.duplicated(subset=["Account Number", "Account Name", "Amount"], keep="first")]
    for _, row in dupes.iterrows():
        exceptions.append(
            {
                "Account": row["Account Number"],
                "Issue": f"Exact duplicate row ({row['Account Name']}, {row['Amount']:,.2f})",
                "Action": "Dropped duplicate",
            }
        )
    df = df.drop_duplicates(subset=["Account Number", "Account Name", "Amount"], keep="first")

    total = df["Amount"].sum()
    if abs(total) > 0.01:
        exceptions.append(
            {
                "Account": "ALL",
                "Issue": f"Trial balance does not balance; net {total:,.2f}",
                "Action": "Investigate before relying on this TB",
            }
        )

    return df[["Account Number", "Account Name", "Amount"]], exceptions


def load_prior(path: str) -> pd.DataFrame:
    """Load the clean prior-period TB (separate Debit/Credit columns) into a signed Amount."""
    df = pd.read_csv(path)
    df.columns = [c.strip() for c in df.columns]
    df["Account Number"] = df["Account Number"].map(normalize_account_number)
    df["Account Name"] = df["Account Name"].astype(str).str.strip().str.title()
    debit = pd.to_numeric(df["Debit"], errors="coerce").fillna(0)
    credit = pd.to_numeric(df["Credit"], errors="coerce").fillna(0)
    df["Amount"] = debit - credit
    return df[["Account Number", "Account Name", "Amount"]]


def build_variance(current: pd.DataFrame, prior: pd.DataFrame) -> pd.DataFrame:
    merged = current.merge(
        prior, on="Account Number", how="outer", suffixes=(" (Current)", " (Prior)")
    )
    merged["Account Name"] = merged["Account Name (Current)"].fillna(
        merged["Account Name (Prior)"]
    )
    cur = merged["Amount (Current)"].fillna(0)
    pri = merged["Amount (Prior)"].fillna(0)
    merged["$ Change"] = cur - pri
    merged["% Change"] = merged["$ Change"] / pri.replace(0, pd.NA).abs()
    merged["Flag for Review"] = (
        (merged["% Change"].abs() > FLAG_PCT) & (merged["$ Change"].abs() > FLAG_DOLLARS)
    ) | pri.eq(0) & cur.ne(0) | cur.eq(0) & pri.ne(0)

    out = merged[
        ["Account Number", "Account Name", "Amount (Prior)", "Amount (Current)",
         "$ Change", "% Change", "Flag for Review"]
    ]
    return out.sort_values("$ Change", key=lambda s: s.abs(), ascending=False)


def main() -> None:
    for f in (CURRENT_FILE, PRIOR_FILE):
        if not Path(f).exists():
            raise SystemExit(f"Missing input file: {f}. Run from the sample-data folder.")

    current, exceptions = load_current(CURRENT_FILE)
    prior = load_prior(PRIOR_FILE)
    variance = build_variance(current, prior)

    with pd.ExcelWriter(OUTPUT_FILE, engine="openpyxl") as writer:
        current.to_excel(writer, sheet_name="Clean TB", index=False)
        variance.to_excel(writer, sheet_name="Variance Analysis", index=False)
        pd.DataFrame(exceptions).to_excel(writer, sheet_name="Exceptions", index=False)

    print(f"Wrote {OUTPUT_FILE}")
    print(f"\nExceptions found ({len(exceptions)}):")
    for e in exceptions:
        print(f"  [{e['Account']}] {e['Issue']} -> {e['Action']}")
    flagged = variance[variance["Flag for Review"]]
    print(f"\nVariances flagged for review: {len(flagged)}")


if __name__ == "__main__":
    main()
