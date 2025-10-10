# listgits

A simple script to list all Git repositories found in your home directory.

## Overview

This script searches for Git repositories by looking for `.git` directories in common locations
under your home directory. It provides a quick way to see all the Git repositories you have on your
system.

## Usage

```bash
listgits
```

## How It Works

The script searches for `.git` directories in:

- Direct subdirectories of your home directory (`~/*/.git`)
- Second-level subdirectories (`~/*/*/.git`)

For each `.git` directory found, it outputs the parent directory path (the actual repository
directory).

## Output Example

```text
/Users/username/project1
/Users/username/work/project2
/Users/username/personal/project3
```

## Use Cases

- **Repository inventory**: Get a quick overview of all Git repositories on your system
- **Cleanup**: Identify repositories you might want to archive or delete
- **Backup planning**: Generate a list of repositories to include in backups
- **Script input**: Use the output as input for other scripts that operate on multiple repositories

## Examples

```bash
# List all repositories
listgits

# Count total repositories
listgits | wc -l

# Find repositories in specific paths
listgits | grep work

# Use with other git tools (example)
for repo in $(listgits); do
  echo "Status of $repo:"
  # -C tells git to run in the specified directory
  git -C "$repo" status --porcelain
done
```

## Requirements

- Unix-like system with bash
- Git repositories in standard locations under home directory

## Limitations

- Only searches two levels deep under the home directory
- Only finds repositories with `.git` directories (not bare repositories)
- Does not search outside the home directory
- May not find repositories in hidden directories (except `.git` itself)

## Notes

- The script uses shell globbing to find `.git` directories
- Output includes full absolute paths to repository directories
- Empty lines in output indicate that some glob patterns didn't match any directories
