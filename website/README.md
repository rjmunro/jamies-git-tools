# Git Tools Documentation Website

This directory contains a VitePress-based documentation website for Jamie's Git Tools.

## Setup

1. **Install dependencies:**

   ```bash
   yarn install
   ```

2. **Create documentation symlinks:**

   ```bash
   ./copy-docs.sh
   ```

   This creates a symlink from `tools/` to `../doc/` so documentation stays in sync automatically.

3. **Start development server:**

   ```bash
   yarn dev
   ```

## Commands

- `yarn dev` - Start development server with hot reload
- `yarn build` - Build static site for production
- `yarn preview` - Preview the built site locally

## Structure

```
website/
├── .vitepress/
│   └── config.js          # VitePress configuration
├── tools/                 # Symlink to ../doc/
├── index.md              # Homepage
├── installation.md       # Installation guide
└── package.json          # Dependencies
```

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch via GitHub Actions (`.github/workflows/deploy-docs.yml`).

## Updating Documentation

Since `tools/` is symlinked to `../doc/`, any changes to the markdown files in the `doc/` directory will automatically be reflected in the website. No manual copying needed!

## Configuration

Edit `.vitepress/config.js` to:
- Update navigation and sidebar
- Change site title/description
- Modify GitHub repository links
- Adjust theme settings
