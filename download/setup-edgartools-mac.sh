#!/usr/bin/env bash
# Installs edgartools[ai] and registers it as an MCP server in the Claude
# Desktop config on macOS.
#
# Docs: https://edgartools.readthedocs.io/en/latest/ai/mcp-setup/
#
# Usage:
#   ./setup-edgartools-mac.sh "Your Name" "your.email@example.com"
# (If omitted, you will be prompted.)

set -euo pipefail

NAME="${1:-John Smith}"
EMAIL="${2:-john.smith@google.com}"

if [ -z "$NAME" ]; then
  read -r -p "Your name (for SEC EDGAR_IDENTITY, e.g. Jane Smith): " NAME
fi
if [ -z "$EMAIL" ]; then
  read -r -p "Your email (for SEC EDGAR_IDENTITY, e.g. jane.smith@nd.edu): " EMAIL
fi
if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
  echo "Error: name and email are both required (SEC EDGAR rejects anonymous traffic)." >&2
  exit 1
fi
EDGAR_IDENTITY="$NAME $EMAIL"

PYTHON_BIN="$(command -v python3 || true)"
if [ -z "$PYTHON_BIN" ]; then
  echo "Error: python3 not found on PATH. Install Python 3 first (e.g. https://www.python.org/downloads/macos/ or 'brew install python3')." >&2
  exit 1
fi
echo "Using Python: $PYTHON_BIN"

echo "Installing edgartools[ai] (this can take a minute)..."
"$PYTHON_BIN" -m pip install --upgrade "edgartools[ai]"

echo "Verifying the install..."
if ! PYTHONIOENCODING=utf-8 "$PYTHON_BIN" -m edgar.ai --test; then
  echo "Error: 'python3 -m edgar.ai --test' failed. Not touching your Claude config." >&2
  exit 1
fi

CONFIG_DIR="$HOME/Library/Application Support/Claude"
CONFIG_PATH="$CONFIG_DIR/claude_desktop_config.json"
mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_PATH" ]; then
  BACKUP_PATH="$CONFIG_PATH.bak.$(date +%Y%m%d%H%M%S)"
  cp "$CONFIG_PATH" "$BACKUP_PATH"
  echo "Backed up existing config to: $BACKUP_PATH"
fi

"$PYTHON_BIN" - "$CONFIG_PATH" "$PYTHON_BIN" "$EDGAR_IDENTITY" <<'PYEOF'
import json
import sys

config_path, python_bin, edgar_identity = sys.argv[1:4]

try:
    with open(config_path, "r", encoding="utf-8") as f:
        config = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    config = {}

config.setdefault("mcpServers", {})
config["mcpServers"]["edgartools"] = {
    "command": python_bin,
    "args": ["-m", "edgar.ai"],
    "env": {
        "EDGAR_IDENTITY": edgar_identity,
        "PYTHONIOENCODING": "utf-8",
    },
}

with open(config_path, "w", encoding="utf-8") as f:
    json.dump(config, f, indent=2)
    f.write("\n")

print(f"Wrote {config_path}")
PYEOF

echo ""
echo "Done. Quit and reopen the Claude Desktop app for the edgartools MCP server to load."
echo "Test it by asking Claude: \"Using edgartools, what was Deere & Company's revenue last fiscal year?\""
