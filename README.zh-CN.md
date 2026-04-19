# vibe-cli-kit

一键安装并配置一套跨平台终端工作环境，支持 macOS、Linux、WSL。

它会同时安装命令行工具、终端配置、Yazi 预览方案、tmux 配置，以及本地快捷帮助文档。

## 语言

- 英文：`README.en.md`
- 简体中文：`README.zh-CN.md`
- 日文：`README.ja.md`

## 支持范围

当前脚本支持这些运行环境：

- macOS
- Linux
- WSL

当前自动识别并支持的包管理器：

- Homebrew
- apt

说明：

- macOS 推荐 Homebrew
- Ubuntu / Debian / WSL 推荐 apt
- 其他 Linux 发行版如果没有 `brew` 或 `apt`，当前脚本会直接报不支持

## 安装的工具

- `ghostty`
- `yazi`
- `lsd`
- `bat`
- `tmux`
- `fzf`
- `fd`
- `atuin`
- `zoxide`
- `nvim`
- `ripgrep`
- `lazygit`
- `rich-cli`
- `glow`

说明：

- `ghostty` 目前只自动安装在 macOS
- Linux / WSL 下会自动跳过 `ghostty`
- Debian / Ubuntu / WSL 下，脚本会自动处理 `batcat -> bat`、`fdfind -> fd` 的兼容问题

## 安装

标准安装：

```sh
sh install.sh
source ~/.zshrc
```

只预演，不真正执行：

```sh
sh install.sh --dry-run
```

只更新配置和脚本，不安装工具：

```sh
sh install.sh --only-config
source ~/.zshrc
```

查看帮助：

```sh
sh install.sh --help
```

## 会写入什么

- `~/.config/ghostty/config`
- `~/.config/yazi/yazi.toml`
- `~/.config/yazi/package.toml`
- `~/.config/cheatsheets/terminal-cheatsheet.en.md`
- `~/.config/cheatsheets/terminal-cheatsheet.zh-CN.md`
- `~/.config/cheatsheets/terminal-cheatsheet.ja.md`
- `~/.tmux.conf`
- `~/.local/bin/terminal-cheatsheet`
- `~/.local/bin/tmx`

并更新 `~/.zshrc` 中的受管配置块：

- `# >>> vibe-cli-kit >>>`
- `# <<< vibe-cli-kit <<<`

## 安装后验证

```sh
source ~/.zshrc
hk
tmn
y
tmx dev
rg foo
rg --files | fzf
z foo
lazygit
nvim .
glow README.zh-CN.md
```

## 默认工作流

### 终端

- macOS 下推荐使用 Ghostty
- `Ctrl+grave` 可呼出 Quick Terminal

### tmux

- 前缀：`Ctrl+a`
- `tmx`：智能进入 session
- `tmn`：以当前目录名创建或进入 session
- `tma`：attach 或新建指定 session
- `tml`：列出 session

### Yazi

- `y` 启动 Yazi
- 退出后 shell 会切到最后浏览目录
- 文本文件默认用 `nvim` 打开
- Markdown 预览走 `bat --language=markdown`
- 其他文本预览也走 `bat`

### Markdown 阅读

- 在 Yazi 里：预览走 `bat`
- 在终端里：`glow file.md`

### 帮助文档

- `hk`
- `hotkeys`

会自动根据系统语言选择对应 cheatsheet，也可以手动指定：

```sh
terminal-cheatsheet --lang en
terminal-cheatsheet --lang zh-CN
terminal-cheatsheet --lang ja
```

## 说明

- `hk` 默认优先用 `bat`，没有时回退到 `less`
- `vim` 默认映射到 `nvim`
- `--only-config` 不安装工具
- `--dry-run` 只打印动作，不真正写系统
- macOS 下如果 `/Applications` 已有 GUI App，会跳过对应 cask

## 维护

主要模板在 `templates/`：

- `templates/ghostty/config`
- `templates/tmux/tmux.conf`
- `templates/yazi/yazi.toml`
- `templates/yazi/package.toml`
- `templates/shell/zshrc.snippet`
- `templates/cheatsheets/`
- `templates/bin/terminal-cheatsheet`
- `templates/bin/tmx`
