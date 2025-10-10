# Git Resolve Formatting Conflicts

This repository contains a simple bash script designed to automate or partially automate the
resolution of common Git merge conflicts that arise from changes in code formatting.

## Overview

When merging or rebasing Git branches, particularly when a code formatting tool such as prettier has
been added to the workflow or recently had its configuration changed, developers often encounter
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

To use `git resolve-formatting-conflicts`, you need to place the `git-resolve-formatting-conflicts`
script in a directory that is included in your system's `PATH` environment variable. Here are a few
recommended approaches:

### Option 1: User's Local Bin Directory (Recommended for Most Users)

This is generally the cleanest and most widely accepted method for user-specific executables, as it
doesn't require root privileges and keeps your system's global directories tidy.

1. **Create the directory (if it doesn't exist):**

   ```bash
   mkdir -p ~/.local/bin
   ```

2. **Copy the script:**

   ```bash
   cp git-resolve-formatting-conflicts ~/.local/bin/
   ```

3. **Ensure `~/.local/bin` is in your `PATH`:** Most modern Linux distributions and macOS setups
   automatically include `~/.local/bin` in the `PATH` for new shell sessions. If `git
   resolve-formatting-conflicts` isn't found after a fresh terminal, you might need to add the
   following line to your shell's configuration file (e.g., `~/.bashrc`, `~/.zshrc`, `~/.profile`):

   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc # Or ~/.zshrc, ~/.profile
   source ~/.bashrc # Or your respective shell config file
   ```

   _Note: You may need to open a new terminal session for the changes to take effect._

### Option 2: System-Wide Bin Directory (For System Administrators / Shared Machines)

If you want `git-resolve-formatting-conflicts` to be available to all users on the system, you can
place it in a system-wide binary directory. This typically requires administrative (sudo)
privileges.

1. **Move the script (requires sudo):**

    ```bash
    sudo mv git-resolve-formatting-conflicts /usr/local/bin/
    ```

    `/usr/local/bin/` is generally preferred over `/usr/bin/` for software installed manually or
    from source, to avoid conflicts with package manager-managed files.

### Option 3: Git's Core Extension Directory (Advanced / Less Common)

Git itself looks for scripts in specific directories. While less common for general
`git-resolve-formatting-conflicts` type scripts, it's an option for deeply integrated extensions.

1. **Find your Git installation's `execpath`:**

    ```bash
    git --exec-path
    ```

    This will usually output something like `/usr/lib/git-core` or similar.

2. **Move the script to a relevant subdirectory (requires sudo if system-wide):**

    ```bash
    # Example, adjust based on your git --exec-path output
    sudo mv git-resolve-formatting-conflicts /usr/lib/git-core/
    ```

    _Caution: Modifying Git's core directories directly can sometimes lead to issues during Git
    updates. Use with care._

### Verification

After installation, open a new terminal and try running:

```bash
git resolve-formatting-conflicts
```

If you see the output from your script, it's successfully installed!

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
