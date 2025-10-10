# git-diff-sed

A script that applies a sed transformation to the "old" version of a file before running `git diff`,
allowing you to ignore systematic changes when viewing differences.

## Overview

This script is useful when you want to see what changed in a file while ignoring specific systematic
transformations. It works by:

1. Retrieving the old version of the file from Git (HEAD)
2. Applying a sed command to transform the old content
3. Running `git diff --no-index` between the transformed old content and the current working file

This allows you to effectively "hide" systematic changes like variable renames, formatting changes,
or other pattern-based modifications to focus on the meaningful differences.

## Usage

```bash
git diff-sed <sed_command> <file_path> [<git_diff_options>...]
```

## Parameters

- `<sed_command>`: The sed command to apply to the old version of the file
- `<file_path>`: Path to the file you want to diff
- `<git_diff_options>...`: Additional options to pass to `git diff` (optional)

## Examples

```bash
# Hide variable rename from "oldVar" to "newVar"
git diff-sed 's/oldVar/newVar/g' src/main.js

# Ignore multiple systematic changes
git diff-sed 's/old-text/new-text/g; s/OldClass/NewClass/g' lib/module.py

# Use with word-diff to see changes more clearly
git diff-sed 's/legacy_function/new_function/g' utils.py --word-diff

# Hide whitespace normalization changes
git diff-sed 's/\t/    /g' config.json --word-diff=color

# Ignore case changes in function names
git diff-sed 's/myFunction/myfunction/g' script.js --color-words
```

## Use Cases

### Variable and Function Renaming

When you've systematically renamed variables or functions throughout a file, but want to see what
other changes were made:

```bash
# Hide the variable rename to focus on logic changes
git diff-sed 's/user_data/userData/g' processor.py --word-diff
```

### API Migration

When migrating from one API to another with systematic replacements:

```bash
# Hide jQuery to vanilla JS migration
git diff-sed 's/\$/document.querySelector/g' frontend.js
```

### Formatting Changes

When you want to ignore specific formatting changes:

```bash
# Ignore tab to space conversion
git diff-sed 's/\t/    /g' source.py

# Ignore single to double quote changes
git diff-sed "s/'/\"/g" config.json
```

### Legacy Code Updates

When updating legacy patterns to modern equivalents:

```bash
# Hide old-style imports
git diff-sed 's/var /let /g' legacy.js --color-words
```

## Advanced Examples

```bash
# Multiple transformations with complex sed script
git diff-sed 's/old_prefix_/new_prefix_/g; s/LegacyClass/ModernClass/g' refactored.py

# Use extended regex for more complex patterns
git diff-sed 's/get([A-Z][a-z]+)/get\1Data/g' api.js --word-diff

# Combine with specific git diff options for better output
git diff-sed 's/oldLib/newLib/g' imports.py \
    --word-diff=color \
    --ignore-space-change \
    --ignore-blank-lines
```

## How It Works

1. **Retrieve old content**: Uses `git show HEAD:<file>` to get the file content from the last commit
2. **Transform**: Applies the provided sed command to the old content
3. **Compare**: Uses `git diff --no-index` to compare the transformed old content with the current working file
4. **Display**: Shows the diff with any additional git diff options you specify

## Requirements

- Git repository with committed changes
- `sed` command-line tool (standard on Unix-like systems)
- Bash shell environment

## Important Notes

- **File must exist in HEAD**: The file must be present in the last commit for the script to work
- **Sed syntax**: Uses extended regex (`-E` flag), so patterns follow sed extended regex rules
- **Working directory**: Compares against the current working directory version, not staged changes
- **No modification**: The script doesn't modify any files; it only shows a transformed diff view
- **Git diff options**: All standard `git diff` options can be used (colors, word-diff, ignore-whitespace, etc.)

## Error Handling

The script will exit with an error if:

- The sed command or file path is not provided
- The specified file doesn't exist in the HEAD commit
- Git operations fail

## Tips

- Use `--word-diff` for better visibility of changes when hiding systematic replacements
- Test your sed command separately first: `git show HEAD:file.txt | sed 's/old/new/g'`
- Use single quotes around sed commands to avoid shell interpretation
- For complex transformations, consider using a sed script file: `sed -f script.sed`
