# 01 - Setup Guide

Four sections, in order of who needs them:

1. Claude + Cowork (everyone)
2. SEC EDGAR connector — EdgarTools MCP, one-script install (everyone)
3. Skills (everyone, Level 2 of both challenges)
4. Optional extras: financial services plugins and Claude Code (facilitator / curious)

---

## 1. Claude + Cowork (everyone)

Claude Cowork is Anthropic's agentic desktop app for knowledge work — an analyst that reads your files, works multi-step tasks, and produces finished Excel, Word, and PDF files. It powers Levels 3-4 of both challenges. Levels 1-2 need only regular Claude chat.

**What participants need:**

- A Claude account (Pro, Team, or Enterprise) with Cowork access
- The Claude desktop app installed
- The `sample-data/` files from this package

**Verify access a week before the event.** Account provisioning is the most common hackathon failure mode. Current plan details: https://support.claude.com

---

## 2. SEC EDGAR connector — EdgarTools MCP, one-script install (everyone)

MCP (Model Context Protocol) is how Claude connects to outside data. The SEC EDGAR connector gives Claude live access to filings (10-K, 10-Q, 8-K) and XBRL financial facts. SEC EDGAR is free and public — no API key, no account.

This workshop uses **[EdgarTools](https://edgartools.readthedocs.io/en/latest/ai/)**'s MCP server (`edgar.ai`): 13 SEC tools organized around tasks (discover, examine, analyze), running locally on the participant's machine — no third-party hosted server in the loop.

**What participants actually do:** open `download/START-HERE.docx` and double-click `Run-Setup-Mac.command` or `Run-Setup-Windows.bat` for their OS. It prompts for their name and email, installs `edgartools[ai]`, verifies it, and writes the MCP entry into `claude_desktop_config.json` — no typed commands, no execution-policy or PATH knowledge required. Full troubleshooting is in that doc.

**Facilitator reference — what the launcher does under the hood** (useful if you're debugging a participant's machine, or prefer the command line yourself):

1. Requires Python 3 installed (https://www.python.org/downloads/).
2. Open a terminal and run the script for your OS from the `mcp-config/` folder, passing a real name and email (SEC EDGAR requires identifying user agents):
   - macOS: `bash setup-edgartools-mac.sh "Your Name" "your.email@example.com"`
   - Windows (PowerShell): `powershell -ExecutionPolicy Bypass -File .\setup-edgartools-windows.ps1 -Name "Your Name" -Email "your.email@example.com"`
3. The script installs `edgartools[ai]`, verifies it, and writes the MCP entry into `claude_desktop_config.json` (backing up any existing file first).
4. Quit and reopen the Claude desktop app.
5. Test it by asking Claude: *"Using edgartools, what was Deere & Company's revenue last fiscal year? Include the source filing URL."*

Notes:

- The script resolves the absolute path to the Python interpreter — Claude Desktop launches MCP servers without the shell's PATH, so this matters
- Facilitator tip: have participants run this before the event if possible; live installs eat into workshop time
- Full manual config and Claude Code quick-add are in `mcp-config/README.md`

---

## 3. Skills (everyone — this is Level 2)

A **skill** is a saved set of instructions Claude follows automatically — your best prompt, packaged so it works the same way every time, for you or anyone you share it with. Think: a grading rubric that grades, a workpaper standard that enforces itself.

No installation needed. To create one, just ask Claude in chat:

> Help me create a skill called "[name]" that does [what you want, including required format and rules].

Claude walks you through it. Skills are managed under **Settings → Capabilities** in the Claude app.

**The teaching frame:** Level 1 prompting quality varies person to person. A skill freezes your best version and hands it to all 40 students — that's the "Skills" half of "Chat & Skills."

---

## 4. Optional extras (facilitator / curious teams)

### Anthropic financial services plugins

Anthropic publishes an official financial-services plugin marketplace with skills for comparable company analysis, 3-statement models, month-end close, variance analysis, and SOX workflows. Relevant if a team wants pre-built accounting skills at Level 2-3 instead of building their own.

In Cowork or Claude Code:

```
/plugin marketplace add anthropics/financial-services
```

Then install the **finance** plugin (close cycle, journal entries, variance analysis). Details: https://github.com/anthropics/financial-services and https://support.claude.com/en/articles/13851150-install-financial-services-plugins-for-cowork

**Keep this a mention, not a module** — one slide max. The hackathon works fully without it; it's the "here's what exists when you go deeper" pointer.

### Claude Code (Level 4 demo, facilitator machine)

Claude Code is the terminal-based agent. In this hackathon the facilitator demos it (script in `docs/02b-claude-code-demo.md`); participants do not install it. Teams who already have it may use it at Level 4.

Install: https://docs.claude.com/en/docs/claude-code/overview

Connect the same SEC connector so you can show it's one ecosystem:

```bash
claude mcp add edgartools -- python -m edgar.ai
claude mcp list   # verify
```

---

## Pre-event checklist

| Item | Done |
|---|---|
| All participants have Claude accounts with Cowork access | [ ] |
| EdgarTools MCP setup script run and tested on the venue network | [ ] |
| Python 3 install instructions + setup scripts on slide 1 and handout | [ ] |
| Sample data files distributed (shared folder or USB) | [ ] |
| Four-level demo dry-run completed and timed | [ ] |
| Claude Code installed on facilitator machine | [ ] |
| Backup screen recordings of the demo | [ ] |
| Room wifi and projector tested | [ ] |
