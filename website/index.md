---
layout: home

hero:
  name: "Jamie's Git Tools"
  text: "Powerful Git utilities and scripts"
  tagline: "Sophisticated tools that solve complex Git workflow problems"
  actions:
    - theme: brand
      text: Get Started
      link: /installation
    - theme: alt
      text: View Tools
      link: /tools/

features:
  - icon: 🚀
    title: Advanced Git Operations
    details: Sophisticated tools like git-bisect-rebase that intelligently solve complex rebase conflicts and git-resolve-formatting-conflicts for automated conflict resolution.

  - icon: 🔍
    title: Code Analysis & History
    details: Powerful tools like git-grep-blame for code archaeology and git-diff-sed for filtering systematic changes in diffs.

  - icon: ✂️
    title: Staging & Commit Management
    details: Fine-grained control over commits with tools to separate whitespace and logical changes.

  - icon: 🛠️
    title: Development Workflow
    details: Daily development helpers including CI monitoring, repository discovery, and contributor tracking.
---

## Why These Tools?

This collection includes some genuinely innovative solutions to Git workflow challenges:

- **★ git-bisect-rebase** - Combines git bisect with rebase to automatically find optimal rebase points
- **★ git-resolve-formatting-conflicts** - Automated conflict resolution for formatting changes
- **★ git-grep-blame** - Code archaeology tool combining grep and blame efficiently
- **★ git-diff-sed** - Intelligent diff filtering for systematic changes

## Quick Start

1. **Install the tools:**
   ```bash
   git clone <repository-url> ~/git-tools
   echo 'export PATH="$HOME/git-tools/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

2. **Try a powerful tool:**
   ```bash
   # Find who added TODO comments
   git grep-blame "TODO"

   # Intelligently rebase with conflict resolution
   git bisect-rebase main
   ```

## Categories

All tools are organized by purpose to help you find what you need:

- **🚀 Advanced Git Operations** - Complex workflow solutions
- **🔍 Code Analysis & History** - Understanding code changes
- **✂️ Staging & Commit Management** - Precise commit control
- **🛠️ Development Workflow** - Daily development helpers
