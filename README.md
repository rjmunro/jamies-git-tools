# Jamie's Git Tools

This repository contains various scripts designed to help with git operations:

## 🚀 Advanced Git Operations

Sophisticated tools that solve complex Git workflow problems:

- [git-bisect-rebase](doc/git-bisect-rebase.md) - **★** Uses git bisect to intelligently find the most
  recent commit that can be successfully rebased onto without conflicts.
- [git-resolve-formatting-conflicts](doc/git-resolve-formatting-conflicts.md) - **★** Automatically
  resolves git merge conflicts caused by code formatting changes using automated formatting tools.

## 🔍 Code Analysis & History

Tools for exploring code history and understanding changes:

- [git-grep-blame](doc/git-grep-blame.md) - **★** Combines git grep and git blame to show who last
  modified each line matching a search pattern - perfect for code archaeology.
- [git-diff-sed](doc/git-diff-sed.md) - **★** Applies sed transformations to the old version of a
  file before running git diff to ignore systematic changes like variable renames.
- [git-diff-byte-count](doc/git-diff-byte-count.md) - Compares meaningful code size between
  commits by stripping comments and whitespace before measuring — useful for validating refactors.
- [git-branch-space-report](doc/git-branch-space-report.md) - Reports disk space used by each
  branch to identify storage-heavy branches.

## ✂️ Staging & Commit Management

Tools for fine-grained control over what gets committed:

- [git-clean-whitespace](doc/git-clean-whitespace.md) - Removes whitespace-only changes from staging
  to focus commits on logical changes.
- [git-clean-nonwhitespace](doc/git-clean-nonwhitespace.md) - Corollary of the above. Removes
  non-whitespace changes from staging, leaving only whitespace changes staged for separate commits.

## 🛠️ Development Workflow

Tools for daily development tasks and project management:

- [git-all](doc/git-all.md) - Run a git command across all repositories in the current directory.
- [git-checkout-default](doc/git-checkout-default.md) - Fetch all remotes and checkout the configured
  default branch.
- [git-rebase-all](doc/git-rebase-all.md) - Generates rebase commands for all tip branches to keep
  them up-to-date with a base branch.
- [watch-ci](doc/watch-ci.md) - Monitors CI status of a branch and provides desktop/audio
  notifications when builds complete.
- [git-log-with-ci-status](doc/git-log-with-ci-status.md) - Shows recent git log with inline CI
  status icons — a one-shot snapshot of which commits are passing or failing.
- [listgits](doc/listgits.md) - Quickly lists all git repositories in your home directory.
- [makeHumansTxt](doc/makeHumansTxt.md) - Generates a humans.txt file listing contributors
  ordered by commit count.

## Installation

To use these git tools, you need to make the scripts in the `bin/` directory available in your
system's `PATH`. Here are the recommended approaches:

### Option 1: Add bin Directory to PATH (Recommended)

This approach allows you to use the scripts directly from this repository without copying files.

1. **Clone or download this repository to a permanent location:**

   ```bash
   git clone <repository-url> ~/git-tools
   cd ~/git-tools
   ```

2. **Add the bin directory to your PATH by adding this line to your shell configuration file** (e.g., `~/.bashrc`, `~/.zshrc`, `~/.profile`):

   ```bash
   export PATH="$HOME/git-tools/bin:$PATH"
   ```

3. **Reload your shell configuration:**

   ```bash
   source ~/.bashrc  # Or your respective shell config file
   ```

### Option 2: Create Symbolic Links

Create symbolic links to the scripts in a directory that's already in your PATH:

```bash
# Create ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin

# Create symbolic links for all scripts
for script in bin/*; do
    ln -sf "$(pwd)/$script" ~/.local/bin/
done
```

### Option 3: Copy Scripts to Local Bin

Copy all scripts to your local bin directory:

```bash
# Create ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin

# Copy all scripts
cp bin/* ~/.local/bin/
```

### Verification

After installation, open a new terminal and verify the tools are available:

```bash
git resolve-formatting-conflicts --help
listgits --help
# etc.
```

## Usage

Each tool has its own documentation in the `doc/` folder. See the individual documentation files for
specific usage instructions and examples.
