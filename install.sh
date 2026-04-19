#!/bin/sh

set -eu

PROJECT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE_DIR="$PROJECT_DIR/templates"

BREW_BIN="${BREW_BIN:-}"
if [ -z "$BREW_BIN" ]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    BREW_BIN=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    BREW_BIN=/usr/local/bin/brew
  else
    BREW_BIN=
  fi
fi

TOOLS="ghostty yazi lsd bat tmux fzf fd atuin zoxide nvim ripgrep lazygit"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN_DIR="$HOME/.local/bin"
CHEATSHEET_DIR="$CONFIG_DIR/cheatsheets"
SHELL_RC="$HOME/.zshrc"

log() {
  printf '%s\n' "$*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_brew() {
  [ -n "$BREW_BIN" ] || die "Homebrew not found. Install Homebrew first: https://brew.sh"
}

ensure_dir() {
  mkdir -p "$1"
}

brew_install_formula() {
  formula="$1"
  if "$BREW_BIN" list --formula "$formula" >/dev/null 2>&1; then
    log "skip brew formula: $formula"
  else
    log "install brew formula: $formula"
    "$BREW_BIN" install "$formula"
  fi
}

brew_install_cask() {
  cask="$1"
  if "$BREW_BIN" list --cask "$cask" >/dev/null 2>&1; then
    log "skip brew cask: $cask"
  else
    log "install brew cask: $cask"
    "$BREW_BIN" install --cask "$cask"
  fi
}

install_tools() {
  require_brew

  brew_install_cask ghostty
  brew_install_formula yazi
  brew_install_formula lsd
  brew_install_formula bat
  brew_install_formula tmux
  brew_install_formula fzf
  brew_install_formula fd
  brew_install_formula atuin
  brew_install_formula zoxide
  brew_install_formula neovim
  brew_install_formula ripgrep
  brew_install_formula lazygit

  if ! [ -d "$HOME/.fzf" ]; then
    "$BREW_BIN" --prefix fzf >/dev/null 2>&1 || true
  fi
}

install_configs() {
  ensure_dir "$CONFIG_DIR/ghostty"
  ensure_dir "$CONFIG_DIR/yazi"
  ensure_dir "$CHEATSHEET_DIR"
  ensure_dir "$LOCAL_BIN_DIR"

  cp "$TEMPLATE_DIR/ghostty/config" "$CONFIG_DIR/ghostty/config"
  cp "$TEMPLATE_DIR/yazi/yazi.toml" "$CONFIG_DIR/yazi/yazi.toml"
  cp "$TEMPLATE_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  cp "$TEMPLATE_DIR/cheatsheets/terminal-cheatsheet.md" "$CHEATSHEET_DIR/terminal-cheatsheet.md"
  cp "$TEMPLATE_DIR/bin/terminal-cheatsheet" "$LOCAL_BIN_DIR/terminal-cheatsheet"
  cp "$TEMPLATE_DIR/bin/tmx" "$LOCAL_BIN_DIR/tmx"
  chmod +x "$LOCAL_BIN_DIR/terminal-cheatsheet" "$LOCAL_BIN_DIR/tmx"
}

append_managed_block() {
  file="$1"
  start_marker="# >>> vibe-cli-kit >>>"
  end_marker="# <<< vibe-cli-kit <<<"
  tmp_file="$file.vibe-cli-kit.tmp"

  if [ ! -f "$file" ]; then
    : > "$file"
  fi

  awk -v start="$start_marker" -v end="$end_marker" '
    $0 == start { skip=1; next }
    $0 == end { skip=0; next }
    skip != 1 { print }
  ' "$file" > "$tmp_file"

  {
    cat "$tmp_file"
    printf '\n%s\n' "$start_marker"
    cat "$TEMPLATE_DIR/shell/zshrc.snippet"
    printf '%s\n' "$end_marker"
  } > "$file"

  rm -f "$tmp_file"
}

install_shell_integration() {
  append_managed_block "$SHELL_RC"
}

print_summary() {
  cat <<'EOF'
Installation complete.

Open a new shell or run:
  source ~/.zshrc

Useful commands:
  hk
  hotkeys
  tmx
  tmn
  tma
  tml
  y
  nvim
  rg foo
  lazygit
EOF
}

main() {
  install_tools
  install_configs
  install_shell_integration
  print_summary
}

main "$@"
