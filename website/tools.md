# Git Tools

This page provides an overview of all available tools, organized by category.

## 🚀 Advanced Git Operations

Sophisticated tools that solve complex Git workflow problems:

### git-bisect-rebase ★

Uses git bisect to intelligently find the most recent commit that can be successfully rebased onto without conflicts.

[View Documentation →](tools/git-bisect-rebase)

### git-resolve-formatting-conflicts ★

Automatically resolves git merge conflicts caused by code formatting changes using automated formatting tools.

[View Documentation →](tools/git-resolve-formatting-conflicts)

### git-rebase-all

Generates rebase commands for all tip branches to keep them up-to-date with a base branch.

[View Documentation →](tools/git-rebase-all)

## 🔍 Code Analysis & History

Tools for exploring code history and understanding changes:

### git-grep-blame ★

Combines git grep and git blame to show who last modified each line matching a search pattern - perfect for code archaeology.

[View Documentation →](tools/git-grep-blame)

### git-diff-sed ★

Applies sed transformations to the old version of a file before running git diff to ignore systematic changes like variable renames.

[View Documentation →](tools/git-diff-sed)

### git-branch-space-report

Reports disk space used by each branch to identify storage-heavy branches.

[View Documentation →](tools/git-branch-space-report)

## ✂️ Staging & Commit Management

Tools for fine-grained control over what gets committed:

### git-clean-nonwhitespace

Removes non-whitespace changes from staging, leaving only whitespace changes staged for separate commits.

[View Documentation →](tools/git-clean-nonwhitespace)

### git-clean-whitespace

Removes whitespace-only changes from staging to focus commits on logical changes.

[View Documentation →](tools/git-clean-whitespace)

## 🛠️ Development Workflow

Tools for daily development tasks and project management:

### watch-ci

Monitors CI status of a branch and provides desktop/audio notifications when builds complete.

[View Documentation →](tools/watch-ci)

### listgits

Quickly lists all git repositories in your home directory.

[View Documentation →](tools/listgits)

### makeHumansTxt

Generates a humans.txt file listing contributors ordered by commit count.

[View Documentation →](tools/makeHumansTxt)
