# Terminal Cheatsheet

已集成：Ghostty、Yazi、lsd、bat、tmux、fzf、fd、atuin、zoxide、Neovim、ripgrep、lazygit。

紧凑版，按安装后的默认配置整理。

## tmux

前缀：`Ctrl+a`

| 键/命令 | 作用 |
| --- | --- |
| `tmx` | 进 `main`；存在则 attach，不存在则创建 |
| `tmx dev` | 进 `dev` 会话；存在则 attach，不存在则创建 |
| `tmn` | 用当前目录名创建或进入 session |
| `tma` | attach `main`；不存在就创建 |
| `tml` | 列出全部 sessions |
| `Ctrl+a d` | detach |
| `Ctrl+a c` | 新建 window |
| `Ctrl+a %` | 左右分屏 |
| `Ctrl+a "` | 上下分屏 |
| `Ctrl+a h/j/k/l` | 切 pane |
| `Ctrl+a H/J/K/L` | 调整 pane 大小 |
| `Ctrl+a Enter` | 复制模式 |
| `Ctrl+a r` | 重载配置 |

## Ghostty

| 键 | 作用 |
| --- | --- |
| `Cmd+t` | 新标签页 |
| `Cmd+w` | 关闭当前标签/分屏 |
| `Cmd+d` | 向右分屏 |
| `Cmd+Shift+d` | 向下分屏 |
| `Cmd+Alt+←/→/↑/↓` | 切换分屏 |
| `Cmd+Shift+e` | 平均分屏 |
| `Cmd+Shift+f` | 放大/还原分屏 |
| `Cmd+Shift+←/→` | 切标签页 |
| `Cmd+Shift+,` | 重载配置 |
| `Ctrl+\`` | 呼出 Quick Terminal |

## Yazi

| 键/命令 | 作用 |
| --- | --- |
| `y` | 启动 Yazi |
| `j/k` | 上下移动 |
| `h/l` | 上级目录 / 进入目录 |
| `/` | 搜索 |
| `Space` | 选中 |
| `c/x/p` | 复制 / 剪切 / 粘贴 |
| `r` | 重命名 |
| `d` | 删除 |
| `q` | 退出 |

## fzf / fd / bat / lsd

| 键/命令 | 作用 |
| --- | --- |
| `Ctrl+r` | 模糊搜历史命令 |
| `Ctrl+t` | 模糊插入文件路径 |
| `Alt+c` | 模糊切目录 |
| `rg --files \| fzf` | 模糊找文件 |
| `rg foo` | 全局文本搜索 |
| `fd . \| fzf` | 模糊找文件/目录 |
| `bat file` | 带高亮查看文件 |
| `lsd -lah` | 更友好的 `ls` |

## atuin / zoxide

| 键/命令 | 作用 |
| --- | --- |
| `Ctrl+r` | atuin 历史搜索 |
| `z foo` | 跳到常用目录 |
| `zi` | 交互式跳目录 |

## nvim / ripgrep / lazygit

| 键/命令 | 作用 |
| --- | --- |
| `nvim` | 打开 Neovim |
| `nvim file` | 编辑文件 |
| `rg foo` | 用 ripgrep 搜内容 |
| `rg --files` | 列文件 |
| `lazygit` | 打开 Git TUI |

## Shell 入口

| 命令 | 作用 |
| --- | --- |
| `hk` / `hotkeys` | 打开速查表 |
| `tmx` | 智能进入 tmux session |
| `tmn` | 以当前目录名创建 tmux session |
| `tma` | attach 或创建指定 session |
| `tml` | 列出 tmux sessions |
| `y` | 打开 Yazi |
| `ll` | `lsd -lah` |
| `vim` | `nvim` |
