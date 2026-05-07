# git-test-merge

Manage a temporary test-merge branch that combines multiple feature branches for integrated testing, with commit metadata tracking so changes can be automatically cherry-picked back to their target branches.

This implements a [GitButler](https://gitbutler.com/)-like workflow without needing GitButler.

## Overview

When working on multiple interdependent PRs, you often want to test them together. This tool lets you:

1. Merge feature branches into a `test-merge` branch for integrated testing
2. Make commits with `[target: branch]` metadata to record where they belong
3. Automatically cherry-pick those commits back to the correct branches
4. Recreate the test-merge branch as upstream branches evolve

## Prerequisites

- Python 3
- Git

## Usage

```
git test-merge status
git test-merge create <branch>...
git test-merge add <branch>...
git test-merge update [<branch>...]
git test-merge reset
git test-merge cherry-pick [--execute]
git test-merge install-hook
git test-merge uninstall-hook
git test-merge clean
```

## Subcommands

### `status`

Show the current state of the test-merge branch:
- Which branches are merged in and how far ahead of base they are
- How many commits have been tagged and cherry-picked
- Which cherry-picks are still pending

```bash
git test-merge status
```

### `create`

Create a new `test-merge` branch from the base branch and merge the specified branches into it using `--no-ff`.

```bash
git test-merge create feature-a feature-b feature-c
```

Fails if a `test-merge` branch already exists. Use `update` or `add` instead.

### `add`

Add more branches to an existing `test-merge` branch. If no `test-merge` branch exists, behaves like `create`.

```bash
git test-merge add feature-d
```

### `update`

Recreate `test-merge` from scratch with a new or updated branch list. If no branches are specified, uses the stored branch list.

```bash
git test-merge update feature-a feature-b feature-d
git test-merge update  # recreate with the same branches (picks up new commits)
```

Exits with an error if there are commits with `[target:]` tags that haven't been cherry-picked yet. Run `cherry-pick --execute` first.

### `reset`

Recreate `test-merge` from the stored branch list without prompting. Equivalent to `update` with no branch arguments.

```bash
git test-merge reset
```

### `cherry-pick`

Cherry-pick tagged commits to their target branches.

Dry-run by default — shows what would be applied without doing anything:

```bash
git test-merge cherry-pick
```

Use `--execute` to actually apply the cherry-picks:

```bash
git test-merge cherry-pick --execute
```

If a conflict occurs, the tool exits and leaves the repository in the standard `git cherry-pick` conflict state. Resolve the conflict, then:

```bash
git add <resolved-files>
git cherry-pick --continue
git checkout test-merge
git test-merge cherry-pick --execute  # continue with remaining commits
```

### `install-hook`

Install a `commit-msg` hook that enforces metadata on all commits to the `test-merge` branch. The hook prints an error with available target branches if a commit is missing the required tag.

```bash
git test-merge install-hook
```

Bypass for a specific commit with `git commit --no-verify`.

### `uninstall-hook`

Remove the `commit-msg` hook installed by `install-hook`.

```bash
git test-merge uninstall-hook
```

### `clean`

Remove the `.git/test-merge-meta` metadata file.

```bash
git test-merge clean
```

## Commit Message Format

Tag commits with target branch information in the commit message body:

```
Fix the alignment calculation

[target: feature-a]
```

For multiple targets:

```
Refactor shared utility

[target: feature-a, feature-b]
```

To explicitly mark a commit as test-only (no cherry-pick):

```
Temporary debug logging

[test-only]
```

## Configuration

Set a custom base branch (default: `origin/main`):

```bash
git config test-merge.base-branch origin/develop
```

## Metadata Storage

Branch list and cherry-pick history are stored in `.git/test-merge-meta` as JSON:

```json
{
  "base": "origin/main",
  "branches": ["feature-a", "feature-b"],
  "cherry_picked": ["abc1234", "def5678"]
}
```

This file is inside `.git/` and is not tracked by git.

## Example Workflow

```bash
# 1. Create a test-merge branch with your feature branches
git test-merge create feature-login feature-dashboard

# 2. Install the hook so you don't forget to tag commits
git test-merge install-hook

# 3. Work on test-merge, tagging commits appropriately
git commit -m "Fix auth redirect

[target: feature-login]"

git commit -m "Add loading spinner

[target: feature-dashboard]"

git commit -m "Temporary config tweak

[test-only]"

# 4. Preview what would be cherry-picked
git test-merge cherry-pick

# 5. Apply the cherry-picks
git test-merge cherry-pick --execute

# 6. Check remaining status
git test-merge status

# 7. Upstream branches got new commits — recreate test-merge
git test-merge update
```

## Integration with Other Jamie's Git Tools

- Use `git-bisect-rebase` if a cherry-pick conflict needs to be rebased onto the target branch
- Use `git-resolve-formatting-conflicts` if cherry-pick conflicts are formatting-related
- Use `git-rebase-all` after cherry-picking to rebase all branches onto the updated base
