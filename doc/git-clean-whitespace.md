# git-clean-whitespace

A script to remove whitespace-only changes from the staging area, leaving only non-whitespace
changes staged for commit.

## Overview

This script is the complement to `git-clean-nonwhitespace`. It removes whitespace-only changes from
the staging area while preserving logical code changes. This is useful when you want to commit
substantive changes without including incidental whitespace modifications.

You can process all staged files or target a specific file.

## Usage

```bash
# Remove whitespace changes from all staged files
git clean-whitespace

# Remove whitespace changes from a specific file only
git clean-whitespace src/main.js

# Show help
git clean-whitespace --help
```

## Options

- `filename`: Optional. Only process the specified file. If not provided, processes all staged files.
- `--help`, `-h`: Show usage information

## How It Works

The script identifies whitespace-only changes using `git diff --cached -w -R` and then applies those
changes to remove them from the staging area. This leaves only the meaningful code changes staged
for commit.

When a filename is specified, the script:

1. Checks if the file is actually staged for commit
2. Processes only that file instead of all staged files
3. Exits with an error if the specified file is not staged

## Use Case Examples

### Process All Files

1. You're working on a feature and your editor automatically fixes whitespace
2. You make logical code changes along with these automatic whitespace fixes
3. You stage all changes with `git add .`
4. You want to commit only the logical changes, not the whitespace fixes
5. Run `git clean-whitespace` to remove whitespace changes from staging

### Process Specific File

1. You've made changes to multiple files
2. Only one file has unwanted whitespace changes mixed with real changes
3. Run `git clean-whitespace src/problematic-file.js` to clean just that file
4. Other staged files remain unchanged

## Requirements

- Git repository with staged changes
- Standard Unix utilities

## Notes

- This script only affects the staging area (index), not your working directory
- After running this script, your working directory will still contain all changes
- The whitespace changes remain in your working directory and can be staged later if needed
- This is particularly useful for keeping commits focused on logical changes
- Works well in combination with automated code formatting tools
