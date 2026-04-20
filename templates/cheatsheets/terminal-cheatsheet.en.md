# Terminal Cheatsheet

Included tools: Ghostty, Yazi, lsd, bat, tmux, fzf, fd, atuin, zoxide, Neovim, ripgrep, lazygit, rich-cli, glow.

Compact reference based on the default project configuration, optimized for high-frequency tasks.

## Quick Start

```sh
hk          # Open this cheatsheet
tmn         # Open or create a tmux session using the current directory name
tmx dev     # Enter the dev session
y           # Open Yazi
rg foo      # Search text globally
rg --files | fzf
z foo       # Jump to a frequent directory
lazygit     # Open Git TUI
nvim .      # Open current directory
```

## Shell Entry Points

- `hk` / `hotkeys`: open the cheatsheet
- `tmx`: enter `main`; attach if it exists, create if it does not
- `tmx dev`: enter the `dev` session
- `tmn`: create or enter a session named after the current directory
- `tma`: attach `main`; create if missing
- `tml`: list all sessions
- `y`: open Yazi
- `ll`: same as `lsd -lah`
- `vim`: same as `nvim`

## tmux

Prefix: `Ctrl+a`

- `Ctrl+a d`: detach
- `Ctrl+a c`: new window
- `Ctrl+a %`: vertical split
- `Ctrl+a "`: horizontal split
- `Ctrl+a h/j/k/l`: move between panes
- `Ctrl+a H/J/K/L`: resize panes
- `Ctrl+a Enter`: copy mode
- `Ctrl+a r`: reload config
- `Ctrl+a x` / `X`: close pane / window

Copy mode:

- `v`: start selection
- `y`: copy and exit

## Ghostty

- `Cmd+t`: new tab
- `Cmd+w`: close current tab / split
- `Cmd+d`: split right
- `Cmd+Shift+d`: split down
- `Cmd+Alt+←/→/↑/↓`: move between splits
- `Cmd+Shift+e`: equalize splits
- `Cmd+Shift+f`: zoom / unzoom split
- `Cmd+Shift+←/→`: switch tabs
- `Cmd+Shift+,`: reload config
- `Ctrl+grave`: toggle Quick Terminal

## Yazi

- `j/k`: move up / down
- `h/l`: parent directory / enter directory
- `g` / `G`: top / bottom
- `/`: search
- `Space`: select
- `c/x/p`: copy / cut / paste
- `r`: rename
- `d`: delete
- `o` / `Enter`: open
- `q`: quit

## Search and Browse

Hotkeys:

- `Ctrl+r`: fuzzy history search
- `Ctrl+t`: fuzzy file insert
- `Alt+c`: fuzzy directory jump

High-frequency `rg / ripgrep`:

- `rg foo`: search text globally
- `rg -i foo`: ignore case
- `rg -n foo`: show line numbers
- `rg -C 2 foo`: show context
- `rg foo templates`: search only in a directory
- `rg foo -g "*.sh"`: search only matching file types
- `rg --files`: list files
- `rg --files | fzf`: fuzzy-pick a file

Common commands:

- `rg foo`: global text search
- `bat file`: syntax-highlighted file view
- `lsd -lah`: friendlier `ls`

Combined usage:

```sh
rg --files | fzf
fd . | fzf
```

## History and Jumping

- `Ctrl+r`: atuin history search
- `z foo`: jump to frequent directory
- `zi`: interactive directory jump

## Editing and Git

- `nvim`: open Neovim
- `nvim .`: open current directory
- `nvim file`: edit file
- `lazygit`: open Git TUI
- `glow file.md`: read a Markdown file in the terminal

## Markdown Reading

- `hk`: open the command cheatsheet
- `glow file.md`: read Markdown in the terminal
- `y`: browse files in Yazi; `.md` preview uses `bat`
