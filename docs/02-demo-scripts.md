# 02 - The Opening Demo: One Trial Balance, Four Levels (20 minutes)

One messy trial balance (`sample-data/trial_balance_current.csv`), taken up the whole ladder live. This is the single most important 20 minutes of the event — it makes the Chat/Skills vs Cowork/Code contrast concrete before teams touch anything. Pace is tight; keep talk-out-loud moments short and rehearse the transitions.

**The story to tell:** "Your junior staff just sent you this file. Inconsistent names, stray whitespace, debits and credits jammed into one signed column, and a couple of entries that don't belong. We're going to handle it four different ways, and each way teaches you a different thing Claude can be."

Practice end to end and record a backup.

---

## Level 1 — Chat: the answer (~4 min)

Open regular Claude chat. Paste 10-15 rows of the messy file directly into the message.

> Here's an excerpt from a trial balance a junior staff member prepared. Identify everything wrong with it and explain each problem the way you'd explain it to the staff member so they learn.

**Point out:** no setup, no files, instant value — and its limit: you got an explanation, not a fixed file. Also ask the room: "Would you trust this without checking? Why not?" Plant the verification habit in minute one.

## Level 2 — Chat + Skill: the repeatable answer (~4 min)

> Help me create a skill called "TB cleanup standards". Whenever I give Claude a trial balance, it must: standardize account names and numbers, split signed amounts into debit/credit columns, verify the TB balances, and always produce an Exceptions list documenting every change and why. No silent fixes, ever.

Then paste the same excerpt again and watch the skill apply automatically.

**Point out:** the prompt you perfected is now an asset. Say the classroom line: **"A skill is how you hand your prompting expertise to 40 students at once — or to yourself next semester."** This closes the "Chat & Skills" half.

## Level 3 — Cowork: the deliverable (~5 min)

Switch to Cowork. Attach the full `trial_balance_current.csv`.

> Clean up this trial balance following proper workpaper standards: trim whitespace, standardize account names to title case, fix inconsistent account numbers, split the signed Amount column into Debit and Credit. Verify it balances — if not, identify the suspicious entries. Output an Excel workbook with three tabs: Clean TB, Summary by Category, and Exceptions listing every change you made and why.

**Point out:** Claude is now *doing*, not just advising — it catches the planted duplicate and the out-of-balance entry, and the output is a real .xlsx you open live. This is the jump from "Chat & Skills" to "Cowork."

**Optional flourish (if SEC connector is set up):** "And Cowork isn't limited to your files — it reaches live data too":

> Using the SEC EDGAR tools, what was Deere & Company's revenue for the last fiscal year? Include the source filing URL.

Click the URL. "Not from memory — from the filing." This previews Challenge A.

## Level 4 — Cowork + Code: the machine (~5 min)

Full script and talking points in `docs/02b-claude-code-demo.md`. The short version, runnable in Cowork or Claude Code:

> Write a Python script called monthly_variance.py that cleans any trial balance CSV like the one attached, verifies it balances, compares it to a prior period file, and writes the same three-tab Excel workbook. Run it on the two files in sample-data and show me the exceptions it found.

Then the payoff — rerun it and time it.

**Say this line:** "A few minutes to build, two seconds to rerun. Next month-end: drop in the new file, run one command. Cowork gave you the answer; Code gave you the answer **plus the machine**."

---

## Recap slide before team formation

| Level | You asked for... | You got... |
|---|---|---|
| 1 Chat | an explanation | an answer |
| 2 Skill | your standards, saved | repeatability |
| 3 Cowork | the work done | a deliverable |
| 4 Code | the tool itself | automation |

"Your challenge ladders are exactly this, on your own pick of two problems. Climb as far as you can."

---

## If the network or MCP fails

- Play the backup recording
- Levels 1-3 on the trial balance need no connector at all — only the optional SEC flourish and Challenge A Levels 3-4 depend on it
- Offline fallback for the SEC portion: walk through `sample-code/edgar_company_facts.py`
