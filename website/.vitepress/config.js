import { defineConfig } from 'vitepress'
import path from "path";

export default defineConfig({
  title: "Jamie's Git Tools",
  description: "A collection of powerful Git utilities and scripts",
  base: "/git-tools/",
  cleanUrls: true,

  themeConfig: {
    nav: [
      { text: "Home", link: "/" },
      { text: "Tools", link: "/tools" },
      { text: "GitHub", link: "https://github.com/yourusername/git-tools" },
    ],

    sidebar: [
      {
        text: "Getting Started",
        items: [
          { text: "Introduction", link: "/" },
          { text: "Installation", link: "/installation" },
        ],
      },
      {
        text: "🚀 Advanced Git Operations",
        collapsed: false,
        items: [
          { text: "git-bisect-rebase", link: "/tools/git-bisect-rebase" },
          {
            text: "git-resolve-formatting-conflicts",
            link: "/tools/git-resolve-formatting-conflicts",
          },
          { text: "git-rebase-all", link: "/tools/git-rebase-all" },
        ],
      },
      {
        text: "🔍 Code Analysis & History",
        collapsed: false,
        items: [
          { text: "git-grep-blame", link: "/tools/git-grep-blame" },
          { text: "git-diff-sed", link: "/tools/git-diff-sed" },
          {
            text: "git-branch-space-report",
            link: "/tools/git-branch-space-report",
          },
        ],
      },
      {
        text: "✂️ Staging & Commit Management",
        collapsed: false,
        items: [
          {
            text: "git-clean-nonwhitespace",
            link: "/tools/git-clean-nonwhitespace",
          },
          { text: "git-clean-whitespace", link: "/tools/git-clean-whitespace" },
        ],
      },
      {
        text: "🛠️ Development Workflow",
        collapsed: false,
        items: [
          { text: "watch-ci", link: "/tools/watch-ci" },
          { text: "listgits", link: "/tools/listgits" },
          { text: "makeHumansTxt", link: "/tools/makeHumansTxt" },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/rjmunro/git-tools" },
    ],

    footer: {
      message: "Released under the MIT License.",
      copyright: "Copyright © 2025 Robert (Jamie) Munro",
    },
  },
  vite: {
    resolve: {
      preserveSymlinks: true,
    },
  },
});
