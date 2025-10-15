# git-resolve-formatting-conflicts

This script is designed to automate the resolution of Git merge conflicts that arise from
changes in code formatting caused by a code formatting tool.

## Overview

When merging or rebasing Git branches, particularly when a code formatting tool such as Prettier has
been added to the workflow or recently had its configuration changed, developers often encounter
conflicts where the underlying code logic is the same, but the formatting (indentation, line breaks,
brace style, etc.) differs between the branches. Manually resolving these "formatting conflicts" can
be time-consuming and error prone.

This script streamlines this process by:

1. Identifying conflicted files (optionally filtered by file globs)
2. Extracting the "base" (common ancestor), "ours" (current branch), and "theirs" (incoming branch)
   versions of each conflicted file
3. Applying code formatting tools (Prettier and ESLint) to all three versions
4. Performing a three-way merge on these _formatted_ versions, which typically resolves purely
   formatting-related differences automatically
5. Saving the resolved, formatted file back into your working directory
6. Automatically staging the file with `git add` if there are no remaining conflicts

## Prerequisites

Before running this script, ensure you have:

- **Node.js and npm/npx** installed (required for Prettier and ESLint)
- **Prettier** configured in your project (the script uses `npx prettier`)
- **ESLint** configured for JavaScript/TypeScript files (optional, used for .js, .jsx, .ts, .tsx, .vue files)

The script automatically detects and applies:

- **ESLint --fix** for JavaScript, TypeScript, and Vue files (.js, .jsx, .ts, .tsx, .vue)
- **Prettier --write** for all file types (Prettier will skip unsupported file types)

You can use other code formatters by modifying the script - Pull requests are welcome to add support
for more code formatting tools.

## Usage

### Basic Usage

When you have conflicts during a git merge or git rebase operation, run the script:

```bash
git resolve-formatting-conflicts
```

### Advanced Usage

The script supports several options for more control:

```bash
# Process only specific file patterns
git resolve-formatting-conflicts "*.js" "src/**/*.ts"

# Remove indentation after formatting (useful for structural conflicts)
git resolve-formatting-conflicts --remove-indentation

# Show file paths relative to current directory
git resolve-formatting-conflicts --relative

# Run from current directory (when config files are here, not in repo root)
git resolve-formatting-conflicts --relative

# Combine options
git resolve-formatting-conflicts --remove-indentation --relative "*.js" "*.ts"

# Show help
git resolve-formatting-conflicts --help
```

### Options

- `--remove-indentation`: Removes all leading whitespace from lines (except for .md, .txt, .py
  files). Useful when conflicts are caused by code being wrapped in new blocks (like if statements).
  You should re-run your formatter after using this option to restore proper indentation.
- `--relative`: Run formatting tools from current directory instead of repository root. Use this
  when your ESLint/Prettier configuration files are located in the current directory rather than the
  repository root. This ensures formatters can find their config files and work correctly in
  monorepos or projects with multiple formatter configurations.
- `--help` or `-h`: Display usage information
- `file-glob ...`: Only process conflicted files matching the specified glob patterns

## How It Works

1. **Detection**: Finds all files in merge conflict state using `git diff --diff-filter=U`
2. **Filtering**: Optionally filters files by provided glob patterns
3. **Processing**: For each conflicted file:
   - Extracts the base (common ancestor) version
   - Extracts the "theirs" (incoming) version  
   - Extracts the "ours" (current) version
   - Applies formatting to each version in the actual file location (so formatters can find their config files)
   - Performs a three-way merge using `git merge-file`
4. **Staging**: Automatically stages files where conflicts were completely resolved

The script will process all conflicted files. If it successfully resolves a conflict, the file will
be updated in your working tree, and the resolution will be staged ready to continue the merge. If
actual logic conflicts remain after formatting, the file will still show merge conflict markers, but
the surrounding code will be consistently formatted, making manual resolution easier.

## When to Use `--relative`

Use the `--relative` option when your formatting tool configuration files (.eslintrc, .prettierrc,
etc.) are **not** in the repository root:

- **Monorepos**: When you have multiple packages/projects, each with their own formatter configs
- **Subdirectory projects**: When the main project lives in a subdirectory of the Git repository
- **Multiple configs**: When different parts of your repo use different formatting rules

**Example scenario**: Your repo structure is:

```text
my-repo/
├── packages/
│   ├── frontend/
│   │   ├── eslint.config.mjs  ← Config here, not repo root
│   │   └── src/
│   └── backend/
│       └── src/
└── README.md
```

Run from `packages/frontend/` with `--relative` so ESLint finds its config file.

## Important Notes

⚠️ **This is a powerful tool that modifies files automatically. Always work on a branch and have backups!**

- **Purpose**: This script is specifically designed for resolving conflicts that are purely due to
  formatting differences (whitespace, semicolons, etc.). It won't help with semantic conflicts.

- **Three-way merge process**: The script extracts and formats all three versions (base, ours,
  theirs) then uses Git's merge algorithm to combine them. This often eliminates conflicts that are
  purely formatting-related.

- **Automatic staging**: Files where conflicts are completely resolved are automatically staged and
  ready for commit.

- **Mixed conflicts**: If genuine code logic conflicts exist alongside formatting differences, the
  script will still format the code, but `git merge-file` might leave conflict markers for the
  logical discrepancies. You will then need to resolve these remaining conflicts manually.

- **Manual review required**: Always review the results before committing. It's recommended to
  inspect the changes after running the script (`git diff --cached`) to ensure the resolution is as
  expected.

- **Remove indentation option**: The `--remove-indentation` flag removes all leading whitespace
  (except from .md, .txt, .py files) which can help resolve conflicts where code has been wrapped in
  new control structures. Re-run your formatter after using this option.

- **File filtering**: When using glob patterns, the script only processes conflicted files that
  match the patterns. This allows you to focus on specific files or directories.

- **Formatter requirements**: Ensure your project has proper configuration files (.eslintrc,
  .prettierrc, etc.) as the script runs formatters in the actual file locations to find these
  configs.
