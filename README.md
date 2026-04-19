# vibe-cli-kit

一键安装并配置一套高频效率命令行工具：

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

同时安装：

- `ghostty` / `yazi` / `tmux` 默认配置
- `tmx` 智能 tmux 入口
- `hk` / `hotkeys` 快捷帮助命令
- `zsh` 集成：`atuin`、`zoxide`、`fzf`、`y`、`tmux` 辅助函数，以及 `vim -> nvim`

## 用法

```sh
sh install.sh
```

安装完成后执行：

```sh
source ~/.zshrc
```

## 结果

- 配置文件写入 `~/.config` 与 `~/.tmux.conf`
- 帮助文档写入 `~/.config/cheatsheets/terminal-cheatsheet.md`
- 命令脚本写入 `~/.local/bin`
- `~/.zshrc` 追加一段受管配置块

## 常用命令

```sh
hk
tmx
tmn
tma
tml
y
z foo
zi
nvim
rg foo
lazygit
```
