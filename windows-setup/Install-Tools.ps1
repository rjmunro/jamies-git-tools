#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Installer for Jamie's Git Tools on Windows.

.DESCRIPTION
    Installs Jamie's Git Tools for use on Windows with Git Bash and/or PowerShell.
    
    Git Bash installation:
    - Adds bin directory to Windows PATH
    - Configures ~/.bashrc for Git Bash
    
    PowerShell installation:
    - Adds wrapper functions to PowerShell profile
    - Enables running tools directly from PowerShell

.PARAMETER Install
    Install to both Git Bash and PowerShell (recommended).

.PARAMETER InstallGitBash
    Install for Git Bash only.

.PARAMETER InstallPowerShell
    Install for PowerShell only.

.PARAMETER Scope
    For Git Bash installation: 'User' (default) or 'Machine' (requires admin).
    For PowerShell: Which profile to modify (CurrentUserCurrentHost, CurrentUserAllHosts, etc.).

.PARAMETER GitBashPath
    Path to Git Bash installation. Auto-detected if not specified.

.PARAMETER PowerShellProfileScope
    Which PowerShell profile to modify:
    - CurrentUserCurrentHost (default): Current user, PowerShell only
    - CurrentUserAllHosts: Current user, all PowerShell hosts
    - AllUsersCurrentHost: All users, PowerShell only (requires admin)
    - AllUsersAllHosts: All users, all hosts (requires admin)

.EXAMPLE
    .\Install-Tools.ps1 -Install
    Installs for both Git Bash and PowerShell.

.EXAMPLE
    .\Install-Tools.ps1 -InstallGitBash
    Installs for Git Bash only.

.EXAMPLE
    .\Install-Tools.ps1 -InstallPowerShell
    Installs for PowerShell only.

.EXAMPLE
    .\Install-Tools.ps1 -InstallGitBash -Scope Machine
    System-wide Git Bash installation (requires admin).
#>

[CmdletBinding(DefaultParameterSetName='Help')]
param(
    [Parameter(ParameterSetName='InstallBoth')]
    [switch]$Install,
    
    [Parameter(ParameterSetName='InstallGitBash')]
    [switch]$InstallGitBash,
    
    [Parameter(ParameterSetName='InstallPowerShell')]
    [switch]$InstallPowerShell,
    
    [Parameter(ParameterSetName='InstallBoth')]
    [Parameter(ParameterSetName='InstallGitBash')]
    [ValidateSet('User', 'Machine')]
    [string]$Scope = 'User',
    
    [Parameter(ParameterSetName='InstallBoth')]
    [Parameter(ParameterSetName='InstallGitBash')]
    [string]$GitBashPath,
    
    [Parameter(ParameterSetName='InstallBoth')]
    [Parameter(ParameterSetName='InstallPowerShell')]
    [ValidateSet('CurrentUserCurrentHost', 'CurrentUserAllHosts', 'AllUsersCurrentHost', 'AllUsersAllHosts')]
    [string]$PowerShellProfileScope = 'CurrentUserCurrentHost'
)

# Get paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$BinDir = Join-Path $RepoRoot "bin"
$ProfileScriptPath = Join-Path $ScriptDir "GitTools-Profile.ps1"

if (-not (Test-Path $BinDir)) {
    Write-Error "Could not find bin directory at: $BinDir"
    Write-Error "Please ensure the script is in the windows-setup subdirectory of the repository."
    exit 1
}

# Show help/usage if no parameters
if ($PSCmdlet.ParameterSetName -eq 'Help') {
    Write-Host ""
    Write-Host "Jamie's Git Tools - Windows Installer" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\Install-Tools.ps1 -Install" -ForegroundColor White
    Write-Host "    Install to both PowerShell and Git Bash (recommended)"
    Write-Host ""
    Write-Host "  .\Install-Tools.ps1 -InstallGitBash" -ForegroundColor White
    Write-Host "    Install for Git Bash only"
    Write-Host ""
    Write-Host "  .\Install-Tools.ps1 -InstallPowerShell" -ForegroundColor White
    Write-Host "    Install for PowerShell only"
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  -Scope User|Machine       User install (default) or system-wide (requires admin)"
    Write-Host "  -GitBashPath <path>       Custom Git Bash installation path"
    Write-Host "  -PowerShellProfileScope   Which PowerShell profile to modify"
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  .\Install-Tools.ps1 -Install"
    Write-Host "  .\Install-Tools.ps1 -InstallGitBash -Scope Machine"
    Write-Host "  .\Install-Tools.ps1 -InstallPowerShell -PowerShellProfileScope CurrentUserAllHosts"
    Write-Host ""
    Write-Host "For more information, see: " -NoNewline
    Write-Host "windows-setup\README.md" -ForegroundColor Cyan
    Write-Host ""
    exit 0
}

# Determine what to install
$installGitBashComponent = $Install -or $InstallGitBash
$installPowerShellComponent = $Install -or $InstallPowerShell

Write-Host ""
Write-Host "=== Jamie's Git Tools - Windows Installer ===" -ForegroundColor Cyan
Write-Host ""

if ($installGitBashComponent -and $installPowerShellComponent) {
    Write-Host "Installing for: Git Bash and PowerShell" -ForegroundColor Yellow
} elseif ($installGitBashComponent) {
    Write-Host "Installing for: Git Bash only" -ForegroundColor Yellow
} elseif ($installPowerShellComponent) {
    Write-Host "Installing for: PowerShell only" -ForegroundColor Yellow
}
Write-Host ""

#
# GIT BASH INSTALLATION
#
if ($installGitBashComponent) {
    Write-Host "--- Git Bash Setup ---" -ForegroundColor Cyan
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
        
        # Write with UTF-8 encoding without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::AppendAllText($bashrcPath, $newContent, $utf8NoBom)
        
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
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            [System.IO.File]::AppendAllText($bashProfilePath, $sourceCommand, $utf8NoBom)
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

    if (-not $allFound) {
        Write-Warning "Some scripts are missing. Installation may be incomplete."
    }
    
    Write-Host ""
}

#
# POWERSHELL INSTALLATION
#
if ($installPowerShellComponent) {
    Write-Host "--- PowerShell Setup ---" -ForegroundColor Cyan
    Write-Host ""
    
    if (-not (Test-Path $ProfileScriptPath)) {
        Write-Error "Could not find GitTools-Profile.ps1 at: $ProfileScriptPath"
        exit 1
    }

    # Check for admin rights if needed
    if ($PowerShellProfileScope -like 'AllUsers*') {
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            Write-Error "AllUsers profiles require administrator privileges."
            Write-Error "Please run PowerShell as Administrator or use a CurrentUser profile scope."
            exit 1
        }
    }

    # Get the appropriate profile path
    $profilePath = switch ($PowerShellProfileScope) {
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
    } else {
        # Add to profile
        $sourceCommand = @"

# Jamie's Git Tools
. "$ProfileScriptPath"
"@

        Add-Content -Path $profilePath -Value $sourceCommand
        Write-Host "[OK] Added Jamie's Git Tools to PowerShell profile" -ForegroundColor Green
    }
    
    Write-Host ""
}

#
# FINAL SUMMARY
#
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""

if ($installGitBashComponent) {
    Write-Host "Git Bash:" -ForegroundColor Yellow
    Write-Host "  1. Open a NEW Git Bash window" -ForegroundColor White
    Write-Host "  2. Test with: " -NoNewline -ForegroundColor White
    Write-Host "listgits" -ForegroundColor Cyan
    Write-Host ""
}

if ($installPowerShellComponent) {
    Write-Host "PowerShell:" -ForegroundColor Yellow
    Write-Host "  1. Reload profile: " -NoNewline -ForegroundColor White
    Write-Host ". `$PROFILE" -ForegroundColor Cyan
    Write-Host "  2. Or close and reopen PowerShell" -ForegroundColor White
    Write-Host "  3. Test with: " -NoNewline -ForegroundColor White
    Write-Host "listgits" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host "For more information, see: " -NoNewline -ForegroundColor White
Write-Host (Join-Path $RepoRoot "windows-setup\README.md") -ForegroundColor Cyan
Write-Host ""
