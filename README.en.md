# vibe-cli-kit

Cross-platform terminal environment bootstrap for macOS, Linux, and WSL.

It installs CLI tools, terminal configuration, Yazi preview settings, tmux defaults, and a local cheatsheet.

## Languages

- English: `README.en.md`
- Simplified Chinese: `README.zh-CN.md`
- Japanese: `README.ja.md`

## Supported Platforms

- macOS
- Linux
- WSL

Supported package managers:

- Homebrew
- apt

Notes:

- macOS is expected to use Homebrew
- Ubuntu / Debian / WSL are expected to use apt
- Other Linux distros currently need either `brew` or `apt`

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

Notes:

- `ghostty` is only auto-installed on macOS
- Linux / WSL skip `ghostty`
- Debian / Ubuntu / WSL automatically handle `batcat -> bat` and `fdfind -> fd`

## Installation

Standard install:

```sh
sh install.sh
source ~/.zshrc
```

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

It also updates a managed block in `~/.zshrc`:

- `# >>> vibe-cli-kit >>>`
- `# <<< vibe-cli-kit <<<`

## Verify

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
glow README.en.md
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

- `hk`
- `hotkeys`

Both open the localized cheatsheet. Language is selected from:

- `LC_ALL`
- `LC_MESSAGES`
- `LANG`

You can also override it manually:

```sh
terminal-cheatsheet --lang en
terminal-cheatsheet --lang zh-CN
terminal-cheatsheet --lang ja
```

## Notes

- `hk` prefers `bat`; falls back to `less`
- `vim` is aliased to `nvim`
- `--only-config` skips package installation
- `--dry-run` prints actions without changing the system
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
