# git-clean-nonwhitespace

A script to remove all non-whitespace changes from the staging area, leaving only whitespace changes
staged for commit.

## Overview

This script is useful when you've made both logical code changes and whitespace/indentation fixes in
the same files, and you want to commit the whitespace changes separately. It removes the
non-whitespace changes from the staging area while preserving the whitespace changes.

## Usage

```bash
git clean-nonwhitespace
```

## How It Works

The script uses `git diff --cached -w` to identify changes that are not whitespace-only, then
applies those changes in reverse to the staging area. This effectively removes all non-whitespace
changes from what's staged, leaving only the whitespace changes ready to commit.

## Use Case Example

1. You're working on a feature and notice some files have inconsistent indentation
2. You fix the indentation while making your logical changes
3. You stage all changes with `git add .`
4. You want to commit the indentation fixes first, then the logical changes
5. Run `git clean-nonwhitespace` to remove logical changes from staging
6. Commit the whitespace changes: `git commit -m "Fix indentation"`
7. Stage the remaining changes: `git add .`
8. Commit the logical changes: `git commit -m "Add new feature"`

## Requirements

- Git repository with staged changes
- Standard Unix utilities

## Notes

- This script only affects the staging area (index), not your working directory
- After running this script, your working directory will still contain all changes
- You can re-stage the non-whitespace changes afterward with `git add`
- The script works by applying the inverse of non-whitespace changes to the index
