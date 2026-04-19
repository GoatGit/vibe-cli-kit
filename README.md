# vibe-cli-kit

Cross-platform terminal environment bootstrap for macOS, Linux, and WSL.

[![Platforms](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-1f6feb)](#notes)
[![Package Managers](https://img.shields.io/badge/pkg-brew%20%7C%20apt-2da44e)](#notes)
[![Languages](https://img.shields.io/badge/i18n-English%20%7C%20简体中文%20%7C%20日本語-f59e0b)](#this-repository-supports-three-languages)

This repository supports three languages:

- English: [README.en.md](README.en.md)
- 简体中文: [README.zh-CN.md](README.zh-CN.md)
- 日本語: [README.ja.md](README.ja.md)

## Includes

- CLI tools: `yazi` `tmux` `fzf` `fd` `ripgrep` `lazygit` `glow` and more
- Terminal defaults: `ghostty`, `tmux`, `yazi`
- Shell helpers: `hk` `tmx` `tmn` `tma` `tml` `y`
- Localized cheatsheets: English, Simplified Chinese, Japanese

## Quick Install

```sh
sh install.sh
source ~/.zshrc
```

## Quick Verify

```sh
hk
tmn
y
nvim .
```

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
