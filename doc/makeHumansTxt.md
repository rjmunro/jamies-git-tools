# makeHumansTxt

A script to generate a `humans.txt` file listing all contributors to a Git project, with multiple ways to measure contributions.

## Overview

This script analyzes a Git repository to identify all contributors and generates a `humans.txt` file - a standard way to credit the people behind a website or project. Contributors can be ranked by different metrics: commit count, total lines added/changed, or lines currently remaining in the codebase.

## Usage

```bash
# Basic usage (counts by commits)
makeHumansTxt

# Count by different metrics
makeHumansTxt --commits           # Count by number of commits (default)
makeHumansTxt --lines-added       # Count by total lines added/changed
makeHumansTxt --lines-current     # Count by lines currently in codebase

# Show actual counts next to names
makeHumansTxt --show-counts
makeHumansTxt --lines-current --show-counts

# Get help
makeHumansTxt --help
```

The script outputs the `humans.txt` content to standard output. To save it to a file:

```bash
makeHumansTxt --lines-current > humans.txt
```

## Options

- `--commits`: Count by number of commits (default behavior)
- `--lines-added`: Count by total lines added/changed across all commits
- `--lines-current`: Count by lines currently remaining in the codebase (using git blame)
- `--show-counts`: Display the actual counts next to contributor names
- `--help`, `-h`: Show help message

## Output Format

The generated file follows this format:

```text
Made by the following team:

* Most Active Contributor
* Second Most Active Contributor
* Third Most Active Contributor
* ...

```

With `--show-counts`, the format includes metrics:

```text
Made by the following team:

* Alice Johnson (127 commits)
* Bob Smith (89 lines currently in codebase)
* Charlie Brown (1,234 lines added/changed)
* ...

```

## How Each Method Works

### `--commits` (Default)

1. Analyzes all commits in the current Git repository
2. Extracts author names from commit messages
3. Counts commits per author
4. Sorts by commit count (descending)

### `--lines-added`

1. Uses `git log --numstat` to get line changes for each commit
2. Sums added and deleted lines for each author across all commits
3. Provides a measure of total code contribution volume
4. Sorts by total lines changed (descending)

### `--lines-current`

1. Uses `git blame` on all text files in the repository
2. Counts how many lines each author has in the current codebase
3. Shows current ownership/responsibility for the code
4. Excludes binary files automatically
5. Sorts by current line count (descending)

## Use Cases

- **Website credits**: Add a `humans.txt` file to your website's root directory
- **Project documentation**: Include contributor credits in project documentation
- **Team recognition**: Generate a list of team members sorted by contribution
- **Annual reports**: Create contributor summaries for yearly reviews

## Examples

```bash
# Generate and save humans.txt
makeHumansTxt > humans.txt

# Preview the output
makeHumansTxt

# Generate for a specific directory
cd /path/to/project && makeHumansTxt > humans.txt

# Combine with other information
echo "/* Our amazing team */" > humans.txt
makeHumansTxt >> humans.txt
echo "/* Visit https://example.com */" >> humans.txt
```

## Requirements

- Git repository with commit history
- Standard Unix utilities (awk, sort)

## About humans.txt

The `humans.txt` file is a web standard (<http://humanstxt.org/>) that provides a way to credit the people behind a website. It's typically placed in the root directory of a website and can be referenced in HTML with:

```html
<link type="text/plain" rel="author" href="humans.txt" />
```

## Notes

- The script considers all commits in the repository history
- Author names are extracted exactly as they appear in Git commits
- Contributors with different email addresses but same names are treated as separate entries
- The output includes asterisks (*) as bullet points for each contributor
- Empty lines are included for proper formatting
