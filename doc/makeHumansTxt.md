# makeHumansTxt

A script to generate a `humans.txt` file listing all contributors to a Git project, ordered by the number of commits they've made.

## Overview

This script analyzes the Git commit history to identify all contributors and generates a `humans.txt` file - a standard way to credit the people behind a website or project. Contributors are listed in order of their contribution volume (by commit count).

## Usage

```bash
makeHumansTxt
```

The script outputs the `humans.txt` content to standard output. To save it to a file:

```bash
makeHumansTxt > humans.txt
```

## Output Format

The generated file follows this format:

```text
Made by the following team:

* Most Active Contributor
* Second Most Active Contributor
* Third Most Active Contributor
* ...

```

## How It Works

1. Analyzes all commits in the current Git repository
2. Extracts author names from commit messages
3. Counts commits per author
4. Sorts authors by commit count (descending)
5. Formats the output as a `humans.txt` file

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
- `gcut` command (GNU cut) - may need to install via `brew install coreutils` on macOS
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
