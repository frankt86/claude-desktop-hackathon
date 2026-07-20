# 03 - The Two Challenges (55 minutes hands-on)

Teams of 2-3. Pick **one** challenge. Each challenge is a **ladder with four levels**. Every team starts at Level 1 and climbs as far as time allows. You do not need to finish all four levels — a team that does Levels 1-2 well beats a team that rushed to Level 4.

## The ladder (same for both challenges)

| Level | Mode | What it teaches | The deliverable |
|---|---|---|---|
| 1 | **Chat** | Claude as a conversation partner | An answer |
| 2 | **Chat + Skill** | Package your best prompt so it's repeatable | A reusable skill |
| 3 | **Cowork** | Claude as an agent working with real files and live data | A finished file (Excel/Word) |
| 4 | **Cowork + Code** | Claude writes a program you keep | A rerunnable script |

**The one-sentence version:** Level 1 gets you an answer, Level 2 makes the answer repeatable, Level 3 makes it a deliverable, Level 4 makes it automation.

---

# Challenge A: The 10-K, Four Ways
*Live SEC data. Uses the SEC EDGAR connector at Levels 3-4.*

Pick one public company the team knows (Deere, Caterpillar, a student favorite).

### Level 1 — Chat: The 5-minute briefing (~10 min)

Just talk to Claude. No files, no connectors.

> Explain [Company]'s business model and its three biggest financial statement risks the way you'd explain them to a first-semester intermediate accounting student. Then give me three discussion questions I could use in class.

Then push back: ask "how confident are you in those figures?" and discuss with your team what Claude knows from memory versus what needs verification. **That discussion is the point of Level 1.**

### Level 2 — Chat + Skill: The 10-K Digest skill (~15 min)

A skill is a saved set of instructions Claude follows every time — your grading rubric, encoded. Ask Claude to help you build one:

> Help me create a skill called "10-K digest". Whenever I give it a company name, it should produce a one-page memo with: the 3 biggest risk factors in plain English, 3 MD&A highlights, any red flags an auditor should notice, a "verify these figures" list, and a DRAFT label. Tone: written for a partner with 5 minutes.

Test it on two different companies. Notice the consistency — that's what a skill buys you. **Classroom angle:** a skill is how you hand your prompting expertise to 40 students at once.

### Level 3 — Cowork: The live ratio workbook (~20 min)

Now use Cowork with the SEC EDGAR connector. The data comes from actual filings, not Claude's memory.

> Using the SEC EDGAR tools, pull the most recent annual balance sheet and income statement figures for [Company] and one competitor. Build an Excel workbook with: a raw-figures tab including the source filing URL for every number, and a dashboard tab computing current ratio, gross/operating/net margins, ROA, ROE, and debt-to-equity side by side. Label it DRAFT.

Click a filing URL live and tie one number back to the 10-K. **That verification step is the habit to teach students.**

### Level 4 — Cowork + Code: The any-ticker machine (~stretch goal)

Ask Claude to build the tool instead of the answer:

> Write a Python script that takes any stock ticker, pulls the last three years of income statement data from the free SEC EDGAR API, and produces the same ratio workbook we just built. Run it on a ticker we haven't analyzed yet to prove it works.

The script is yours to keep — next semester, new companies, same analysis in seconds. (`sample-code/edgar_company_facts.py` is a reference version.)

---

# Challenge B: Month-End Rescue
*Local data. No connector needed. Uses the two files in `sample-data/`.*

The setup: your junior staff sent you a messy current-period trial balance, and the partner wants a flux analysis against prior period by end of day.

### Level 1 — Chat: The teaching moment (~10 min)

Paste 10-15 rows from `trial_balance_current.csv` directly into chat.

> Here's an excerpt from a trial balance a junior staff member prepared. Identify everything wrong with it — formatting, structure, and any entries that look suspicious — and explain each problem the way you'd explain it to the staff member so they learn.

Compare Claude's list against what your team spotted first. **Classroom angle:** this is a ready-made error-detection exercise.

### Level 2 — Chat + Skill: The workpaper-standards skill (~15 min)

Encode your review standards so every cleanup meets them:

> Help me create a skill called "TB cleanup standards". Whenever I give Claude a trial balance to clean, it must: standardize account names and numbers, split signed amounts into debit/credit columns, verify the TB balances, and always produce an Exceptions list documenting every change made and why. No silent fixes, ever.

Test it by pasting the same excerpt from Level 1. **The "no silent fixes" rule is the audit-trail habit — a skill makes it non-negotiable.**

### Level 3 — Cowork: The flux workbook (~20 min)

Attach both files from `sample-data/` in Cowork.

> I've attached current and prior period trial balances. The current file is messy — clean it first, following proper workpaper standards. Then build an Excel variance analysis: account-by-account dollar and percentage change, sorted by absolute dollar change. Flag anything that moved more than 10% AND more than $5,000, with a one-line plausible explanation per flagged item for a reviewer to confirm or reject. Include an Exceptions tab documenting every cleanup change. Label it DRAFT.

Did Claude catch the planted duplicate and the out-of-balance entry? **Check before you trust.**

### Level 4 — Cowork + Code: Next month in two seconds (~stretch goal)

> Write a Python script called monthly_variance.py that does everything you just did — cleaning, balance check, variance analysis, Exceptions tab — for any pair of trial balance CSVs I give it. Run it on these two files and show me the output matches your Level 3 workbook.

Rerun it and time it. A few minutes to build, two seconds to rerun — **that's the difference between an answer and automation.** (`sample-code/variance_report_reference.py` is a reference version.)

---

## Show and tell (2 minutes per team)

1. Highest level reached, and show the output (30 seconds)
2. One prompt or skill that worked surprisingly well
3. One thing Claude got wrong or that you had to correct
4. How you verified the numbers

Informal judging: usefulness to a real accountant or classroom, quality of output, and quality of verification — **not** how many levels you reached.

---

*Verify all financial figures against official SEC sources before any real use.*
