<#
.SYNOPSIS
  Installs edgartools[ai] and registers it as an MCP server in the Claude
  Desktop config on Windows.

  Docs: https://edgartools.readthedocs.io/en/latest/ai/mcp-setup/

.PARAMETER Name
  Your name, for the SEC EDGAR_IDENTITY header (e.g. "Jane Smith").

.PARAMETER Email
  Your email, for the SEC EDGAR_IDENTITY header (e.g. "jane.smith@nd.edu").

.EXAMPLE
  .\setup-edgartools-windows.ps1 -Name "Jane Smith" -Email "jane.smith@nd.edu"
#>

param(
    [string]$Name = "John Smith",
    [string]$Email = "john.smith@google.com"
)

$ErrorActionPreference = "Stop"

if (-not $Name) {
    $Name = Read-Host "Your name (for SEC EDGAR_IDENTITY, e.g. Jane Smith)"
}
if (-not $Email) {
    $Email = Read-Host "Your email (for SEC EDGAR_IDENTITY, e.g. jane.smith@nd.edu)"
}
if (-not $Name -or -not $Email) {
    Write-Error "Name and email are both required (SEC EDGAR rejects anonymous traffic)."
    exit 1
}
$EdgarIdentity = "$Name $Email"

$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
    $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
}
if (-not $pythonCmd) {
    Write-Error "python not found on PATH. Install Python 3 first (https://www.python.org/downloads/windows/) and ensure 'Add python.exe to PATH' is checked."
    exit 1
}
$pythonPath = $pythonCmd.Source
Write-Host "Using Python: $pythonPath"

Write-Host "Installing edgartools[ai] (this can take a minute)..."
& $pythonPath -m pip install --upgrade "edgartools[ai]"
if ($LASTEXITCODE -ne 0) {
    Write-Error "pip install failed."
    exit 1
}

Write-Host "Verifying the install..."
# edgartools' own --test output prints a checkmark character that crashes on
# Windows' default console codepage (cp1252) unless stdout is forced to UTF-8.
$env:PYTHONIOENCODING = "utf-8"
& $pythonPath -m edgar.ai --test
if ($LASTEXITCODE -ne 0) {
    Write-Error "'python -m edgar.ai --test' failed. Not touching your Claude config."
    exit 1
}

$configDir = Join-Path $env:APPDATA "Claude"
$configPath = Join-Path $configDir "claude_desktop_config.json"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

$config = $null
if (Test-Path $configPath) {
    $backupPath = "$configPath.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item -Path $configPath -Destination $backupPath -Force
    Write-Host "Backed up existing config to: $backupPath"

    try {
        $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Warning "Existing config was not valid JSON; starting a new one."
        $config = $null
    }
}

if (-not $config) {
    $config = [PSCustomObject]@{}
}
if (-not (Get-Member -InputObject $config -Name mcpServers -MemberType NoteProperty)) {
    $config | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([PSCustomObject]@{})
}

$entry = [PSCustomObject]@{
    command = $pythonPath
    args    = @("-m", "edgar.ai")
    env     = [PSCustomObject]@{
        EDGAR_IDENTITY   = $EdgarIdentity
        PYTHONIOENCODING = "utf-8"
    }
}
$config.mcpServers | Add-Member -NotePropertyName edgartools -NotePropertyValue $entry -Force

$config | ConvertTo-Json -Depth 10 | Set-Content -Path $configPath -Encoding utf8

Write-Host ""
Write-Host "Done. Quit and reopen the Claude Desktop app for the edgartools MCP server to load."
Write-Host 'Test it by asking Claude: "Using edgartools, what was Deere & Company''s revenue last fiscal year?"'
