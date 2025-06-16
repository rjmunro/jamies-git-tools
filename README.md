# Git Resolve Formatting Conflicts

This repository contains a simple bash script designed to automate or partially automate the
resolution of common Git merge conflicts that arise purely from differences in code formatting
within source code files, particularly when those differences are due to an automated code
formatting tool.

## Overview

When merging or rebasing Git branches, particularly a code formatting tool such as prettier has been
added to the workflow or recently had its configuration changed, developers often encounter
conflicts where the underlying code logic is the same, but the formatting (indentation, line breaks,
brace style, etc.) differs between the branches. Manually resolving these "formatting conflicts" can
be time-consuming and error prone.

This script streamlines this process by:

1. Identifying conflicted files.
2. Extracting the "base" (common ancestor), "ours" (current branch), and "theirs" (incoming branch)
   versions of each conflicted file.
3. Applying a code formatting tool to all three versions.
4. Performing a three-way merge on these _formatted_ versions, which typically resolves purely
   formatting-related differences automatically.
5. Saving the resolved, formatted file back into your working directory.
6. Running `git add` on the file if there are no further conflicts

## Prerequisites

Before running this script, ensure you have configured the ESLint and Prettier code formatters. You
can use other code formatters if you modify the script - Pull requests are welcome to add support
for more code formatting tools.

## Installation

1. **Save the script:** Save the provided bash script (`git-resolve-formatting-conflicts`) or link
    it to a location on your $PATH (e.g., in a `bin/` folder).

2. **Ensure it is executable:**

```bash
chmod +x git-resolve-formatting-conflicts
```

## Usage

When you have a conflict during a git merge or git rebase operation, run the script:

```bash
git resolve-formatting-conflicts
```

The script will process all conflicted files. If it successfully resolves a conflict, the file will
be updated in your working tree, and the resolution will be staged ready to continue the merge. If
actual logic conflicts remain after formatting, the file will still show merge conflict markers, but
the surrounding code will be consistently formatted, making manual resolution easier.

## Important Notes

- This script is most effective for conflicts that are _solely_ due to formatting differences.

- If genuine code logic conflicts exist alongside formatting differences, the script will still
  format the code, but `git merge-file` might leave conflict markers for the logical discrepancies.
  You will then need to resolve these remaining conflicts manually.

- It's a good idea to inspect the changes after running the script (`git diff --cached`) to ensure
  the resolution is as expected.
