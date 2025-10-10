# watch-ci

A script to monitor the CI (Continuous Integration) status of a Git branch and provide notifications when the CI process completes.

## Overview

This script continuously monitors the CI status of a specified branch using GitHub's `hub` command-line tool. It will wait for pending CI jobs to complete and then notify you of the final status through desktop notifications and audio alerts (on supported platforms).

## Usage

```bash
# Watch CI status of current branch
watch-ci

# Watch CI status of a specific branch
watch-ci <branch-name>
```

## Parameters

- `<branch-name>`: The branch to monitor (default: current branch)

## How It Works

1. Determines which branch to monitor (current branch if not specified)
2. Checks the CI status using `hub ci-status`
3. If status is "pending" or "no status", waits 15 seconds and checks again
4. Once CI completes (success, failure, or error), provides notifications
5. Opens the pull request page in your browser
6. Exits with the same code as the CI status

## Notifications

The script provides different types of notifications based on your platform:

### macOS

- Desktop notification via `terminal-notifier`
- Audio notification via `say` command
- Opens PR page in default browser

### Linux

- Desktop notification via `notify-send` (preferred) or `zenity`
- Opens PR page in default browser

### Windows (MinGW/Git Bash)

- PowerShell-based desktop notification
- Text-to-speech notification
- Opens PR page in default browser

## Examples

```bash
# Monitor current branch
watch-ci

# Monitor a specific feature branch
watch-ci feature/new-login

# Monitor a remote branch
watch-ci origin/develop
```

## Requirements

### Essential

- `hub` command-line tool (<https://github.com/github/hub>)
- Git repository with GitHub integration
- Branch with CI configured

### Platform-specific (for notifications)

**macOS:**

- `terminal-notifier` (install via `brew install terminal-notifier`)

**Linux:**

- `notify-send` (usually part of libnotify-bin package) or `zenity`

**Windows:**

- PowerShell (included with Windows)

## Use Cases

- **Long-running CI**: Monitor CI status without manually refreshing the GitHub page
- **Background work**: Get notified when CI completes while working on other tasks
- **Team workflow**: Ensure CI passes before merging pull requests
- **Automated workflows**: Integrate into scripts that depend on CI status

## Exit Codes

The script exits with the same code as the CI status:

- `0`: CI success
- `1`: CI failure
- `2`: CI error/timeout

## Notes

- The script polls every 15 seconds while CI is pending
- Browser opens automatically to the pull request page when CI completes
- Audio notifications help when working in other applications
- The script handles cases where there's no CI configured ("no status")
- Requires proper GitHub authentication for the `hub` command
