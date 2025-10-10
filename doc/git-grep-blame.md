# git-grep-blame

A Python script that combines `git grep` and `git blame` to search for patterns in your repository
and show who last modified each matching line, along with commit information.

## Overview

This script enhances the standard `git grep` functionality by adding blame information for each
matched line. For every line that matches your search pattern, it shows:

- The commit SHA that last modified the line
- The author who made the change
- When the change was made (relative time or date)
- The matching line content

This is particularly useful for finding who introduced specific code patterns, TODOs, bug fixes, or
any other searchable content.

## Usage

```bash
git grep-blame [options] <pattern> [<path> ...]
```

## Parameters

- `<pattern>`: The search pattern (supports regular expressions as used by `git grep`)
- `<path> ...`: Optional paths to limit the search scope

## Options

- `--date-format {relative,short}`: How to display dates
  - `relative` (default): Shows relative time like "2 weeks ago"
  - `short`: Shows dates in YYYY-MM-DD format
- `--sha-length <number>`: Number of SHA characters to display (default: 8)
- `--full`: Show full 40-character SHA (overrides `--sha-length`)
- `--show-context-line`: Show the exact line from blame instead of the grep match

## Examples

```bash
# Find all TODO comments and see who added them
git grep-blame "TODO"

# Search for memory-related issues with full SHA and short dates
git grep-blame --date-format short --full "memory leak"

# Look for specific patterns in source code only
git grep-blame "fixme" src/

# Search for function calls and see recent changes
git grep-blame --date-format short "someFunction(" lib/

# Find patterns starting with dash (use -- to stop option parsing)
git grep-blame -- "--deprecated"
```

## Output Format

Each matching line is displayed as:

```text
<file>:<line> <sha> <author> <date> \t <content>
```

Example output:

```text
src/main.py:42 a1b2c3d4 John Doe 2 weeks ago    # TODO: Fix this later
lib/utils.js:156 e5f6g7h8 Jane Smith 2023-10-01  console.log('debug'); // FIXME
```

## Use Cases

- **Code archaeology**: Find who introduced specific patterns or bugs
- **TODO tracking**: Identify all TODO/FIXME comments and their authors
- **Code review**: See who last touched lines matching certain patterns
- **Debugging**: Track down who added specific debug statements or temporary code
- **Security audits**: Find potentially problematic patterns and their origins
- **Documentation**: Identify who added specific comments or documentation

## Performance

The script is optimized for repositories with many matches:

- Runs `git blame --line-porcelain` once per file (not per line)
- Falls back to per-line blame only when needed
- Efficiently parses porcelain output for better performance

## Requirements

- Python 3.6 or later
- Git repository
- Standard Git tools (`git grep`, `git blame`)

## Advanced Examples

```bash
# Find all error handling with author info
git grep-blame "catch\|exception\|error" --date-format short

# Look for recent changes to configuration
git grep-blame "config\|setting" --date-format relative

# Find database queries and their authors
git grep-blame "SELECT\|INSERT\|UPDATE\|DELETE" --full

# Search in specific directories with full context
git grep-blame --show-context-line "import.*pandas" src/ tests/
```

## Notes

- The script preserves the exact match from `git grep` by default
- Use `--show-context-line` to see the complete line as it appears in the file
- Regular expressions are supported as per `git grep` functionality
- The script handles binary files and permission issues gracefully
- Exit code 0 indicates successful execution (even with no matches)
- Relative time format uses human-readable descriptions (e.g., "3 days ago")
