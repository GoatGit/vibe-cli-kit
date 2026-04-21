# vibe-cli-kit

Build on the shoulders of giants, with a shovel in hand.

vibe-cli-kit is a cross-platform terminal workbench for vibe-coding on macOS, Linux, and WSL.

[![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-1f6feb)](#notes)
[![Package Managers](https://img.shields.io/badge/pkg-brew%20%7C%20apt-2da44e)](#notes)
[![English](https://img.shields.io/badge?label=English&message=README&color=1f6feb)](README.en.md)
[![简体中文](https://img.shields.io/badge?label=%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87&message=README&color=2da44e)](README.zh-CN.md)
[![日本語](https://img.shields.io/badge?label=%E6%97%A5%E6%9C%AC%E8%AA%9E&message=README&color=f59e0b)](README.ja.md)

The goal is simple: start from proven terminal tools, wire them together with practical defaults, and make daily coding flow faster without turning your setup into a dotfiles maze.

Install and configure `ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop` and a local cheatsheet in one pass.

## What You Get

- A pragmatic terminal baseline instead of a giant personal framework
- A coding-first workflow centered on `yazi`, `tmux`, `nvim`, `ripgrep`, and `lazygit`
- Ready-to-use terminal defaults for `ghostty`, `tmux`, and `yazi`
- Shell helpers like `hk` `v` `e` `fif` `p` `tmx` `tmn` `tma` `tml` `y`
- Localized cheatsheets in English, Simplified Chinese, and Japanese
- Cross-platform installer with `brew` / `apt`
- Built-in template store plus `v doctor` / `v backup` / `v diff` / `v sync` / `v update` / `v project` / `v session`
- Per-system adaptation: unavailable tools are skipped and reported
- End-of-run summary: installed / skipped / unavailable tools

## Quick Start

```sh
sh install.sh
source ~/.zshrc

hk                           # open the local cheatsheet
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
- `hk` / `terminal-cheatsheet` can auto-select language or accept `--lang`
