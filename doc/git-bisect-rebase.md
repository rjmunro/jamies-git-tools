# git-bisect-rebase

A script that attempts to rebase the current branch onto a target branch, and if the rebase fails
due to conflicts, uses `git bisect` to find the latest commit that can be successfully rebased onto.

## Overview

When rebasing a long-running feature branch onto a target branch (like `main` or `develop`),
conflicts can arise that make the rebase difficult or impossible to complete. This script
intelligently handles such situations by:

1. First attempting a direct rebase
2. If that fails, using `git bisect` to find the latest commit in your branch that can be
   successfully rebased onto the target branch without conflicts
3. Performing the rebase up to that successful point
4. Automatically handling uncommitted changes by stashing and restoring them

Once you have found the latest commit that can be rebased cleanly, you can exammine the tree and see
what specifically caused the conflict. You can rebase try resolving the conflicts at that point for
the one single issue.

## Usage

```bash
git bisect-rebase <target-branch>
```

## Parameters

- `<target-branch>`: The branch to rebase onto (e.g., `main`, `develop`, `origin/main`)

## How It Works

### Phase 1: Direct Rebase Attempt

1. Stashes any uncommitted changes (if present)
2. Attempts to rebase the current branch directly onto the target branch
3. If successful, restores stashed changes and exits

### Phase 2: Bisect-Assisted Rebase (if direct rebase fails)

1. Aborts the failed rebase
2. Finds the common ancestor between the current branch and target branch
3. Uses `git bisect` to binary search for the latest commit that can be rebased onto successfully
4. Tests each commit by attempting a rebase (using an internal test function)
5. Once the optimal commit is found, performs the rebase to that point

## Examples

```bash
# Rebase current feature branch onto main
git bisect-rebase main

# Rebase onto a remote branch
git bisect-rebase origin/develop

# Rebase onto a specific branch
git bisect-rebase release/v2.0
```

## Use Cases

- **Long-running feature branches**: When your branch has diverged significantly from the main branch
- **Complex merge conflicts**: When a direct rebase results in too many conflicts to resolve manually
- **Incremental rebasing**: When you want to rebase as much as possible without getting stuck on conflicts
- **Branch maintenance**: Keeping feature branches reasonably up-to-date with minimal manual intervention

## What Happens During Bisect

The script uses an internal test function that:

1. Attempts to rebase the current commit being tested
2. Returns "good" (exit 0) if the rebase succeeds
3. Returns "bad" (exit 1) if the rebase fails
4. Automatically cleans up and restores the original state after each test

## Requirements

- Git repository with at least two branches
- Standard Git tools (`git bisect`, `git rebase`, `git stash`)
- Bash shell environment

## Important Notes

- **Uncommitted changes**: The script automatically stashes and restores uncommitted changes
- **Bisect cleanup**: After completion, run `git bisect reset` to clean up the bisect state
- **Partial success**: Even if not all commits can be rebased, you'll get as many as possible

## Workflow Example

```bash
# Starting scenario: feature branch with 20 commits, conflicts prevent full rebase
git checkout feature/new-api
git bisect-rebase main
```

You can then try to rebase onto the first unsuccessful commit found by the bisect:

```bash
git rebase bisect-bad
```

This will hopefully present you with a simpler conflict to resolve. Once you have resolved any
conflicts, you can try the rebase again from that point.

## Cleanup

After the script completes, make sure to clean up:

```bash
git bisect reset
```
