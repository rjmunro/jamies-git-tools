# git-log-with-ci-status

Show recent git log entries with inline CI status icons — a one-shot snapshot of which commits on
a branch are passing, failing, or pending.

## Overview

Unlike [`watch-ci`](/tools/watch-ci), which watches a branch and waits for CI to finish,
`git-log-with-ci-status` gives you an instant summary of the CI state for recent commits. This is
useful for a quick health check of a branch, or for finding the most recent green commit.

## Prerequisites

- [`hub`](https://github.com/github/hub) CLI tool

## Usage

```bash
git log-with-ci-status [options] [<branch>]
```

## Parameters

- `<branch>`: Branch or ref to log (default: current branch)

## Options

- `-n <count>`: Number of commits to show (default: 30)
- `-h, --help`: Show help message and exit

## Examples

```bash
# Check CI status on current branch
git log-with-ci-status

# Check a specific branch
git log-with-ci-status main

# Show only the last 10 commits
git log-with-ci-status -n 10

# Check a remote tracking branch
git log-with-ci-status -n 5 origin/main
```

## Output Format

Each commit is shown on one line with its SHA, CI status icon, and subject:

```text
a1b2c3d: ✓ Fix login redirect bug
e5f6g7h: ✗ Add payment integration
i9j0k1l: ○ Update dependencies
m2n3o4p: ? Refactor auth module
```

## Icons

| Icon | Meaning |
|------|---------|
| `✓` | CI passed (success) |
| `✗` | CI failed |
| `○` | CI is running (pending) |
| `?` | No CI status found |

## See Also

- [`watch-ci`](/tools/watch-ci) — Watch a branch and get notified when CI finishes
