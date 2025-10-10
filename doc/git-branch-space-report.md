# git-branch-space-report

A script to estimate how much unique *packed* data each branch keeps alive compared to a base
branch. This helps identify which branches are using the most storage space in your git repository.

## Overview

This script analyzes git branches and reports how much disk space each branch would consume if it
were the only branch (besides the base branch) in the repository. It focuses on packed data and
ignores branches that are fully merged into the base branch.

## Usage

```bash
# Use current branch as base, analyze all local branches
git branch-space-report

# Specify a base branch, analyze all local branches
git branch-space-report <base>

# Specify base branch and specific branches to analyze
git branch-space-report <base> <branch1> <branch2> ...

# Include remote branches in analysis
git branch-space-report --remote
git branch-space-report --remote <base>
git branch-space-report --remote <base> <branch1> <branch2> ...
```

## Parameters

- `<base>`: The base branch to compare against (default: current branch)
- `<branch1> <branch2> ...`: Specific branches to analyze (default: all branches except base)
- `--remote`: Include remote-tracking branches in the analysis

## Examples

```bash
# Analyze all local branches compared to the current branch
git branch-space-report

# Analyze all branches compared to main
git branch-space-report main

# Analyze specific branches compared to develop
git branch-space-report develop feature/login feature/dashboard

# Include remote branches in the analysis
git branch-space-report --remote origin/main
```

## Output

The script outputs a table showing:

- Branch name
- Unique packed size in MB (sorted by size, largest first)

Branches that are fully merged into the base branch are automatically excluded from the report.

## Requirements

- Git repository
- Standard Unix utilities (awk, sort)

## Notes

- The script only counts unique data that exists in each branch but not in the base branch
- Packed size estimates are based on git's internal object storage
- Branches already merged into the base are ignored
- The analysis can take some time for repositories with many large branches
