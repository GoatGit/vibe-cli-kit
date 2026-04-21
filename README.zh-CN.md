# vibe-cli-kit

一个命令装好跨平台终端环境，支持 macOS、Linux、WSL。

它会一次性安装并配置 `ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop`，并写入 shell 快捷命令与本地帮助文档。

## 一眼看懂

- 一次执行，工具和配置一起装
- 默认配好 `ghostty`、`tmux`、`yazi`
- 附带 `hk` `v` `e` `fif` `p` `tmx` `tmn` `tma` `tml` `y` 等常用命令
- 同时支持 `brew` 和 `apt`
- 内置本地模板库，支持 `v doctor` 和 `v sync`
- 会按系统适配，不可用工具自动跳过并汇总
- 安装结束会汇总：已安装 / 已跳过 / 不可用

## 快速开始

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

## 语言

- 英文：[README.en.md](README.en.md)
- 简体中文：[README.zh-CN.md](README.zh-CN.md)
- 日文：[README.ja.md](README.ja.md)
- 路线图：[ROADMAP.md](ROADMAP.md)

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
- Ubuntu / Debian / WSL 默认优先 apt
- 在 Linux / WSL 上，如果 `apt` 和 `brew` 同时存在，会优先使用 `apt`
- 其他 Linux 发行版如果没有 `apt` 或 `brew`，当前脚本会直接报不支持

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
- `fastfetch`
- `btop`

说明：

- `ghostty` 目前只自动安装在 macOS
- Linux / WSL 下会自动跳过 `ghostty`
- Debian / Ubuntu / WSL 下，脚本会自动处理 `batcat -> bat`、`fdfind -> fd` 的兼容问题

## 安装

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
- `~/.local/bin/v`
- `~/.local/bin/e`
- `~/.local/bin/fif`
- `~/.config/vibe-cli-kit/templates/`

并更新 `~/.zshrc` 中的受管配置块：

- `# >>> vibe-cli-kit >>>`
- `# <<< vibe-cli-kit <<<`

## 安装后验证

```sh
source ~/.zshrc
hk
v doctor
v sync --dry-run --only tmux
e
fif tmux
p
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

### 工作流命令

- `v doctor`：检查工具、配置、脚本、shell 集成是否正常
- `v sync --dry-run --only tmux`：预览某类配置会怎么同步
- `v sync --only yazi`：只同步 Yazi 配置
- `v sync --mode backup`：同步前自动备份旧文件
- `e`：模糊选文件并用 `nvim` 打开
- `e README.md`：直接用 `nvim` 打开指定文件
- `fif tmux`：全文搜索 `tmux` 并跳到命中行
- `fif`：进入交互式全文搜索
- `p`：从常见项目目录中模糊选择项目并切换过去
- `p vibe-cli-kit`：优先用 `zoxide` 或项目目录匹配跳转

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
- `v doctor`
- `v sync --dry-run --only tmux`
- `e`
- `fif tmux`
- `p`

会自动根据系统语言选择对应 cheatsheet，也可以手动指定：

```sh
VIBE_CLI_KIT_LANG=ja hk
terminal-cheatsheet --lang en
terminal-cheatsheet --lang zh-CN
terminal-cheatsheet --lang ja
```

## 命令说明

### `v doctor`

用途：

- 检查模板库是否存在
- 检查 `ghostty` / `tmux` / `yazi` 配置是否落地
- 检查 `terminal-cheatsheet`、`tmx`、`v`、`e`、`fif` 是否已安装
- 检查 `~/.zshrc` 受管区块是否存在
- 检查常用工具命令是否可用

输出：

- `ok`：状态正常
- `warn`：不影响继续使用，但建议处理
- `fail`：安装或配置不完整

### `v sync`

用途：

- 用本地模板库重新同步配置
- 不重新安装工具
- 适合模板更新后重新下发到本机

常用参数：

- `--dry-run`：只预览，不落盘
- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`
- `--mode overwrite|skip|backup`

例子：

```sh
v sync --dry-run --only tmux
v sync --only shell
v sync --only bin --mode backup
v sync --mode skip
```

### `e`

用途：

- 基于 `rg --files` 或 `fd` 列文件
- 用 `fzf` 模糊选择
- 选择后直接用 `nvim` 打开

例子：

```sh
e
e README.zh-CN.md
```

### `fif`

用途：

- 基于 `rg` 搜索内容
- 用 `fzf` 选中命中项
- 直接跳进 `nvim` 对应行

例子：

```sh
fif tmux
fif install_yazi_plugins
fif
```

### `p`

用途：

- 快速切到项目目录
- 优先支持直接 `cd` 到已给定目录
- 其次尝试 `zoxide query`
- 再从常见项目根目录里筛选 git 仓库目录

默认扫描目录：

- `$HOME/AI`
- `$HOME/Code`
- `$HOME/Projects`
- `$HOME/workspace`
- `$HOME/src`

也可以自定义：

```sh
export VIBE_PROJECT_DIRS="$HOME/AI:$HOME/work:$HOME/src"
```

例子：

```sh
p
p vibe-cli-kit
p ~/AI/vibe-cli-kit
```

## 说明

- `hk` 默认优先用 `bat`，没有时回退到 `less`
- `vim` 默认映射到 `nvim`
- `--only-config` 不安装工具
- `--dry-run` 只打印动作，不真正写系统
- `v sync` 使用 `~/.config/vibe-cli-kit/templates/` 作为本地模板库
- `p` 会切换当前 shell 目录，所以它是 shell 函数，不是独立脚本
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
- `templates/bin/v`
- `templates/bin/e`
- `templates/bin/fif`
