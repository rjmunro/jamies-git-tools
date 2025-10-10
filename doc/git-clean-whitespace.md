# git-clean-whitespace

A script to remove whitespace-only changes from the staging area, leaving only non-whitespace
changes staged for commit.

## Overview

This script is the complement to `git-clean-nonwhitespace`. It removes whitespace-only changes from
the staging area while preserving logical code changes. This is useful when you want to commit
substantive changes without including incidental whitespace modifications.

## Usage

```bash
git clean-whitespace
```

## How It Works

The script identifies whitespace-only changes using `git diff --cached -w -R` and then applies those
changes to remove them from the staging area. This leaves only the meaningful code changes staged
for commit.

## Use Case Example

1. You're working on a feature and your editor automatically fixes whitespace
2. You make logical code changes along with these automatic whitespace fixes
3. You stage all changes with `git add .`
4. You want to commit only the logical changes, not the whitespace fixes
5. Run `git clean-whitespace` to remove whitespace changes from staging
6. Commit the logical changes: `git commit -m "Add new feature"`
7. If desired, stage and commit whitespace changes separately later

## Requirements

- Git repository with staged changes
- Standard Unix utilities

## Notes

- This script only affects the staging area (index), not your working directory
- After running this script, your working directory will still contain all changes
- The whitespace changes remain in your working directory and can be staged later if needed
- This is particularly useful for keeping commits focused on logical changes
- Works well in combination with automated code formatting tools
