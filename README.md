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

- [git-rebase-all](doc/git-rebase-all.md) - Generates rebase commands for all tip branches to keep
  them up-to-date with a base branch.
- [watch-ci](doc/watch-ci.md) - Monitors CI status of a branch and provides desktop/audio
  notifications when builds complete.
- [listgits](doc/listgits.md) - Quickly lists all git repositories in your home directory.
- [makeHumansTxt](doc/makeHumansTxt.md) - Generates a humans.txt file listing contributors
  ordered by commit count.

## Installation

### Windows (Git Bash)

For Windows users, we provide an automated PowerShell installer:

```powershell
.\windows-setup\Install-Tools.ps1 -Install
```

See [windows-setup/README.md](windows-setup/README.md) for detailed Windows installation instructions.

### Linux/macOS

**Quick install:** Add the bin directory to your PATH by adding this to `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="/path/to/jamies-git-tools/bin:$PATH"
```

See [website/installation.md](website/installation.md) for complete installation options including symbolic links and copying scripts.

### Verification

After installation, open a new terminal and verify the tools are available:

```bash
git resolve-formatting-conflicts --help
listgits --help
```

## Usage

Each tool has its own documentation in the `doc/` folder. See the individual documentation files for
specific usage instructions and examples.
