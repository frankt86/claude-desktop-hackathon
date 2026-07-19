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

# Wrapped in try/finally so this window always stays open long enough to
# read the result, even when double-clicked or launched via right-click ->
# "Run with PowerShell" (both of which normally close the window the
# instant the script exits, hiding any error from a non-technical user).
try {
    if (-not $Name) {
        $Name = Read-Host "Your name (for SEC EDGAR_IDENTITY, e.g. Jane Smith)"
    }
    if (-not $Email) {
        $Email = Read-Host "Your email (for SEC EDGAR_IDENTITY, e.g. jane.smith@nd.edu)"
    }
    if (-not $Name -or -not $Email) {
        throw "Name and email are both required (SEC EDGAR rejects anonymous traffic)."
    }
    $EdgarIdentity = "$Name $Email"

    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonCmd) {
        $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
    }
    if (-not $pythonCmd) {
        throw "python not found on PATH. Install Python 3 first (https://www.python.org/downloads/windows/) and make sure 'Add python.exe to PATH' is checked during install."
    }
    $pythonPath = $pythonCmd.Source
    Write-Host "Using Python: $pythonPath"

    Write-Host "Installing edgartools[ai] (this can take a minute)..."
    & $pythonPath -m pip install --upgrade "edgartools[ai]"
    if ($LASTEXITCODE -ne 0) {
        throw "pip install failed (see the output above for the reason)."
    }

    Write-Host "Verifying the install..."
    # edgartools' own --test output prints a checkmark character that crashes on
    # Windows' default console codepage (cp1252) unless stdout is forced to UTF-8.
    $env:PYTHONIOENCODING = "utf-8"
    & $pythonPath -m edgar.ai --test
    if ($LASTEXITCODE -ne 0) {
        throw "'python -m edgar.ai --test' failed (see the output above). Your Claude config was NOT changed."
    }

    # Claude Desktop can be installed two different ways on Windows, and each
    # reads a DIFFERENT config file:
    #   - Traditional installer: %APPDATA%\Claude\claude_desktop_config.json
    #   - Microsoft Store (MSIX) install: Windows virtualizes %APPDATA% for
    #     packaged apps, so the real file is under
    #     %LOCALAPPDATA%\Packages\Claude_<hash>\LocalCache\Roaming\Claude\claude_desktop_config.json
    # We can't reliably tell which one a given machine uses, so: find every
    # Claude config folder that already exists (created by a prior run of the
    # app) and update all of them. If none exist yet, fall back to creating
    # the standard path.
    $standardConfigPath = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
    $candidatePaths = [System.Collections.Generic.List[string]]::new()
    $candidatePaths.Add($standardConfigPath)

    $packagesRoot = Join-Path $env:LOCALAPPDATA "Packages"
    if (Test-Path $packagesRoot) {
        Get-ChildItem -Path $packagesRoot -Directory -Filter "Claude_*" -ErrorAction SilentlyContinue | ForEach-Object {
            $candidatePaths.Add((Join-Path $_.FullName "LocalCache\Roaming\Claude\claude_desktop_config.json"))
        }
    }

    $targetPaths = $candidatePaths | Where-Object { Test-Path (Split-Path $_ -Parent) } | Select-Object -Unique
    if (-not $targetPaths) {
        New-Item -ItemType Directory -Force -Path (Split-Path $standardConfigPath -Parent) | Out-Null
        $targetPaths = @($standardConfigPath)
    }

    Write-Host ""
    Write-Host "Found $(@($targetPaths).Count) Claude config location(s) - updating all of them:"
    $targetPaths | ForEach-Object { Write-Host "  - $_" }

    foreach ($configPath in $targetPaths) {
        $config = $null
        if (Test-Path $configPath) {
            $backupPath = "$configPath.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
            Copy-Item -Path $configPath -Destination $backupPath -Force
            Write-Host "Backed up existing config to: $backupPath"

            try {
                $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json -ErrorAction Stop
            } catch {
                Write-Warning "Existing config at $configPath was not valid JSON; starting a new one."
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
        Write-Host "Wrote $configPath" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Done. Quit and reopen the Claude Desktop app for the edgartools MCP server to load." -ForegroundColor Green
    Write-Host 'Test it by asking Claude: "Using edgartools, what was Deere & Company''s revenue last fiscal year?"'
}
catch {
    Write-Host ""
    Write-Host "SETUP FAILED: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Your Claude Desktop config was not changed. Copy this message and show it to the facilitator." -ForegroundColor Red
}
finally {
    Write-Host ""
    try { Read-Host "Press Enter to close this window" | Out-Null } catch {}
}
