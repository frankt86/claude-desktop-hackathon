"""
edgar_company_facts.py

Pull key financial figures for a public company directly from the SEC's
free XBRL "company facts" API. No API key required. The SEC asks that all
requests include a User-Agent header identifying who you are.

This is the "under the hood" version of what the SEC EDGAR MCP server does
for Claude automatically. Included for curious participants; the hackathon
itself does not require running this.

Usage:
    pip install requests
    python edgar_company_facts.py DE          # Deere & Co by ticker
    python edgar_company_facts.py CAT

Docs: https://www.sec.gov/edgar/sec-api-documentation
"""

import json
import sys

import requests

# CHANGE THIS to your own name and email before running.
# The SEC requires a real identifying User-Agent and may block anonymous requests.
USER_AGENT = "Notre Dame Accounting Hackathon your-email@nd.edu"

HEADERS = {"User-Agent": USER_AGENT}

# US-GAAP XBRL tags for common income statement concepts. Companies vary in
# which tags they use, so we check a few alternatives per concept.
CONCEPTS = {
    "Revenue": [
        "RevenueFromContractWithCustomerExcludingAssessedTax",
        "Revenues",
        "SalesRevenueNet",
    ],
    "Net Income": [
        "NetIncomeLoss",
    ],
    "Operating Income": [
        "OperatingIncomeLoss",
    ],
    "Total Assets": [
        "Assets",
    ],
    "Total Liabilities": [
        "Liabilities",
    ],
}


def get_cik_for_ticker(ticker: str) -> str:
    """Look up a company's 10-digit CIK from its ticker symbol."""
    url = "https://www.sec.gov/files/company_tickers.json"
    resp = requests.get(url, headers=HEADERS, timeout=30)
    resp.raise_for_status()
    for entry in resp.json().values():
        if entry["ticker"].upper() == ticker.upper():
            return str(entry["cik_str"]).zfill(10)
    raise ValueError(f"Ticker {ticker} not found in SEC ticker file")


def get_company_facts(cik: str) -> dict:
    """Fetch all XBRL facts the company has ever filed."""
    url = f"https://data.sec.gov/api/xbrl/companyfacts/CIK{cik}.json"
    resp = requests.get(url, headers=HEADERS, timeout=30)
    resp.raise_for_status()
    return resp.json()


def latest_annual_values(facts: dict, tags: list, n_years: int = 3) -> list:
    """
    Return up to n_years of annual (10-K) values for the first tag that
    exists in the company's filings. Each item: (fiscal_year_end, value, form, accession).
    """
    gaap = facts.get("facts", {}).get("us-gaap", {})
    for tag in tags:
        if tag not in gaap:
            continue
        usd = gaap[tag].get("units", {}).get("USD", [])
        # Keep annual figures from 10-K filings only, deduplicated by period end
        annual = {}
        for item in usd:
            if item.get("form") == "10-K" and item.get("fp") == "FY":
                annual[item["end"]] = item
        picked = sorted(annual.values(), key=lambda x: x["end"], reverse=True)[:n_years]
        return [(p["end"], p["val"], p["form"], p.get("accn", "")) for p in picked]
    return []


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python edgar_company_facts.py TICKER")
        sys.exit(1)

    ticker = sys.argv[1]
    print(f"Looking up CIK for {ticker}...")
    cik = get_cik_for_ticker(ticker)
    print(f"CIK: {cik}")

    print("Fetching company facts from SEC XBRL API...")
    facts = get_company_facts(cik)
    entity = facts.get("entityName", ticker)
    print(f"\n{entity}\n" + "=" * len(entity))

    for label, tags in CONCEPTS.items():
        values = latest_annual_values(facts, tags)
        print(f"\n{label}:")
        if not values:
            print("  (not found under the expected XBRL tags)")
            continue
        for end, val, form, accn in values:
            # Accession number lets you locate the exact source filing on EDGAR
            print(f"  FY ending {end}: ${val:,.0f}  (source: {form}, accession {accn})")

    print(
        "\nVerification habit: every figure above carries the accession number of "
        "the filing it came from. Look the filing up at https://www.sec.gov/cgi-bin/browse-edgar "
        "before relying on any number."
    )


if __name__ == "__main__":
    main()
