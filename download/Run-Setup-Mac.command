#!/bin/bash
# Double-click this file in Finder to set up the EdgarTools MCP connector.
# If double-clicking does nothing or opens this in a text editor instead of
# Terminal, right-click it, choose "Open", and confirm any security prompt --
# or open Terminal, drag this file's folder in after typing cd and a space,
# and run:  bash Run-Setup-Mac.command

cd "$(dirname "$0")"

echo "============================================"
echo " EdgarTools MCP Setup for Claude Desktop"
echo "============================================"
echo ""
echo "SEC EDGAR requires a real name and email to identify who is pulling data."
echo "Please enter your own information below (not a placeholder)."
echo ""
read -r -p "Your full name (e.g. Jane Smith): " FULLNAME
read -r -p "Your email (e.g. jane.smith@nd.edu): " EMAILADDR
echo ""

bash setup-edgartools-mac.sh "$FULLNAME" "$EMAILADDR"

echo ""
read -r -p "Done. Press Enter to close this window..." _
