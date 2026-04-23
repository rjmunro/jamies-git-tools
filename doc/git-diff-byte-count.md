# git-diff-byte-count

A Python script that compares code size between git commits with comments and whitespace stripped out,
giving you a true measure of whether a refactor is actually reducing code size.

## Overview

When refactoring, it's easy to fool yourself with raw line counts — moving code into helpers or
splitting files can make diffs look large while actual logic stays the same (or grows). This script
cuts through that noise by stripping comments and whitespace before measuring, so you see only the
meaningful code bytes that changed.

It compares every changed file between a base commit and `HEAD`, showing per-file before/after byte
counts and a total summary.

## Prerequisites

- Python 3
- A git repository with at least one commit

## Usage

```bash
git-diff-byte-count [<commit>]
```

## Parameters

- `<commit>`: Commit to compare `HEAD` against (default: `HEAD~1`)

## Options

- `-h, --help`: Show help message and exit

## Examples

```bash
# Compare against the previous commit (default)
git-diff-byte-count

# Compare against a named branch
git-diff-byte-count main

# Compare the last 10 commits
git-diff-byte-count HEAD~10

# Compare against a specific commit
git-diff-byte-count a1b2c3d4
```

## Supported File Types

| Extension | Comment styles stripped |
|-----------|------------------------|
| `.ts`, `.tsx`, `.js`, `.jsx` | `//` line comments, `/* */` block comments |
| `.py` | `#` line comments (shebangs preserved) |
| `.sh` | `#` line comments (shebangs preserved) |

## Output Format

Each changed file is shown on one line with before/after byte counts and the difference.
Green indicates code reduction, red indicates growth.

```text
src/utils.ts                    1024 ->      896 (-128 bytes)
src/main.ts                      512 ->      640 (+128 bytes)

-----------------------------------------------------------------------
Total:                          1536 ->     1536 (+0 bytes, 0.0% change)
```

## Use Cases

- **Refactoring validation**: Confirm a refactor genuinely reduces code, not just moves it
- **Code review**: Quantify the actual complexity change in a PR
- **Tracking progress**: Measure code reduction goals over a range of commits
