# MCP Configuration: EdgarTools

This project uses **[EdgarTools](https://edgartools.readthedocs.io/en/latest/ai/)**
as the SEC EDGAR connector. It ships its own MCP server (`edgar.ai`) with 13
SEC tools organized around tasks (discover, examine, analyze) rather than raw
API shape, and it runs **locally** — no third-party hosted server in the loop.

## Setup: always use the script

Setup scripts install `edgartools[ai]`, verify it with `edgar.ai --test`, back
up any existing `claude_desktop_config.json`, and write the `edgartools` MCP
server entry using the absolute path to your Python interpreter (Claude
Desktop launches MCP servers without your shell's PATH, so a bare `python`
command fails silently):

- macOS: `mcp-config/setup-edgartools-mac.sh "Your Name" "your.email@example.com"`
- Windows: `mcp-config/setup-edgartools-windows.ps1 -Name "Your Name" -Email "your.email@example.com"`

Restart Claude Desktop afterward, then test with: *"Using edgartools, what was
Deere & Company's revenue last fiscal year? Include the source filing URL."*

`mcp-config.json` in this folder is the config template the scripts write into
`claude_desktop_config.json`.

**Windows note:** Claude Desktop can be installed two different ways, and each
reads a different config file — the script detects and updates whichever
exist, so this is handled automatically, but it's worth knowing about if you
ever need to check the file by hand:
- Traditional installer: `%APPDATA%\Claude\claude_desktop_config.json`
- Microsoft Store (MSIX) install: Windows virtualizes `%APPDATA%` for
  packaged apps, so the real file is under
  `%LOCALAPPDATA%\Packages\Claude_<hash>\LocalCache\Roaming\Claude\claude_desktop_config.json`

Requirements: Python 3 installed and on PATH. No API key or SEC registration —
just a real name and email for `EDGAR_IDENTITY` (SEC EDGAR requires
identifying user agents and may block anonymous traffic).

## Claude Code

```bash
claude mcp add edgartools -- python -m edgar.ai
claude mcp list        # verify connection
```

Inside a session, run `/mcp` to browse the server's tools.
