# git-make-changelog

Generate a well-formatted changelog from git history, organizing commits by version tags.

## Overview

This script analyzes your git repository's commit history and generates a markdown-formatted changelog. It automatically:

- Groups commits by version tags (newest to oldest)
- Shows unreleased changes since the last tag (or labels them with upcoming version)
- Formats pull request merges with clickable links (when on GitHub)
- Includes tag dates
- Generates comparison links between versions
- Filters out release commits (`chore(release):`)
- Supports conventional commits with category grouping

The output follows a clean changelog format that's perfect for `CHANGELOG.md` files in your projects.

## Prerequisites

- Python 3
- Git repository with tags
- Works best with GitHub repositories (generates PR links)

## Usage

### Basic Usage

Generate a changelog for your current repository:

```bash
git make-changelog
```

This will output the changelog to stdout, organized with the most recent changes first.

### Save to File

Save the generated changelog to a file:

```bash
git make-changelog > CHANGELOG.md
```

### Options

```bash
git make-changelog --help                        # Show help
git make-changelog --no-group                    # Don't group by commit type
git make-changelog --unreleased-version v1.3.0   # Label unreleased as v1.3.0
```

## Output Format

The script generates output in this format:

```markdown
## Unreleased

* New feature added
* Bug fix implemented
* Some improvement ([#123](https://github.com/user/repo/pull/123))

## [v1.2.0] - 2025-11-15
[v1.2.0]: https://github.com/user/repo/compare/v1.1.0...v1.2.0
* Feature X added ([#120](https://github.com/user/repo/pull/120))
* Bug fix for Y
* Documentation updates

## [v1.1.0] - 2025-10-01
[v1.1.0]: https://github.com/user/repo/compare/v1.0.0...v1.1.0
* Initial feature set
```

### Features

1. **Unreleased Section**: Shows all commits since the last tag
2. **Version Headers**: Each tag gets a section with the version name and date
3. **Comparison Links**: GitHub compare links between versions (clickable in markdown viewers)
4. **PR Detection**: Automatically formats "Merge pull request #123" commits with proper titles
5. **Release Commit Filtering**: Skips `chore(release):` commits to reduce noise

## How It Works

1. **Tag Discovery**: Scans git history for all tags using `git log --decorate`
2. **Date Extraction**: Gets tag dates from annotated tags or commit dates
3. **Commit Grouping**: Groups commits between each pair of tags
4. **PR Formatting**: Extracts PR numbers and titles from merge commit messages
5. **Link Generation**: Creates GitHub comparison and PR links when applicable

## Use Cases

### Creating Initial CHANGELOG.md

For projects that don't have a changelog yet:

```bash
git make-changelog > CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: add changelog"
```

### Updating Before Release

Generate a preview of what's changed since the last release:

```bash
git make-changelog | head -30
```

This shows the "Unreleased" section with all changes since the last tag.

### Release Notes

Extract just the unreleased changes for release notes:

```bash
git make-changelog | sed -n '/^## Unreleased/,/^## \[/p' | head -n -1
```

## Tag Handling

The script recognizes various tag formats:

- `v1.2.3` - Standard semantic version with 'v' prefix
- `1.2.3` - Semantic version without prefix
- `v0.3.1-beta` - Pre-release versions
- Any other tag format

Tags are processed in the order they appear in git history (newest first).

## Notes

- Uses `--first-parent` to follow the main branch history, ignoring feature branch commits
- Works best when pull requests are merged (not squashed) to preserve PR information
- GitHub URLs are auto-detected from the `origin` remote
- Supports SSH, HTTPS, and git:// URL formats
- Empty or release-only sections are automatically cleaned up

## Limitations

- Only detects GitHub repositories (no GitLab/Bitbucket link generation yet)
- PR title extraction depends on standard merge commit format
- Requires tags to exist in the repository
- Only follows first-parent history (merge commits)

## Tips

1. **Tag Consistently**: Use semantic versioning tags (v1.2.3) for best results
2. **Descriptive PRs**: Use clear PR titles - they become changelog entries
3. **Regular Updates**: Run after each release to keep changelog current
4. **Manual Editing**: The generated output can be manually edited to add context

## Example Workflow

```bash
# Make changes and merge PRs
git checkout main
git pull

# Preview unreleased changes
git make-changelog | head -20

# Generate changelog with version header (before tagging)
git make-changelog --unreleased-version v1.3.0 > CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: update changelog for v1.3.0"

# Now create the release tag (includes the changelog commit)
git tag v1.3.0
git push origin v1.3.0 --follow-tags
```

## Part of Jamie's Git Tools

This script is part of [Jamie's Git Tools](https://github.com/rjmunro/jamies-git-tools) - a collection of utilities for Git workflow automation.
