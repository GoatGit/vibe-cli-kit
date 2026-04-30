# Terminal Cheatsheet

Included tools: Ghostty, Yazi, lsd, bat, tmux, zellij, fzf, fd, atuin, zoxide, starship, Neovim, ripgrep, lazygit, rich-cli, glow, fastfetch, btop.

## High Frequency

- `v`: open this cheatsheet with no arguments
- `v doctor`: check tool/config health
- `v project`: detect project type and suggested commands
- `v r 3000`: free the port and restart the current project
- `v session code`: open the `code` workspace
- `e`: fuzzy-open a file in `nvim`
- `fif tmux`: search content and open the match
- `p`: jump to a project directory
- `tmn`: open or create a tmux session using the current directory name
- `zmx [name]`: open or create a zellij session, default `main`
- `zmn`: open or create a zellij session using the current directory name
- `y`: open Yazi
- `rg foo`: search text globally
- `z foo`: jump to a frequent directory
- `lazygit`: open Git TUI
- `nvim .`: open current directory

## Shell

- `v` / `hk` / `hotkeys`: open the cheatsheet
- `v doctor`: check installation and config health
- `v backup --only tmux`: back up current tmux config
- `v diff --only tmux`: compare deployed config against templates
- `v sync --dry-run --only tmux`: preview tmux config sync
- `v update --dry-run --no-sync`: preview package updates only
- `v project`: detect the current project type and suggested commands
- `v r 3000`: free the port and run the detected project start command
- `v session code|backend|frontend|ai`: create or reuse workspaces
- `p`: jump to a project directory
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

Copy mode: `v` starts selection, `y` copies and exits

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

- `y`: open Yazi
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

## Search

- `Ctrl+r`: fuzzy history search
- `Ctrl+t`: fuzzy file insert
- `Alt+c`: fuzzy directory jump
- `rg foo`: search text globally
- `rg -i foo`: ignore case
- `rg -n foo`: show line numbers
- `rg --files`: list files
- `rg --files | fzf`: fuzzy-pick a file
- `bat file`: syntax-highlighted file view
- `fd . | fzf`: fuzzy-pick a file or directory

## Edit / Git

- `nvim`: open Neovim
- `nvim .`: open current directory
- `nvim file`: edit file
- `e`: fuzzy-pick and open a file
- `fif foo`: search content and jump to the match
- `lazygit`: open Git TUI
- `glow file.md`: read a Markdown file in the terminal

## Jump

- `p`: fuzzy-pick from common project roots
- `p foo`: prefer `zoxide` or project-name match
- `z foo`: jump to frequent directory
- `zi`: interactive directory jump
- `tmx [name]`: enter a tmux session, default `main`
- `tmx dev`: enter the `dev` session
- `tmn`: create or enter a session named after the current directory
- `tma`: attach `main`
- `tml`: list all sessions
- `zmx [name]`: enter a zellij session, default `main`
- `zmx dev`: enter the `dev` session
- `zmn`: create or enter a session named after the current directory
- `zma`: attach or create `main`
- `zml`: list all zellij sessions
