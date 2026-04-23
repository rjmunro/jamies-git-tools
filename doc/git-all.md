# git-all

Run a git command in all subdirectories containing `.git` folders.

## Overview

This utility allows you to execute the same git command across multiple repositories at once.
It's useful when you have a directory containing several git repositories and want to perform
bulk operations like fetching updates, checking status, or pulling changes.

## Usage

```bash
git all <command> [args...]
```

## Options

- `--help`, `-h`: Show help message and exit

## Arguments

- `<command>`: The git command to run (e.g., `fetch`, `status`, `pull`)
- `[args...]`: Additional arguments to pass to the git command

## Examples

```bash
# Fetch all remotes in all repos
git all fetch --all

# Show status of all repos
git all status

# Pull latest changes in all repos
git all pull

# Show branches with tracking info
git all branch -vv

# Show merged branches
git all branch --merged

# Prune deleted remote branches
git all fetch --prune
```

## How It Works

The script:

1. Finds all directories containing a `.git` folder in the current directory
2. For each repository found, prints a header with the directory name
3. Runs the specified git command in that directory
4. Exits with a non-zero code if any repository's command failed (but continues running in all repos regardless)
4. Exits with a non-zero code if any repository's command failed (but continues running in all repos regardless)

## Requirements

- Bash shell environment
- Git
- Must be run from a directory containing git repositories as subdirectories

## Use Cases

- **Bulk updates**: Fetch or pull updates across all your projects
- **Status overview**: Quickly check the status of multiple repos
- **Branch management**: View or clean up branches across repos
- **Maintenance**: Run garbage collection or other maintenance commands
