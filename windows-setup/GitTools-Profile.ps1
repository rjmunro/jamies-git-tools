# Jamie's Git Tools - PowerShell Profile Integration
# This file provides PowerShell functions that wrap the bash scripts

# Detect Git Bash
$global:GitBashExe = $null
$possiblePaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe",
    "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $global:GitBashExe = $path
        break
    }
}

if (-not $global:GitBashExe) {
    Write-Warning "Git Bash not found. Jamie's Git Tools commands will not be available in PowerShell."
    return
}

# Helper function to run bash scripts
function Invoke-GitTool {
    param(
        [string]$ToolName,
        [string[]]$Arguments
    )
    
    # Build the command
    $cmd = "source ~/.bashrc 2>/dev/null; $ToolName"
    if ($Arguments) {
        $escapedArgs = $Arguments | ForEach-Object { 
            # Escape arguments for bash
            if ($_ -match '\s') {
                "'$($_ -replace "'", "'\''")'"
            } else {
                $_
            }
        }
        $cmd += " " + ($escapedArgs -join " ")
    }
    
    & $global:GitBashExe -c $cmd
}

# Create wrapper functions for each tool
function listgits {
    Invoke-GitTool "listgits" $args
}

function git-bisect-rebase {
    Invoke-GitTool "git-bisect-rebase" $args
}

function git-branch-space-report {
    Invoke-GitTool "git-branch-space-report" $args
}

function git-clean-nonwhitespace {
    Invoke-GitTool "git-clean-nonwhitespace" $args
}

function git-clean-whitespace {
    Invoke-GitTool "git-clean-whitespace" $args
}

function git-diff-sed {
    Invoke-GitTool "git-diff-sed" $args
}

function git-grep-blame {
    Invoke-GitTool "git-grep-blame" $args
}

function git-rebase-all {
    Invoke-GitTool "git-rebase-all" $args
}

function git-resolve-formatting-conflicts {
    Invoke-GitTool "git-resolve-formatting-conflicts" $args
}

function makeHumansTxt {
    Invoke-GitTool "makeHumansTxt" $args
}

function watch-ci {
    Invoke-GitTool "watch-ci" $args
}

Write-Host "Jamie's Git Tools loaded in PowerShell" -ForegroundColor Green
