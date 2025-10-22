# git-clean-nonwhitespace

A script to remove all non-whitespace changes from the staging area, leaving only whitespace changes
staged for commit.

## Overview

This script is useful when you've made both logical code changes and whitespace/indentation fixes in
the same files, and you want to commit the whitespace changes separately. It removes the
non-whitespace changes from the staging area while preserving the whitespace changes.

**Note**: This script calls `git-clean-whitespace --reverse` to share implementation and provide
consistent file handling capabilities, so you can't install this by itself. Ensure both scripts are
in the same directory.

## Usage

```bash
# Remove non-whitespace changes from all staged files
git clean-nonwhitespace

# Remove non-whitespace changes from a specific file
git clean-nonwhitespace src/main.js

# Remove non-whitespace changes from a file using absolute path
git clean-nonwhitespace /full/path/to/project/src/main.js

# Show help (shows git-clean-whitespace help)
git clean-nonwhitespace --help
```

## Options

All options from `git-clean-whitespace` are supported:

- `filename`: Optional. Only process the specified file. Can be:
  - Relative to current working directory: `src/main.js`
  - Absolute system path: `/full/path/to/file.js`
  - Path relative to parent directories: `../other-file.js`
- `--help`, `-h`: Show usage information

## How It Works

The script calls `git-clean-whitespace --reverse` which:

1. **Always runs from git repository root** to ensure git commands work properly
2. **Converts file paths** from your current working directory or absolute paths to paths relative to the git repository root
3. **Identifies non-whitespace changes** using `git diff --cached -w`
4. **Removes those changes** from the staging area, leaving only whitespace changes staged

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
