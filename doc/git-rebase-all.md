# git-rebase-all

Quickly generate rebase commands for all your branches with work in progress.

A script to generate rebase commands for all tip branches (branches that aren't contained by other
branches) against a base branch.

## Overview

This script identifies "tip branches" - branches that represent the latest work and aren't contained
by other branches - and generates `git rebase` commands to rebase them onto a specified base branch.
It's useful for keeping all active development branches up to date with the main development branch.

## Usage

```bash
# Use automatic base branch detection, skip fully pushed branches
git rebase-all

# Include branches that are fully pushed to their upstream
git rebase-all --include-pushed

# Specify a custom base branch
git rebase-all main
git rebase-all develop

# Combine options
git rebase-all --include-pushed develop
```

## Parameters

- `--include-pushed`: Include branches that are fully synchronized with their upstream remote
- `<base-branch>`: The base branch to rebase onto (default: auto-detected)

## Base Branch Detection

If no base branch is specified, the script automatically searches for the first existing branch in
this order:

1. `develop`
2. `origin/develop`
3. `main`
4. `origin/main`
5. `master`
6. `origin/master`

## Output

The script outputs a series of rebase commands that can be executed:

```bash
git rebase 'develop' 'feature/login' || git rebase --abort
git rebase 'develop' 'feature/dashboard' || git rebase --abort
git rebase 'develop' 'bugfix/api-error' || git rebase --abort
```

## Tip Branch Detection

A "tip branch" is identified as:

- A branch that is not contained by any other branch
- A branch that has commits not present in the base branch
- Not a remote-tracking branch

## Use Cases

- **Daily maintenance**: Keep all feature branches up to date with the latest main/develop
- **Before merging**: Ensure your feature branch is based on the latest code
- **Team workflow**: Standardize how branches are kept current across the team

## Examples

```bash
# Generate rebase commands for all tip branches
git rebase-all > rebase-commands.sh
chmod +x rebase-commands.sh
./rebase-commands.sh

# Execute directly with eval
eval "$(git rebase-all)"

# Review commands before executing
git rebase-all
# Then copy/paste the commands you want to run
```

## Requirements

- Git repository with multiple branches
- Standard Unix utilities (sed, awk, wc)

## Notes

- The script only generates commands; it doesn't execute them automatically
- Each rebase command includes `|| git rebase --abort` for safety
- Branches that are fully pushed to their upstream are skipped by default
- Remote-tracking branches are automatically excluded
- The script sorts branches by commit date (most recent first)
