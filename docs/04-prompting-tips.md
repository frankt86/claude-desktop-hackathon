# 04 - Prompting Cheat Sheet for Accountants

One page. Print it.

---

## The five habits

| Habit | Weak prompt | Strong prompt |
|---|---|---|
| Be specific about the output | "Analyze this file" | "Build an Excel workbook with a Clean TB tab and a Summary tab with category totals" |
| State the format | "Summarize the 10-K" | "One-page memo, 3 risk factors in plain English, cite the filing URL" |
| Give the numbers context | "Is this ratio good?" | "Compare this current ratio to the two peers we pulled earlier and to a 2.0 benchmark" |
| Ask for the audit trail | "Fix the errors" | "Fix the errors and add an Exceptions tab listing every change you made and why" |
| Iterate, don't restart | Retyping everything | "Good. Now add a YoY growth column and re-sort by variance" |
| Save what works | Re-perfecting the same prompt | "Turn this into a skill called 'flux memo' so it works this way every time" |

---

## Phrases that work well

- "Show your work" / "Explain each adjustment"
- "Include the source filing URL for every figure"
- "Put all assumptions in a clearly labeled block I can change"
- "Flag anything you're uncertain about instead of guessing"
- "Label this as a draft for review"

---

## What Claude is great at

- Cleaning and restructuring messy data
- Pulling and organizing SEC filing data (with the EDGAR MCP connected)
- First-draft memos, checklists, reconciliations, variance explanations
- Building formatted Excel workbooks from plain-English descriptions
- Explaining unfamiliar accounting concepts and standards in plain language

## What to watch out for

- **Arithmetic and figures can be wrong.** Always tie numbers back to source. The EDGAR MCP's filing URLs exist for exactly this reason
- **It fills gaps confidently.** If information is missing, Claude may assume rather than ask. Tell it to flag uncertainty
- **It's a draft machine, not a sign-off machine.** Review everything the way you'd review a first-year's workpaper
- **Confidential data stays out.** Never paste client names, PII, or non-public financials into any AI tool without checking your firm's or university's policy first

---

## The mental model

Treat Claude like a very fast, very well-read first-year staff accountant: give clear instructions, demand workpapers, review before you rely.
