@echo off
setlocal
echo ============================================
echo  EdgarTools MCP Setup for Claude Desktop
echo ============================================
echo.
echo SEC EDGAR requires a real name and email to identify who is pulling data.
echo Please enter your own information below (not a placeholder).
echo.
set /p FULLNAME=Your full name (e.g. Jane Smith):
set /p EMAILADDR=Your email (e.g. jane.smith@nd.edu):
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-edgartools-windows.ps1" -Name "%FULLNAME%" -Email "%EMAILADDR%"

echo.
echo (This window can be closed now.)
pause
