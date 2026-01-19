#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Adds Jamie's Git Tools to your PowerShell profile for use in PowerShell sessions.

.DESCRIPTION
    This script modifies your PowerShell profile to load wrapper functions that allow
    you to run Jamie's Git Tools directly from PowerShell (not just Git Bash).
    
    The tools will work in PowerShell by calling Git Bash behind the scenes.

.PARAMETER ProfileScope
    Which PowerShell profile to modify:
    - CurrentUserCurrentHost (default): Only affects current user in PowerShell
    - CurrentUserAllHosts: Affects current user in all PowerShell hosts (console, ISE, VS Code, etc.)
    - AllUsersCurrentHost: Affects all users in PowerShell (requires admin)
    - AllUsersAllHosts: Affects all users in all hosts (requires admin)

.EXAMPLE
    .\Add-To-PowerShellProfile.ps1
    Adds to the current user's PowerShell profile.

.EXAMPLE
    .\Add-To-PowerShellProfile.ps1 -ProfileScope CurrentUserAllHosts
    Adds to all PowerShell hosts for the current user.
#>

[CmdletBinding()]
param(
    [ValidateSet('CurrentUserCurrentHost', 'CurrentUserAllHosts', 'AllUsersCurrentHost', 'AllUsersAllHosts')]
    [string]$ProfileScope = 'CurrentUserCurrentHost'
)

# Get paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ProfileScriptPath = Join-Path $ScriptDir "GitTools-Profile.ps1"

if (-not (Test-Path $ProfileScriptPath)) {
    Write-Error "Could not find GitTools-Profile.ps1 at: $ProfileScriptPath"
    exit 1
}

Write-Host "=== Adding Jamie's Git Tools to PowerShell Profile ===" -ForegroundColor Cyan
Write-Host ""

# Check for admin rights if needed
if ($ProfileScope -like 'AllUsers*') {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Error "AllUsers profiles require administrator privileges."
        Write-Error "Please run PowerShell as Administrator or use a CurrentUser profile scope."
        exit 1
    }
}

# Get the appropriate profile path
$profilePath = switch ($ProfileScope) {
    'CurrentUserCurrentHost' { $PROFILE.CurrentUserCurrentHost }
    'CurrentUserAllHosts' { $PROFILE.CurrentUserAllHosts }
    'AllUsersCurrentHost' { $PROFILE.AllUsersCurrentHost }
    'AllUsersAllHosts' { $PROFILE.AllUsersAllHosts }
}

Write-Host "Target profile: $profilePath" -ForegroundColor Yellow
Write-Host ""

# Create profile directory if it doesn't exist
$profileDir = Split-Path -Parent $profilePath
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Host "[OK] Created profile directory" -ForegroundColor Green
}

# Create profile file if it doesn't exist
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
    Write-Host "[OK] Created profile file" -ForegroundColor Green
}

# Check if already added
$profileContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($profileContent -like "*GitTools-Profile.ps1*") {
    Write-Host "[OK] Jamie's Git Tools already in PowerShell profile" -ForegroundColor Green
    Write-Host ""
    Write-Host "To reload, run: " -NoNewline
    Write-Host ". `$PROFILE" -ForegroundColor Yellow
    exit 0
}

# Add to profile
$sourceCommand = @"

# Jamie's Git Tools
. "$ProfileScriptPath"
"@

Add-Content -Path $profilePath -Value $sourceCommand

Write-Host "[OK] Added Jamie's Git Tools to PowerShell profile" -ForegroundColor Green
Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "The tools are now available as PowerShell functions." -ForegroundColor White
Write-Host ""
Write-Host "To activate in the current session, run:" -ForegroundColor White
Write-Host "  . `$PROFILE" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or close and reopen PowerShell." -ForegroundColor White
Write-Host ""
Write-Host "Test with:" -ForegroundColor White
Write-Host "  listgits" -ForegroundColor Yellow
Write-Host "  git-rebase-all" -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: These run through Git Bash, so they work the same as in Git Bash." -ForegroundColor Cyan
