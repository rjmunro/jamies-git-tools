# git-checkout-default

Fetch all remotes and checkout the configured default branch.

## Overview

This command provides a quick way to return to your project's default branch after working
on a feature branch. It fetches all remotes first to ensure you have the latest changes,
then checks out the configured default branch.

The default branch can be configured per-repository, which is useful when different projects
use different branch naming conventions (e.g., `main`, `master`, `develop`, or release branches).

## Usage

```bash
git checkout-default
```

## Options

- `--help`, `-h`: Show help message and exit

## Configuration

Set the default branch for a repository:

```bash
git config custom.defaultbranch <branch>
```

If not configured, the command defaults to `origin/main`.

## Examples

```bash
# Checkout the default branch
git checkout-default

# Configure default branch for a project using develop
git config custom.defaultbranch origin/develop

# Configure default branch for a release branch workflow
git config custom.defaultbranch origin/release53

# Configure default branch for a project using master
git config custom.defaultbranch origin/master
```

## How It Works

1. Fetches all remotes (`git fetch --all`)
2. Reads the configured default branch from `custom.defaultbranch`
3. If not configured, uses `origin/main` as the default
4. Checks out the default branch

## Requirements

- Bash shell environment
- Git repository

## Use Cases

- **Returning to main branch**: Quickly switch back after finishing feature work
- **Starting fresh**: Ensure you're on the latest default branch before creating a new feature branch
- **Different defaults per project**: Configure different defaults for projects with different workflows
