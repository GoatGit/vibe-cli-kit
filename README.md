# vibe-cli-kit

## **Build on the shoulders of giants, with a shovel in hand.**

vibe-cli-kit is a cross-platform terminal workbench for macOS, Linux, and WSL, built to make terminal-first coding feel ready on day one.

It starts from a simple idea: use strong existing terminal tools, connect them with a thin layer of practical defaults, and keep the setup fast, usable, and easy to live with.

Instead of growing into a heavy personal framework, vibe-cli-kit gives you a lightweight baseline for daily terminal work. In one pass, it installs and configures `ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop`, plus shell helpers and a local cheatsheet.

[![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-1f6feb?style=flat)](#notes)
[![pkg](https://img.shields.io/badge/pkg-brew%20%7C%20apt-2da44e?style=flat)](#notes)
[![English README](https://img.shields.io/badge/README-English-1f6feb?style=flat)](README.en.md)
[![Chinese README](https://img.shields.io/badge/README-zh--CN-2da44e?style=flat)](README.zh-CN.md)
[![Japanese README](https://img.shields.io/badge/README-ja-f59e0b?style=flat)](README.ja.md)

## What You Get

- A pragmatic terminal baseline instead of a giant personal framework
- A coding-first workflow centered on `yazi`, `tmux`, `nvim`, `ripgrep`, and `lazygit`
- Ready-to-use terminal defaults for `ghostty`, `tmux`, and `yazi`
- Shell helpers like `v` `e` `fif` `p` `tmx` `tmn` `tma` `tml` `y`
- Localized cheatsheets in English, Simplified Chinese, and Japanese
- Cross-platform installer with `brew` / `apt`
- Built-in template store plus `v doctor` / `v backup` / `v diff` / `v sync` / `v update` / `v project` / `v session`
- Per-system adaptation: unavailable tools are skipped and reported
- End-of-run summary: installed / skipped / unavailable tools

## Quick Start

```sh
sh install.sh
source ~/.zshrc

v                            # open the local cheatsheet
v doctor                     # check tools and config status
v backup --only tmux         # back up tmux config only
v diff --only tmux           # compare tmux template and deployed config
v update --dry-run --no-sync # preview package updates without config sync
v project                    # detect project type and suggested commands
v sync --dry-run --only tmux # preview tmux config sync
v session code               # open the code workspace
e                            # fuzzy-pick a file and open with nvim
fif tmux                     # search content and jump to the hit
tmn                          # create/enter tmux session for current dir
y                            # open Yazi
nvim .                       # open current directory
```

## Languages

- English: [README.en.md](README.en.md)
- 简体中文: [README.zh-CN.md](README.zh-CN.md)
- 日本語: [README.ja.md](README.ja.md)

## Docs

- English guide: [README.en.md](README.en.md)
- 中文指南: [README.zh-CN.md](README.zh-CN.md)
- 日本語ガイド: [README.ja.md](README.ja.md)

## Notes

- Supported platforms: macOS, Linux, WSL
- Supported package managers: Homebrew, apt
- `ghostty` is only auto-installed on macOS
- Cheatsheets are installed in English, Simplified Chinese, and Japanese
- `v` / `terminal-cheatsheet` can auto-select language or accept `--lang`
