# 02b - Claude Code Demo (Level 4 of the opening demo, facilitator machine only)

Levels 1-3 showed the "analyst" experience (Chat, Skills, Cowork). This is Level 4, the "automation" experience: Claude Code writes a reusable script, and that script is the deliverable.

**Who runs this:** the facilitator only. Do not ask participants to install Claude Code during the event. Technical teams who already have it may use it during the hands-on block.

---

## Setup (before the event)

1. Install Claude Code on the facilitator machine. Current install steps and requirements: https://docs.claude.com/en/docs/claude-code/overview
2. Create a working folder, for example `~/hackathon-demo/`, and copy in `sample-data/trial_balance_current.csv` and `sample-data/trial_balance_prior.csv`
3. Confirm Python 3 is available on the machine (Claude Code will write and run a Python script)
4. Run `mcp-config/setup-edgartools-mac.sh` (or `setup-edgartools-windows.ps1`) if you haven't already, then connect the same EdgarTools MCP server to Code, so you can show it is one ecosystem:

```bash
claude mcp add edgartools -- python -m edgar.ai
claude mcp list
```

5. Do a full dry run. Time it. Record a backup screen capture.

---

## The demo

Open a terminal in the working folder and start Claude Code:

```bash
cd ~/hackathon-demo
claude
```

**The story to tell:** "In Cowork we cleaned this trial balance by asking. Now watch a different question: instead of asking for the answer, we ask for a *machine that produces the answer*. That machine is ours to keep and rerun every month-end."

### Prompt 1 (paste verbatim)

> There are two trial balance CSVs in this folder. The current period file is messy: inconsistent account number formats, stray whitespace, a duplicate row, and it may not balance. Write a Python script called monthly_variance.py that:
> 1. Cleans the current period file (trim whitespace, standardize account names to title case, normalize account numbers to 4 digits, drop exact duplicates)
> 2. Verifies the trial balance balances and prints any exceptions with an explanation
> 3. Reconciles current vs prior period account by account
> 4. Writes an Excel workbook variance_report.xlsx with three tabs: Clean TB, Variance Analysis (dollar and percent change, sorted by absolute dollar change, flagging moves over 10% and $5,000), and Exceptions
> Then run the script and show me the exceptions it found.

**What to point out while it works:**
- Claude Code reads the actual files, writes the script, runs it, sees the errors, and fixes its own bugs in a loop. Narrate that loop when it happens; it is the most impressive part
- The exceptions it prints should include the planted duplicate rent entry and the out-of-balance miscellaneous expense

### Prompt 2 (the payoff)

> Now run the same script again and time it.

**Teaching point (say this line):** "That took a few minutes to build and two seconds to rerun. Next month-end, close-out variance analysis is: drop in the new file, run one command. That is the difference between Cowork and Code: Cowork gives you the answer, Code gives you the answer plus the machine."

### Prompt 3 (optional, if the MCP is connected and time allows)

> Using edgartools, pull Deere's revenue for the last three fiscal years and append a small benchmarking note to the variance report explaining how our revenue growth compares. Include the source filing URLs.

This closes the loop: same MCP server, same data source, both products.

---

## Q&A ammunition

| Likely question | Answer |
|---|---|
| "Do I need to know Python?" | No. You read the script the way you review a workpaper: check inputs, logic, outputs. Claude explains any line you ask about |
| "What if the GL export format changes?" | Tell Claude Code "the export format changed, here's the new file, update the script." That's the maintenance model |
| "Cowork or Code, which should I learn?" | Start with Cowork. Reach for Code when you catch yourself doing the same Cowork task every period |
| "Can we trust the script?" | Same rule as everything today: it's a draft until a human has reviewed it and tied out the numbers |

---

## Reference implementation

`sample-code/variance_report_reference.py` is a known-good version of roughly what Claude Code should produce. Use it to sanity-check the live output during your dry run, or as the fallback if the live demo misbehaves.
