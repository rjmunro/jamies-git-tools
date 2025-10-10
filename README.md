# Jamie's Git Tools

This repository contains various scripts designed to help with git operations:

- [git-bisect-rebase](doc/git-bisect-rebase.md) - A script that uses git bisect to find the most
  recent commit that can be successfully rebased onto without conflicts.
- [git-branch-space-report](doc/git-branch-space-report.md) - A script to report the disk space used
  by each branch.
- [git-clean-nonwhitespace](doc/git-clean-nonwhitespace.md) - A script to remove all non-whitespace
  characters from the working directory.
- [git-clean-whitespace](doc/git-clean-whitespace.md) - A script to remove all whitespace characters
  from the working directory.
- [git-rebase-all](doc/git-rebase-all.md) - A script to rebase all branches onto the current branch.
- [git-resolve-formatting-conflicts](doc/git-resolve-formatting-conflicts.md) - A script to help
  resolve git merge conflicts caused by code formatting changes.
- [listgits](doc/listgits.md) - A script to list all git repositories in a directory.
- [makeHumansTxt](doc/makeHumansTxt.md) - A script to generate a humans.txt file.
- [watch-ci](doc/watch-ci.md) - A script to watch the CI status of a repository.

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
