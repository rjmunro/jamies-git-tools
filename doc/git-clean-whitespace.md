# git-clean-whitespace

A script to remove whitespace-only changes from the staging area, leaving only non-whitespace
changes staged for commit. Can also work in reverse to remove non-whitespace changes and leave
only whitespace changes.

## Overview

This script is the complement to `git-clean-nonwhitespace`. It removes whitespace-only changes from
the staging area while preserving logical code changes. This is useful when you want to commit
substantive changes without including incidental whitespace modifications.

With the `--reverse` option, it does the opposite: removes non-whitespace changes and leaves only
whitespace changes staged. This provides the same functionality as `git-clean-nonwhitespace`.

You can process all staged files or target a specific file.

## Usage

```bash
# Remove whitespace changes from all staged files
git clean-whitespace

# Remove NON-whitespace changes from all staged files (leave only whitespace)
git clean-whitespace --reverse

# Remove whitespace changes from a specific file (relative to current directory)
git clean-whitespace src/main.js

# Remove NON-whitespace changes from a specific file
git clean-whitespace --reverse src/main.js

# Remove whitespace changes from a file using absolute path
git clean-whitespace /full/path/to/project/src/main.js

# Remove whitespace changes from a file in parent directory
git clean-whitespace ../other-module/file.js

# Show help
git clean-whitespace --help
```

## Options

- `--reverse`: Remove non-whitespace changes instead of whitespace changes (same as `git-clean-nonwhitespace`)
- `filename`: Optional. Only process the specified file. Can be:
  - Relative to current working directory: `src/main.js`
  - Absolute system path: `/full/path/to/file.js`
  - Path relative to parent directories: `../other-file.js`
- `--help`, `-h`: Show usage information

## How It Works

The script:

1. **Always runs from git repository root** to ensure git commands work properly
2. **Converts file paths** from your current working directory or absolute paths to paths relative to the git repository root
3. **Identifies whitespace-only changes** using `git diff --cached -w -R`
4. **Removes those changes** from the staging area, leaving only meaningful code changes staged

When a filename is specified, the script:

1. Converts the provided file path to be relative to the git repository root
2. Checks if the file is actually staged for commit
3. Processes only that file instead of all staged files
4. Exits with an error if the specified file is not staged

**Path conversion examples:**

- Current directory: `src/main.js` → `packages/frontend/src/main.js` (if running from `packages/frontend/`)
- Absolute path: `/home/user/project/lib/utils.js` → `lib/utils.js`
- Parent directory: `../shared/types.ts` → `shared/types.ts` (if running from `packages/frontend/`)

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
