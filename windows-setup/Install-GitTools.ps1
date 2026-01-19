#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Installs Jamie's Git Tools for use with Git Bash on Windows.

.DESCRIPTION
    This script configures Jamie's Git Tools to work with Git Bash on Windows by:
    1. Adding the bin directory to your Windows PATH (for PowerShell/cmd access)
    2. Creating a .bashrc entry for Git Bash to access the tools
    3. Verifying Git Bash installation

.PARAMETER Scope
    Specifies whether to install for the current user only ('User') or system-wide ('Machine').
    Default is 'User'. Machine scope requires administrator privileges.

.PARAMETER GitBashPath
    Path to Git Bash installation. If not specified, the script will attempt to detect it automatically.

.EXAMPLE
    .\Install-GitTools.ps1
    Installs for the current user with auto-detected Git Bash.

.EXAMPLE
    .\Install-GitTools.ps1 -Scope Machine
    Installs system-wide (requires admin privileges).

.EXAMPLE
    .\Install-GitTools.ps1 -GitBashPath "C:\Program Files\Git"
    Installs with a custom Git Bash location.
#>

[CmdletBinding()]
param(
    [ValidateSet('User', 'Machine')]
    [string]$Scope = 'User',
    
    [string]$GitBashPath
)

# Get paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$BinDir = Join-Path $RepoRoot "bin"

if (-not (Test-Path $BinDir)) {
    Write-Error "Could not find bin directory at: $BinDir"
    Write-Error "Please ensure the script is in the windows-setup subdirectory of the repository."
    exit 1
}

Write-Host "=== Installing Jamie's Git Tools for Windows ===" -ForegroundColor Cyan
Write-Host ""

# Check for admin rights if Machine scope is requested
if ($Scope -eq 'Machine') {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Error "Machine scope installation requires administrator privileges."
        Write-Error "Please run PowerShell as Administrator or use '-Scope User' instead."
        exit 1
    }
}

# Detect Git Bash installation
if (-not $GitBashPath) {
    $possiblePaths = @(
        "C:\Program Files\Git",
        "C:\Program Files (x86)\Git",
        "$env:LOCALAPPDATA\Programs\Git"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path (Join-Path $path "bin\bash.exe")) {
            $GitBashPath = $path
            break
        }
    }
}

if ($GitBashPath -and (Test-Path $GitBashPath)) {
    Write-Host "[OK] Found Git Bash at: $GitBashPath" -ForegroundColor Green
} else {
    Write-Warning "Could not detect Git Bash installation."
    Write-Warning "Git Bash integration may not work. You can specify the path with -GitBashPath parameter."
    Write-Warning "Download Git Bash from: https://git-scm.com/download/win"
}

Write-Host ""

# Step 1: Add to Windows PATH
Write-Host "Step 1: Adding bin directory to Windows PATH..." -ForegroundColor Yellow

$currentPath = [Environment]::GetEnvironmentVariable("Path", $Scope)
$binDirWindows = $BinDir

if ($currentPath -notlike "*$binDirWindows*") {
    $newPath = "$binDirWindows;$currentPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, $Scope)
    
    # Update current session
    $env:Path = "$binDirWindows;$env:Path"
    
    Write-Host "[OK] Added $binDirWindows to $Scope PATH" -ForegroundColor Green
} else {
    Write-Host "[OK] Path already contains $binDirWindows" -ForegroundColor Green
}

# Step 2: Configure Git Bash
Write-Host ""
Write-Host "Step 2: Configuring Git Bash integration..." -ForegroundColor Yellow

# Convert Windows path to Git Bash path (Unix-style)
# Example: C:\Users\name\path -> /c/Users/name/path
$binDirUnix = $BinDir -replace '\\', '/'
if ($binDirUnix -match '^([A-Z]):') {
    $driveLetter = $matches[1].ToLower()
    $binDirUnix = $binDirUnix -replace '^[A-Z]:', "/$driveLetter"
}

$bashrcPath = "$env:USERPROFILE\.bashrc"
$exportLine = "export PATH=`"${binDirUnix}:`$PATH`""

$bashrcContent = if (Test-Path $bashrcPath) { Get-Content $bashrcPath -Raw } else { "" }

if ($bashrcContent -notlike "*$binDirUnix*") {
    $newContent = @"

# Jamie's Git Tools
$exportLine
"@
    
    Add-Content -Path $bashrcPath -Value $newContent
    Write-Host "[OK] Added Git Tools to ~/.bashrc" -ForegroundColor Green
} else {
    Write-Host "[OK] ~/.bashrc already configured" -ForegroundColor Green
}

# Also add to .bash_profile if it exists (some setups use this instead)
$bashProfilePath = "$env:USERPROFILE\.bash_profile"
if (Test-Path $bashProfilePath) {
    $profileContent = Get-Content $bashProfilePath -Raw
    
    # Check if .bash_profile sources .bashrc
    if ($profileContent -notlike "*source*bashrc*" -and $profileContent -notlike "*.*bashrc*") {
        $sourceCommand = @"

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
"@
        Add-Content -Path $bashProfilePath -Value $sourceCommand
        Write-Host "[OK] Configured .bash_profile to source .bashrc" -ForegroundColor Green
    }
}

# Step 3: Verification
Write-Host ""
Write-Host "Step 3: Verification..." -ForegroundColor Yellow

$testScripts = @("listgits", "git-resolve-formatting-conflicts")
$allFound = $true

foreach ($script in $testScripts) {
    $scriptPath = Join-Path $BinDir $script
    if (Test-Path $scriptPath) {
        Write-Host "[OK] Found $script" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Missing $script" -ForegroundColor Red
        $allFound = $false
    }
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""

if ($allFound) {
    Write-Host "To use the tools:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Open a NEW Git Bash window (required to load new PATH)" -ForegroundColor White
    Write-Host "2. Test with: " -NoNewline -ForegroundColor White
    Write-Host "listgits" -ForegroundColor Yellow
    Write-Host "   or: " -NoNewline -ForegroundColor White
    Write-Host "git resolve-formatting-conflicts --help" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Note: Close and reopen all terminals for PATH changes to take effect." -ForegroundColor Cyan
} else {
    Write-Host "Warning: Installation completed with warnings. Some scripts may be missing." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "For more information, see: " -NoNewline -ForegroundColor White
Write-Host (Join-Path $RepoRoot "website\installation.md") -ForegroundColor Cyan
