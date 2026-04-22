# Terminal Cheatsheet

已集成：Ghostty、Yazi、lsd、bat、tmux、fzf、fd、atuin、zoxide、Neovim、ripgrep、lazygit、rich-cli、glow、fastfetch、btop。

## 高频命令

- `v`：无参数打开这份速查表
- `v doctor`：检查工具和配置状态
- `v project`：识别当前项目类型和建议命令
- `v session code`：打开 `code` 工作区
- `e`：模糊选文件并用 `nvim` 打开
- `fif tmux`：搜内容并直接跳到命中位置
- `p`：快速跳项目目录
- `tmn`：当前目录开/进 tmux session
- `y`：打开 Yazi
- `rg foo`：全局搜索文本
- `z foo`：快速跳目录
- `lazygit`：打开 Git TUI
- `nvim .`：打开当前目录

## Shell

- `v` / `hk` / `hotkeys`：打开速查表
- `v doctor`：检查安装和配置状态
- `v backup --only tmux`：备份当前 tmux 配置
- `v diff --only tmux`：看模板和当前配置差异
- `v sync --dry-run --only tmux`：预览 tmux 配置同步
- `v update --dry-run --no-sync`：只预览工具升级
- `v project`：识别项目类型并给出建议命令
- `v session code|backend|frontend|ai`：创建或复用工作区
- `p`：快速跳项目目录
- `ll`：等价于 `lsd -lah`
- `vim`：等价于 `nvim`

## tmux

前缀：`Ctrl+a`

- `Ctrl+a d`：detach
- `Ctrl+a c`：新建 window
- `Ctrl+a %`：左右分屏
- `Ctrl+a "`：上下分屏
- `Ctrl+a h/j/k/l`：切 pane
- `Ctrl+a H/J/K/L`：调整 pane 大小
- `Ctrl+a Enter`：复制模式
- `Ctrl+a r`：重载配置
- `Ctrl+a x` / `X`：关闭 pane / window

复制模式：`v` 选中，`y` 复制并退出

## Ghostty

- `Cmd+t`：新标签页
- `Cmd+w`：关闭当前标签/分屏
- `Cmd+d`：向右分屏
- `Cmd+Shift+d`：向下分屏
- `Cmd+Alt+←/→/↑/↓`：切换分屏
- `Cmd+Shift+e`：平均分屏
- `Cmd+Shift+f`：放大/还原分屏
- `Cmd+Shift+←/→`：切标签页
- `Cmd+Shift+,`：重载配置
- `Ctrl+grave`：呼出 Quick Terminal

## Yazi

- `y`：打开 Yazi
- `j/k`：上下移动
- `h/l`：上级目录 / 进入目录
- `g` / `G`：跳开头 / 结尾
- `/`：搜索
- `Space`：选中
- `c/x/p`：复制 / 剪切 / 粘贴
- `r`：重命名
- `d`：删除
- `o` / `Enter`：打开
- `q`：退出

## Search

- `Ctrl+r`：模糊搜历史命令
- `Ctrl+t`：模糊插入文件路径
- `Alt+c`：模糊切目录
- `rg foo`：全局搜索文本
- `rg -i foo`：忽略大小写搜索
- `rg -n foo`：显示行号
- `rg --files`：列出文件
- `rg --files | fzf`：模糊选文件
- `bat file`：带高亮查看文件
- `fd . | fzf`：模糊选文件或目录

## Edit / Git

- `nvim`：打开 Neovim
- `nvim .`：打开当前目录
- `nvim file`：编辑文件
- `e`：模糊选文件后打开
- `fif foo`：搜内容并跳到命中位置
- `lazygit`：打开 Git TUI
- `glow file.md`：单独阅读 Markdown 文档

## Jump

- `p`：从常见项目目录里模糊选择
- `p foo`：优先用 `zoxide` 或项目名匹配
- `z foo`：跳到常用目录
- `zi`：交互式跳目录
- `tmx [name]`：进入指定 tmux session，默认 `main`
- `tmx dev`：进入 `dev` session
- `tmn`：用当前目录名创建或进入 session
- `tma`：attach `main`
- `tml`：列出全部 sessions
