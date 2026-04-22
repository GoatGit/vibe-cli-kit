# vibe-cli-kit

## **Build on the shoulders of giants, with a shovel in hand.**

vibe-cli-kit is a cross-platform terminal workbench for macOS, Linux, and WSL, built to make terminal-first coding feel ready on day one.

It starts from a simple idea: use strong existing terminal tools, connect them with a thin layer of practical defaults, and keep the setup fast, usable, and easy to live with.

Instead of growing into a heavy personal framework, vibe-cli-kit gives you a lightweight baseline for daily terminal work. In one pass, it installs and configures `ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop`, plus shell helpers and a local cheatsheet.

## At a Glance

- Install tools and configs in one pass
- Stay light instead of becoming a giant dotfiles framework
- Focus on coding flow, not on collecting tools for their own sake
- Set up `ghostty`, `tmux`, and `yazi` with sane defaults
- Add helper commands like `v`, `e`, `fif`, `p`, `tmx`, `tmn`, `tma`, `tml`, `y`
- Support `brew` and `apt`
- Include a local template store with `v doctor`, `v backup`, `v diff`, `v sync`, `v update`, `v project`, and `v session`
- Adapt by system and skip unavailable tools cleanly
- Show installed / skipped / unavailable tools at the end

## Quick Start

```sh
sh install.sh
source ~/.zshrc

v
v doctor
v backup --only tmux
v diff --only tmux
v update --dry-run --no-sync
v project
v sync --dry-run --only tmux
v session code
e
fif tmux
tmn
y
nvim .
```

## Languages

- English: [README.en.md](README.en.md)
- Simplified Chinese: [README.zh-CN.md](README.zh-CN.md)
- Japanese: [README.ja.md](README.ja.md)

## Supported Platforms

- macOS
- Linux
- WSL

Supported package managers:

- Homebrew
- apt

Notes:

- macOS is expected to use Homebrew
- Ubuntu / Debian / WSL prefer apt by default
- On Linux / WSL, apt is preferred over Homebrew when both are present
- Other Linux distros currently need either `apt` or `brew`

## Installed Tools

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

Notes:

- `ghostty` is only auto-installed on macOS
- Linux / WSL skip `ghostty`
- Debian / Ubuntu / WSL automatically handle `batcat -> bat` and `fdfind -> fd`

## Installation

Dry run:

```sh
sh install.sh --dry-run
```

Config-only update:

```sh
sh install.sh --only-config
source ~/.zshrc
```

Help:

```sh
sh install.sh --help
```

## What It Writes

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

It also updates a managed block in `~/.zshrc`:

- `# >>> vibe-cli-kit >>>`
- `# <<< vibe-cli-kit <<<`

## Verify

```sh
source ~/.zshrc
v                            # open the local cheatsheet
v doctor                     # check tools and config status
v backup --only tmux         # back up tmux config only
v diff --only tmux           # compare tmux template and deployed config
v update --dry-run --no-sync # preview package updates without config sync
v project                    # detect project type and suggested commands
v sync --dry-run --only tmux # preview tmux config sync
v session code               # open the code workspace
e                            # fuzzy-pick a file and open with nvim
fif tmux                     # search content and jump to the hit
p                            # jump to a project directory
tmn                          # create/enter tmux session for current dir
y                            # open Yazi
tmx dev                      # enter the dev session
rg foo                       # search text globally
rg --files | fzf             # fuzzy-pick a file
z foo                        # jump to a frequent directory
lazygit                      # open Git TUI
nvim .                       # open current directory
glow README.en.md            # read the README with glow
```

## Default Workflow

### Terminal

- On macOS, Ghostty is the default recommended terminal
- Quick Terminal is bound to `Ctrl+grave`

### tmux

- Prefix: `Ctrl+a`
- `tmx`: smart session entry
- `tmn`: create/attach using the current directory name
- `tma`: attach/create a named session
- `tml`: list sessions

### Workflow Commands

- `v doctor`: check tools, configs, scripts, and shell integration
- `v backup --only tmux`: back up current deployed configs
- `v diff --only tmux`: compare deployed config with the template store
- `v update --dry-run --no-sync`: preview tool updates only
- `v project`: detect the current project type and print suggested commands
- `v sync --dry-run --only tmux`: preview config sync
- `v session code`: create or reuse a coding workspace
- `v session backend`: create or reuse a backend workspace
- `v session frontend`: create or reuse a frontend workspace
- `v session ai`: create or reuse an AI workspace
- `v sync --only yazi`: sync only Yazi configs
- `v sync --mode backup`: back up files before overwriting
- `e`: fuzzy-pick a file and open it in `nvim`
- `e README.md`: open a specific file directly in `nvim`
- `fif tmux`: search content and jump to the matching line
- `fif`: start interactive content search
- `p`: fuzzy-jump to a project directory
- `p vibe-cli-kit`: prefer `zoxide` or project-path matching

### Yazi

- `y` opens Yazi
- Exiting Yazi updates your shell cwd
- Text files open in `nvim`
- Markdown preview uses `bat --language=markdown`
- Other text previews use `bat`

### Markdown Reading

- Inside Yazi: preview with `bat`
- In the terminal: `glow file.md`

### Cheatsheet

- `v`
- `v doctor`
- `v backup --only tmux`
- `v diff --only tmux`
- `v update --dry-run --no-sync`
- `v project`
- `v sync --dry-run --only tmux`
- `v session code`
- `e`
- `fif tmux`
- `p`

Both open the localized cheatsheet. Language is selected from:

- `LANG`
- `LC_MESSAGES`
- `LC_ALL`

You can also override it manually:

```sh
VIBE_CLI_KIT_LANG=ja v
terminal-cheatsheet --lang en
terminal-cheatsheet --lang zh-CN
terminal-cheatsheet --lang ja
```

## Command Notes

### `v doctor`

Checks:

- template store presence
- deployed `ghostty` / `tmux` / `yazi` configs
- installed helper scripts: `terminal-cheatsheet`, `tmx`, `v`, `e`, `fif`
- managed block in `~/.zshrc`
- availability of key CLI tools

Output:

- `ok`: healthy
- `warn`: usable, but should be reviewed
- `fail`: incomplete install or broken config

### `v sync`

Purpose:

- resync configs from the local template store
- does not reinstall tools
- useful after template updates

Common flags:

- `--dry-run`
- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`
- `--mode overwrite|skip|backup`

Examples:

```sh
v sync --dry-run --only tmux
v sync --only shell
v sync --only bin --mode backup
v sync --mode skip
```

### `v diff`

Purpose:

- compare the local template store with deployed files
- make no file changes
- useful before running `sync`

Common flags:

- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`

Examples:

```sh
v diff
v diff --only tmux
v diff --only shell
```

### `v backup`

Purpose:

- save deployed configs into a timestamped backup directory
- avoid touching the current files
- useful before `sync` or manual edits

Common flags:

- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`

Examples:

```sh
v backup
v backup --only tmux
v backup --only shell
```

### `v update`

Purpose:

- upgrade project-related tools for the current platform
- upgrade brew formulas / casks one by one
- run `apt-get install --only-upgrade` one by one on apt systems
- resync configs by default after tool updates

Common flags:

- `--dry-run`
- `--no-sync`

Examples:

```sh
v update --dry-run --no-sync
v update --dry-run
v update
```

### `v session`

Purpose:

- create tmux workspaces from preset layouts
- reuse an existing session if the target name already exists
- use `switch-client` inside tmux and `attach-session` outside tmux

Layouts:

- `code`: yazi + shell + git
- `backend`: server + tests + git
- `frontend`: yazi + dev + git
- `ai`: yazi + agent + shell

Naming:

- `code` defaults to the current directory name
- other layouts default to `current-directory-layout`
- use `--name` to override, for example `v session ai --name semibot-ai`

Examples:

```sh
v session code
v session backend
v session frontend
v session ai
v session ai --name vibe-ai
```

Notes:

- the `code` layout starts `yazi` in the large left pane
- the `frontend` and `ai` layouts also use `yazi` in the large left pane
- opening a text file from `yazi` opens `nvim` in the same pane
- leaving `nvim` returns you to `yazi`
- `backend` / `frontend` try to preload default dev / test commands from the current project type

### `v project`

Purpose:

- detect the current project type
- print the preferred runner
- print suggested dev / test commands

Current detection:

- `package.json` -> Node
- `pyproject.toml` -> Python
- `Cargo.toml` -> Rust
- `go.mod` -> Go

Example:

```sh
v project
```

### `e`

Purpose:

- list files with `rg --files` or `fd`
- select with `fzf`
- open with `nvim`

Examples:

```sh
e
e README.en.md
```

### `fif`

Purpose:

- search content with `rg`
- select a match with `fzf`
- jump into `nvim` at the matching line

Examples:

```sh
fif tmux
fif install_yazi_plugins
fif
```

### `p`

Purpose:

- jump to project directories quickly
- direct `cd` if an explicit directory is given
- otherwise try `zoxide query`
- otherwise fuzzy-pick git repos from common project roots

Default roots:

- `$HOME/AI`
- `$HOME/Code`
- `$HOME/Projects`
- `$HOME/workspace`
- `$HOME/src`

Override:

```sh
export VIBE_PROJECT_DIRS="$HOME/AI:$HOME/work:$HOME/src"
```

## Notes

- `v` prefers `bat`; falls back to `less`
- `vim` is aliased to `nvim`
- `--only-config` skips package installation
- `--dry-run` prints actions without changing the system
- `v sync` uses `~/.config/vibe-cli-kit/templates/` as the local template store
- `v backup` writes to `~/.config/vibe-cli-kit/backups/<timestamp>/`
- `v diff` compares only the managed block when used with `--only shell`
- `v update` keeps going item by item so one failed upgrade does not stop the whole run
- `v session` creates tmux workspaces rooted at the current directory
- `p` is a shell function because it needs to change the current shell directory
- GUI app casks already present in `/Applications` are skipped on macOS

## Maintenance

Key templates live under `templates/`:

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
