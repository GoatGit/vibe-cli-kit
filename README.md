# vibe-cli-kit

One-command terminal setup kit for macOS, Linux, and WSL.

[![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-1f6feb)](#notes)
[![Package Managers](https://img.shields.io/badge/pkg-brew%20%7C%20apt-2da44e)](#notes)
[![English](https://img.shields.io/badge?label=English&message=README&color=1f6feb)](README.en.md)
[![简体中文](https://img.shields.io/badge?label=%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87&message=README&color=2da44e)](README.zh-CN.md)
[![日本語](https://img.shields.io/badge?label=%E6%97%A5%E6%9C%AC%E8%AA%9E&message=README&color=f59e0b)](README.ja.md)

Install and configure `ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop` and a local cheatsheet in one pass.

## What You Get

- Ready-to-use terminal defaults for `ghostty`, `tmux`, and `yazi`
- Shell helpers like `hk` `v` `e` `fif` `p` `tmx` `tmn` `tma` `tml` `y`
- Localized cheatsheets in English, Simplified Chinese, and Japanese
- Cross-platform installer with `brew` / `apt`
- Built-in template store plus `v doctor` / `v sync`
- Per-system adaptation: unavailable tools are skipped and reported
- End-of-run summary: installed / skipped / unavailable tools

## Quick Start

```sh
sh install.sh
source ~/.zshrc

hk
v doctor
v sync --dry-run --only tmux
e
fif tmux
tmn
y
nvim .
```

## Languages

- English: [README.en.md](README.en.md)
- 简体中文: [README.zh-CN.md](README.zh-CN.md)
- 日本語: [README.ja.md](README.ja.md)

## Docs

- English guide: [README.en.md](README.en.md)
- 中文指南: [README.zh-CN.md](README.zh-CN.md)
- 日本語ガイド: [README.ja.md](README.ja.md)
- Roadmap: [ROADMAP.md](ROADMAP.md)

## Notes

- Supported platforms: macOS, Linux, WSL
- Supported package managers: Homebrew, apt
- `ghostty` is only auto-installed on macOS
- Cheatsheets are installed in English, Simplified Chinese, and Japanese
- `hk` / `terminal-cheatsheet` can auto-select language or accept `--lang`
