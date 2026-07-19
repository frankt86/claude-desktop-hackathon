"""
ratio_analysis.py

Compute common financial ratios from a simple dictionary of figures.
Included as a reference for what "correct" ratio math looks like, so
participants can check Claude's output against a known-good calculation.

Usage:
    python ratio_analysis.py
"""


def safe_div(a, b):
    """Divide, returning None instead of crashing on zero/missing denominators."""
    if a is None or b in (None, 0):
        return None
    return a / b


def compute_ratios(f: dict) -> dict:
    """
    Expects a dict with any of these keys (all in dollars):
    revenue, cogs, operating_income, net_income,
    total_assets, total_liabilities, total_equity,
    current_assets, current_liabilities, inventory
    """
    gross_profit = None
    if f.get("revenue") is not None and f.get("cogs") is not None:
        gross_profit = f["revenue"] - f["cogs"]

    return {
        "Gross Margin": safe_div(gross_profit, f.get("revenue")),
        "Operating Margin": safe_div(f.get("operating_income"), f.get("revenue")),
        "Net Margin": safe_div(f.get("net_income"), f.get("revenue")),
        "Return on Assets (ROA)": safe_div(f.get("net_income"), f.get("total_assets")),
        "Return on Equity (ROE)": safe_div(f.get("net_income"), f.get("total_equity")),
        "Current Ratio": safe_div(f.get("current_assets"), f.get("current_liabilities")),
        "Quick Ratio": safe_div(
            (f.get("current_assets") or 0) - (f.get("inventory") or 0),
            f.get("current_liabilities"),
        ),
        "Debt to Equity": safe_div(f.get("total_liabilities"), f.get("total_equity")),
    }


def fmt(value, as_pct=False):
    if value is None:
        return "n/a"
    return f"{value:.1%}" if as_pct else f"{value:.2f}"


if __name__ == "__main__":
    # Example figures. Replace with real numbers pulled from a 10-K.
    example = {
        "revenue": 1_108_050,
        "cogs": 486_320,
        "operating_income": 152_185,
        "net_income": 98_400,
        "total_assets": 942_028,
        "total_liabilities": 580_876,
        "total_equity": 361_152,
        "current_assets": 694_528,
        "current_liabilities": 330_876,
        "inventory": 198_760,
    }

    pct_ratios = {"Gross Margin", "Operating Margin", "Net Margin",
                  "Return on Assets (ROA)", "Return on Equity (ROE)"}

    print("Ratio Analysis (example figures)")
    print("=" * 40)
    for name, value in compute_ratios(example).items():
        print(f"{name:<28} {fmt(value, name in pct_ratios)}")

    print(
        "\nUse this as a sanity check: if Claude's spreadsheet ratios differ "
        "from a hand calculation, trace the inputs back to the source filing."
    )
