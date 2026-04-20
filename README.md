# vibe-cli-kit

One-command terminal setup kit for macOS, Linux, and WSL.

[![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-1f6feb)](#notes)
[![Package Managers](https://img.shields.io/badge/pkg-brew%20%7C%20apt-2da44e)](#notes)
[![Languages](https://img.shields.io/badge/i18n-English%20%7C%20简体中文%20%7C%20日本語-f59e0b)](#this-repository-supports-three-languages)

Install and configure `ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` and a local cheatsheet in one pass.

## What You Get

- Ready-to-use terminal defaults for `ghostty`, `tmux`, and `yazi`
- Shell helpers like `hk` `tmx` `tmn` `tma` `tml` `y`
- Localized cheatsheets in English, Simplified Chinese, and Japanese
- Cross-platform installer with `brew` / `apt`
- End-of-run summary: installed / skipped / unavailable tools

## Quick Start

```sh
sh install.sh
source ~/.zshrc

hk
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

## Notes

- Supported platforms: macOS, Linux, WSL
- Supported package managers: Homebrew, apt
- `ghostty` is only auto-installed on macOS
- Cheatsheets are installed in English, Simplified Chinese, and Japanese
- `hk` / `terminal-cheatsheet` can auto-select language or accept `--lang`
