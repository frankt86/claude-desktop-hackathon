# Claude for Accounting: 2-Hour Hackathon
## Notre Dame Accounting Department

A hands-on introduction to Claude for accounting faculty. **No coding experience required** — everything here is done by typing plain-English instructions.

## The big idea: one ladder, four rungs

Everything in this workshop teaches one progression:

| Level | Mode | What you get |
|---|---|---|
| 1 | **Chat** | An answer |
| 2 | **Chat + Skill** | A repeatable answer (your prompt, packaged and reusable) |
| 3 | **Cowork** | A deliverable (Claude works your files + live SEC data, produces real Excel/Word) |
| 4 | **Cowork + Code** | Automation (Claude writes a script you rerun forever) |

**Chat & Skills** = talking to Claude and teaching it your standards. **Cowork & Code** = Claude doing the work and building the tools. Faculty leave knowing which rung fits which course moment: a discussion question is Level 1, a grading rubric is Level 2, a case deliverable is Level 3, a research pipeline is Level 4.

## What's in this package

| Item | Contents |
|---|---|
| `docs/01-setup-guide.md` | Setup: Cowork, the EdgarTools SEC EDGAR MCP connector (one-script install), skills, optional financial plugins |
| `docs/02-demo-scripts.md` | The opening demo: one messy trial balance, shown at all four levels |
| `docs/02b-claude-code-demo.md` | Detailed script and talking points for the Level 4 (Claude Code) portion |
| `docs/03-challenges.md` | The two challenges, each a four-level ladder |
| `docs/04-prompting-tips.md` | One-page prompting cheat sheet |
| `sample-data/` | Messy trial balance, prior-period trial balance, expense report |
| `sample-code/` | Reference scripts (what Level 4 output should look like) |
| `mcp-config/` | EdgarTools SEC EDGAR MCP connector config + Mac/Windows setup scripts |
| `download/` | Participant download package: START-HERE.docx, Challenges.docx, Prompting-Tips.docx, setup scripts, and sample data — everything a participant needs in one folder |

## The 2-hour agenda

| Time | Segment |
|---|---|
| 0:00 - 0:10 | Framing: the four-rung ladder, in accounting terms |
| 0:10 - 0:45 | Guided demo: ONE messy trial balance taken through all four levels (Chat → Skill → Cowork → Code) |
| 0:45 - 0:50 | Team formation (groups of 2-3), pick Challenge A or B |
| 0:50 - 1:45 | Hands-on: teams climb their challenge ladder as far as time allows |
| 1:45 - 1:57 | Show and tell: 2 minutes per team |
| 1:57 - 2:00 | Wrap: the verification habit, taking this into your syllabus |

## The two challenges (details in `docs/03-challenges.md`)

- **Challenge A: The 10-K, Four Ways** — analyze a real company using live SEC EDGAR data
- **Challenge B: Month-End Rescue** — clean a messy trial balance and build a flux analysis from local files

Both use the identical four-level ladder, so teams choose subject matter, not difficulty — the difficulty scales with how far they climb.

## Two rules for accountants using AI

1. **Verify every number.** Claude can be confidently wrong. The SEC EDGAR connector returns source filing URLs with each figure — always trace back to the filing.
2. **Treat output as a first draft.** Review Claude's work like a first-year staff accountant's: check the logic, check the tie-outs, then sign off.

## Quick start (facilitators)

1. Work through `docs/01-setup-guide.md`; the SEC EDGAR connector (EdgarTools MCP) is a one-script install — run `mcp-config/setup-edgartools-mac.sh` or `mcp-config/setup-edgartools-windows.ps1`.
2. Dry-run the full four-level demo in `docs/02-demo-scripts.md` and record a backup screen capture.
3. Confirm every participant has a Claude account with Cowork access a week before the event.

---

*Created with the assistance of AI. All financial data retrieved during the workshop should be independently verified against official SEC sources before use in any real analysis.*
