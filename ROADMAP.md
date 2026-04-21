# vibe-cli-kit Roadmap

目标：把 `vibe-cli-kit` 从“终端工具一键安装脚本”升级成“面向 vibe-coding 的跨平台终端工作台”。

核心原则：

- 先做高频工作流，不先堆更多工具
- 先做安全同步和诊断，再做更激进的自动化
- 先覆盖 `macOS / Linux / WSL` 共同路径，再做平台特化
- 每一阶段都必须可独立发布

## MVP

目标：从“装完能用”提升到“装完就能开始写代码”。

### 1. `v doctor`

用途：

- 检查命令是否已安装
- 检查 `~/.zshrc` 受管区块是否存在
- 检查 `tmux` / `yazi` / `ghostty` 配置是否已落地
- 检查 cheatsheet 和脚本是否已安装到 `~/.local/bin`
- 输出缺失项、异常项、修复建议

验收标准：

- `v doctor` 能输出 `ok / warn / fail`
- 缺失工具不会直接报错退出
- 能区分“未安装”“已跳过”“平台不支持”“配置缺失”

### 2. `v sync`

用途：

- 重新同步 `templates/` 到本地配置目录
- 支持 `--dry-run`
- 支持只同步某类配置，例如 `--only tmux`

验收标准：

- 不重新安装包，只同步配置
- 输出变更摘要
- 对已存在文件支持 `overwrite / skip / backup`

### 3. `v update`

用途：

- `brew` 下执行升级
- `apt` 下执行更新与升级
- 同步重装本项目配置

验收标准：

- 能识别当前平台和包管理器
- 单个工具升级失败时不中断整段流程
- 结尾输出 `updated / skipped / unavailable`

### 4. `fzf + rg + nvim` 工作流命令

建议命令：

- `e`：模糊打开文件
- `fif`：全文搜索并跳转打开
- `p`：快速跳项目目录

验收标准：

- `e` 基于 `rg --files | fzf`
- `fif` 基于 `rg + fzf + nvim`
- 对中文路径、空格路径可正常工作

## V2

目标：从“个人终端环境”提升到“项目级工作流入口”。

### 1. 统一主命令 `v`

建议子命令：

- `v doctor`
- `v sync`
- `v update`
- `v session`
- `v open`
- `v project`

说明：

- 当前已有的 `tmx` / `tmn` / `tma` / `tml` 可以保留
- 新的 `v` 负责统一收口高层动作

验收标准：

- `v --help` 清晰
- 子命令调用失败时给出明确错误信息
- 老命令继续兼容

### 2. 场景化 tmux workspace

建议预设：

- `v session code`
- `v session backend`
- `v session frontend`
- `v session ai`

示例布局：

- `code`：左侧编辑器，右上 shell，右下 git
- `backend`：server / tests / logs
- `frontend`：dev / build / git
- `ai`：agent pane / code pane / logs pane

验收标准：

- 新 session 自动命名
- 支持复用已存在 session
- 不强依赖某单一语言栈

### 3. 项目识别

识别规则：

- `package.json` -> Node
- `pyproject.toml` -> Python
- `Cargo.toml` -> Rust
- `go.mod` -> Go

行为：

- 自动推断默认 dev 命令
- 自动推断测试命令
- 自动推断合适的 tmux workspace

验收标准：

- 未识别项目时有通用回退逻辑
- 不误覆盖用户已有脚本

### 4. 配置备份与 diff

建议命令：

- `v backup`
- `v diff`

用途：

- 覆盖前自动备份旧配置
- 查看模板和本地配置差异

验收标准：

- 备份目录统一
- diff 输出可读
- 不修改用户工作文件

## V3

目标：从“终端工作流”提升到“更极客的 vibe-coding 平台”。

### 1. profile 安装体系

建议 profile：

- `base`
- `node`
- `python`
- `rust`
- `go`
- `ai`

用途：

- 基础工具默认装
- 栈相关工具按 profile 安装

候选工具：

- Node: `fnm` / `volta` / `pnpm`
- Python: `uv` / `ruff`
- Rust: `cargo-binstall` / `just`
- Go: `air` / `golangci-lint`
- AI: `aider` / `llm` / agent helper wrappers

验收标准：

- `install.sh --profile xxx`
- 多 profile 可组合
- 各 profile 都有文档和回退行为

### 2. AI / Agent 入口

方向：

- 统一常用 agent 命令入口
- 给 agent 预留 tmux workspace
- 内置 prompt snippets
- 支持 review / commit / fix / explain 这类高频任务入口

验收标准：

- 不把具体平台写死
- 没安装相关 agent 时自动跳过
- 能和 `v session ai` 配合

### 3. 更完整的终端美学与性能

方向：

- `fastfetch` 默认配置模板
- `btop` 主题和默认配置
- 更强的 shell prompt
- 历史共享、去重、目录跳转优化

验收标准：

- 不显著拖慢 shell 启动
- 新主题和默认终端保持一致

## 不做什么

当前阶段不建议优先做：

- 过多 shell alias
- 平台强绑定 GUI 自动化
- 太重的 dotfiles 框架迁移
- 复杂插件市场
- 大而全的语言运行时全集成

原因：

- 容易把项目做成“配置垃圾场”
- 会稀释当前最强价值：轻量、清晰、开箱即用

## 建议实施顺序

1. `v doctor`
2. `v sync`
3. `v update`
4. `e` / `fif` / `p`
5. `v` 主命令
6. `v session`
7. 项目识别
8. 备份与 diff
9. profile 安装
10. AI/Agent 入口

## 首批 issue 拆分建议

### Issue 1

标题：Add `v doctor` for installation and config health checks

范围：

- 新增 `templates/bin/v`
- 新增 `doctor` 子命令
- 检查工具、配置、脚本、shell 集成

### Issue 2

标题：Add `v sync` with dry-run and selective config sync

范围：

- 抽取配置同步逻辑
- 支持 `--only`
- 支持 `--backup`

### Issue 3

标题：Add `e` and `fif` for file open and content search workflow

范围：

- `e`: `rg --files | fzf | nvim`
- `fif`: `rg` 结果交给 `fzf` 再打开

### Issue 4

标题：Add `v session` with code/backend/frontend/ai layouts

范围：

- 预设 tmux 布局
- 支持项目名自动命名 session

### Issue 5

标题：Add install profiles for Node/Python/Rust/Go/AI

范围：

- `install.sh --profile`
- profile 文档
- 工具可用性适配
