#!/bin/sh

set -eu

PROJECT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TEMPLATE_DIR="$PROJECT_DIR/templates"
DRY_RUN=0
ONLY_CONFIG=0

PLATFORM=
PACKAGE_MANAGER=
APT_UPDATED=0
I18N_LANG_RAW="${VIBE_CLI_KIT_LANG:-${LANG:-${LC_MESSAGES:-${LC_ALL:-en}}}}"
INSTALLED_TOOLS=
SKIPPED_TOOLS=
UNAVAILABLE_TOOLS=

BREW_BIN="${BREW_BIN:-}"
if [ -z "${BREW_BIN}" ]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    BREW_BIN=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    BREW_BIN=/usr/local/bin/brew
  else
    BREW_BIN=
  fi
fi

TOOLS="ghostty yazi lsd bat tmux fzf fd atuin zoxide nvim ripgrep lazygit rich-cli glow fastfetch btop"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LOCAL_BIN_DIR="$HOME/.local/bin"
CHEATSHEET_DIR="$CONFIG_DIR/cheatsheets"
SHELL_RC="$HOME/.zshrc"

log() {
  printf '%s\n' "$*"
}

warn() {
  printf '%s: %s\n' "$(msg warning)" "$*" >&2
}

die() {
  printf '%s: %s\n' "$(msg error)" "$*" >&2
  exit 1
}

msg() {
  key="$1"
  case "$I18N_LANG_RAW" in
    zh*|ZH*)
      case "$key" in
        warning) printf '警告' ;;
        error) printf '错误' ;;
        usage_title) printf '用法:' ;;
        usage_options) printf '参数:' ;;
        usage_dry_run) printf '只打印计划动作，不真正改动系统' ;;
        usage_only_config) printf '只安装配置、帮助文档、脚本和 shell 集成' ;;
        dry_run_complete) printf '预演完成。' ;;
        install_complete) printf '安装完成。' ;;
        open_shell) printf '重新打开 shell，或执行：' ;;
        useful_commands) printf '常用命令：' ;;
        skip_tool_installation) printf '跳过工具安装：--only-config' ;;
        install_yazi_plugins) printf '安装 Yazi 插件' ;;
        skip_yazi_plugins_config) printf '跳过 Yazi 插件安装：--only-config' ;;
        skip_yazi_plugins_missing) printf '跳过 Yazi 插件安装：未找到 ya' ;;
        yazi_plugins_failed) printf 'Yazi 插件安装未完成' ;;
        yazi_plugins_manual) printf '检测到本地插件已修改。若要重新部署，请手动删除后重试：' ;;
        need_root) printf '此操作需要 root 权限' ;;
        unsupported_platform) printf '不支持的平台' ;;
        unsupported_package_manager) printf '不支持的包管理器，当前仅支持 Homebrew 和 apt' ;;
        platform) printf '平台' ;;
        package_manager) printf '包管理器' ;;
        installed_tools) printf '已安装工具' ;;
        skipped_tools) printf '已跳过工具' ;;
        unavailable_tools) printf '不可用工具' ;;
        *) printf '%s' "$key" ;;
      esac
      ;;
    ja*|JA*)
      case "$key" in
        warning) printf '警告' ;;
        error) printf 'エラー' ;;
        usage_title) printf '使い方:' ;;
        usage_options) printf 'オプション:' ;;
        usage_dry_run) printf '実行内容のみ表示し、システムは変更しない' ;;
        usage_only_config) printf '設定、チートシート、スクリプト、shell 統合のみを導入する' ;;
        dry_run_complete) printf 'ドライラン完了。' ;;
        install_complete) printf 'インストール完了。' ;;
        open_shell) printf '新しい shell を開くか、次を実行してください:' ;;
        useful_commands) printf 'よく使うコマンド:' ;;
        skip_tool_installation) printf 'ツールのインストールをスキップ：--only-config' ;;
        install_yazi_plugins) printf 'Yazi プラグインをインストール' ;;
        skip_yazi_plugins_config) printf 'Yazi プラグインのインストールをスキップ：--only-config' ;;
        skip_yazi_plugins_missing) printf 'Yazi プラグインのインストールをスキップ：ya が見つからない' ;;
        yazi_plugins_failed) printf 'Yazi プラグインのインストールは完了しませんでした' ;;
        yazi_plugins_manual) printf 'ローカルで変更されたプラグインが見つかりました。再配置するには手動で削除して再実行してください:' ;;
        need_root) printf 'この操作には root 権限が必要です' ;;
        unsupported_platform) printf '未対応のプラットフォーム' ;;
        unsupported_package_manager) printf '未対応のパッケージマネージャーです。Homebrew と apt のみ対応しています' ;;
        platform) printf 'プラットフォーム' ;;
        package_manager) printf 'パッケージマネージャー' ;;
        installed_tools) printf 'インストール済みツール' ;;
        skipped_tools) printf 'スキップしたツール' ;;
        unavailable_tools) printf '利用できないツール' ;;
        *) printf '%s' "$key" ;;
      esac
      ;;
    *)
      case "$key" in
        warning) printf 'warning' ;;
        error) printf 'error' ;;
        usage_title) printf 'Usage:' ;;
        usage_options) printf 'Options:' ;;
        usage_dry_run) printf 'Print planned actions without changing the system' ;;
        usage_only_config) printf 'Install configs, cheatsheet, scripts, and shell integration only' ;;
        dry_run_complete) printf 'Dry run complete.' ;;
        install_complete) printf 'Installation complete.' ;;
        open_shell) printf 'Open a new shell or run:' ;;
        useful_commands) printf 'Useful commands:' ;;
        skip_tool_installation) printf 'skip tool installation: --only-config' ;;
        install_yazi_plugins) printf 'install yazi plugins' ;;
        skip_yazi_plugins_config) printf 'skip yazi plugin installation: --only-config' ;;
        skip_yazi_plugins_missing) printf "skip yazi plugin installation: 'ya' not found" ;;
        yazi_plugins_failed) printf 'yazi plugin installation did not complete' ;;
        yazi_plugins_manual) printf 'detected a locally modified plugin. Delete it manually and re-run if you want to redeploy:' ;;
        need_root) printf 'need root privileges' ;;
        unsupported_platform) printf 'unsupported platform' ;;
        unsupported_package_manager) printf 'unsupported package manager. Supported: Homebrew, apt' ;;
        platform) printf 'Platform' ;;
        package_manager) printf 'Package manager' ;;
        installed_tools) printf 'Installed tools' ;;
        skipped_tools) printf 'Skipped tools' ;;
        unavailable_tools) printf 'Unavailable tools' ;;
        *) printf '%s' "$key" ;;
      esac
      ;;
  esac
}

usage() {
  cat <<EOF
$(msg usage_title)
  sh install.sh [--dry-run] [--only-config]

$(msg usage_options)
  --dry-run      $(msg usage_dry_run)
  --only-config  $(msg usage_only_config)
EOF
}

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi
  "$@"
}

run_root_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi

  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "$(msg need_root): $*"
  fi
}

detect_platform() {
  uname_s=$(uname -s)
  case "$uname_s" in
    Darwin)
      PLATFORM=macos
      ;;
    Linux)
      if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
        PLATFORM=wsl
      else
        PLATFORM=linux
      fi
      ;;
    *)
      die "$(msg unsupported_platform): $uname_s"
      ;;
  esac
}

detect_package_manager() {
  case "$PLATFORM" in
    macos)
      if [ -n "$BREW_BIN" ]; then
        PACKAGE_MANAGER=brew
      elif command -v apt-get >/dev/null 2>&1; then
        PACKAGE_MANAGER=apt
      else
        die "$(msg unsupported_package_manager)"
      fi
      ;;
    linux|wsl)
      if command -v apt-get >/dev/null 2>&1; then
        PACKAGE_MANAGER=apt
      elif [ -n "$BREW_BIN" ]; then
        PACKAGE_MANAGER=brew
      else
        die "$(msg unsupported_package_manager)"
      fi
      ;;
    *)
      die "$(msg unsupported_package_manager)"
      ;;
  esac
}

ensure_dir() {
  run_cmd mkdir -p "$1"
}

append_status() {
  list_name="$1"
  item="$2"
  eval "current_value=\${$list_name:-}"
  if [ -z "$current_value" ]; then
    eval "$list_name=\"\$item\""
  else
    eval "$list_name=\"\$current_value
\$item\""
  fi
}

apt_update_once() {
  if [ "$APT_UPDATED" -eq 1 ]; then
    return 0
  fi
  log "update apt package index"
  run_root_cmd apt-get update
  APT_UPDATED=1
}

apt_package_exists() {
  pkg="$1"
  apt-cache show "$pkg" >/dev/null 2>&1
}

brew_formula_exists() {
  formula="$1"
  "$BREW_BIN" info --formula "$formula" >/dev/null 2>&1
}

brew_cask_exists() {
  cask="$1"
  "$BREW_BIN" info --cask "$cask" >/dev/null 2>&1
}

brew_install_formula() {
  formula="$1"
  if "$BREW_BIN" list --formula "$formula" >/dev/null 2>&1; then
    log "skip brew formula: $formula"
    append_status SKIPPED_TOOLS "$formula"
  elif ! brew_formula_exists "$formula"; then
    warn "skip brew formula: $formula (not available in current taps)"
    append_status UNAVAILABLE_TOOLS "$formula"
  else
    log "install brew formula: $formula"
    if run_cmd "$BREW_BIN" install "$formula"; then
      append_status INSTALLED_TOOLS "$formula"
    else
      warn "skip brew formula: $formula (install failed)"
      append_status UNAVAILABLE_TOOLS "$formula"
    fi
  fi
}

brew_install_cask() {
  cask="$1"
  app_path=

  case "$cask" in
    ghostty)
      app_path="/Applications/Ghostty.app"
      ;;
  esac

  if "$BREW_BIN" list --cask "$cask" >/dev/null 2>&1; then
    log "skip brew cask: $cask"
    append_status SKIPPED_TOOLS "$cask"
  elif [ -n "$app_path" ] && [ -e "$app_path" ]; then
    warn "skip brew cask: $cask (app already exists at $app_path)"
    append_status SKIPPED_TOOLS "$cask"
  elif ! brew_cask_exists "$cask"; then
    warn "skip brew cask: $cask (not available in current taps)"
    append_status UNAVAILABLE_TOOLS "$cask"
  else
    log "install brew cask: $cask"
    if run_cmd "$BREW_BIN" install --cask "$cask"; then
      append_status INSTALLED_TOOLS "$cask"
    else
      warn "skip brew cask: $cask (install failed)"
      append_status UNAVAILABLE_TOOLS "$cask"
    fi
  fi
}

apt_install_package() {
  pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    log "skip apt package: $pkg"
    append_status SKIPPED_TOOLS "$pkg"
    return 0
  fi
  apt_update_once
  if ! apt_package_exists "$pkg"; then
    warn "skip apt package: $pkg (not available in current repo)"
    append_status UNAVAILABLE_TOOLS "$pkg"
    return 0
  fi
  log "install apt package: $pkg"
  run_root_cmd apt-get install -y "$pkg"
  append_status INSTALLED_TOOLS "$pkg"
}

install_python_cli() {
  package="$1"
  if command -v pipx >/dev/null 2>&1; then
    if pipx list 2>/dev/null | grep -q "$package"; then
      log "skip pipx package: $package"
      append_status SKIPPED_TOOLS "$package"
    else
      log "install pipx package: $package"
      run_cmd pipx install "$package"
      append_status INSTALLED_TOOLS "$package"
    fi
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    if python3 -m pip --version >/dev/null 2>&1; then
      log "install python package with pip --user: $package"
      run_cmd python3 -m pip install --user "$package"
      append_status INSTALLED_TOOLS "$package"
    else
      warn "skip python package: $package (python3 is available but pip is missing)"
      append_status UNAVAILABLE_TOOLS "$package"
    fi
    return 0
  fi

  warn "skip python package: $package (python3/pipx not found)"
  append_status UNAVAILABLE_TOOLS "$package"
}

install_tools_brew() {
  if [ "$PLATFORM" = "macos" ]; then
    brew_install_cask ghostty
  else
    warn "skip ghostty: automatic installation is only enabled on macOS"
    append_status SKIPPED_TOOLS "ghostty"
  fi

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
  brew_install_formula rich-cli
  brew_install_formula glow
  brew_install_formula fastfetch
  brew_install_formula btop
}

install_tools_apt() {
  warn "ghostty is skipped on apt-based systems; install it manually if your desktop distro supports it"
  append_status SKIPPED_TOOLS "ghostty"
  apt_install_package yazi
  apt_install_package lsd
  apt_install_package bat
  apt_install_package fd-find
  apt_install_package tmux
  apt_install_package fzf
  apt_install_package atuin
  apt_install_package zoxide
  apt_install_package neovim
  apt_install_package ripgrep
  apt_install_package lazygit
  apt_install_package glow
  apt_install_package fastfetch
  apt_install_package btop
  install_python_cli rich-cli
}

install_tools() {
  case "$PACKAGE_MANAGER" in
    brew)
      install_tools_brew
      ;;
    apt)
      install_tools_apt
      ;;
    *)
      die "unsupported package manager: $PACKAGE_MANAGER"
      ;;
  esac
}

install_configs() {
  ensure_dir "$CONFIG_DIR/ghostty"
  ensure_dir "$CONFIG_DIR/yazi"
  ensure_dir "$CHEATSHEET_DIR"
  ensure_dir "$LOCAL_BIN_DIR"

  run_cmd cp "$TEMPLATE_DIR/ghostty/config" "$CONFIG_DIR/ghostty/config"
  run_cmd cp "$TEMPLATE_DIR/yazi/yazi.toml" "$CONFIG_DIR/yazi/yazi.toml"
  run_cmd cp "$TEMPLATE_DIR/yazi/package.toml" "$CONFIG_DIR/yazi/package.toml"
  run_cmd cp "$TEMPLATE_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  run_cmd cp "$TEMPLATE_DIR/bin/terminal-cheatsheet" "$LOCAL_BIN_DIR/terminal-cheatsheet"
  run_cmd cp "$TEMPLATE_DIR/bin/tmx" "$LOCAL_BIN_DIR/tmx"
  run_cmd chmod +x "$LOCAL_BIN_DIR/terminal-cheatsheet" "$LOCAL_BIN_DIR/tmx"

  for cheatsheet in "$TEMPLATE_DIR"/cheatsheets/*.md; do
    run_cmd cp "$cheatsheet" "$CHEATSHEET_DIR/"
  done
}

install_compat_shims() {
  ensure_dir "$LOCAL_BIN_DIR"

  if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    log "install compat shim: bat -> batcat"
    run_cmd ln -sf "$(command -v batcat)" "$LOCAL_BIN_DIR/bat"
  fi

  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    log "install compat shim: fd -> fdfind"
    run_cmd ln -sf "$(command -v fdfind)" "$LOCAL_BIN_DIR/fd"
  fi
}

install_yazi_plugins() {
  plugin_dir="$CONFIG_DIR/yazi/plugins/piper.yazi"

  if [ "$ONLY_CONFIG" -eq 1 ]; then
    log "$(msg skip_yazi_plugins_config)"
    return 0
  fi

  if ! command -v ya >/dev/null 2>&1; then
    warn "$(msg skip_yazi_plugins_missing)"
    return 0
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] install yazi plugins from $CONFIG_DIR/yazi/package.toml"
    return 0
  fi

  log "$(msg install_yazi_plugins)"
  if (
    cd "$CONFIG_DIR/yazi"
    ya pkg install
  ); then
    return 0
  fi

  warn "$(msg yazi_plugins_failed)"
  warn "$(msg yazi_plugins_manual) $plugin_dir"
}

append_managed_block() {
  file="$1"
  start_marker="# >>> vibe-cli-kit >>>"
  end_marker="# <<< vibe-cli-kit <<<"
  tmp_file="$file.vibe-cli-kit.tmp"

  if [ ! -f "$file" ]; then
    : > "$file"
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] update managed block in $file"
    return 0
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

print_status_block() {
  title="$1"
  values="$2"
  if [ -z "$values" ]; then
    return 0
  fi

  printf '\n%s:\n' "$title"
  OLD_IFS=$IFS
  IFS='
'
  for item in $values; do
    [ -n "$item" ] && printf '  - %s\n' "$item"
  done
  IFS=$OLD_IFS
}

print_summary() {
  if [ "$DRY_RUN" -eq 1 ]; then
    cat <<EOF
$(msg dry_run_complete)
$(msg platform): $PLATFORM
$(msg package_manager): $PACKAGE_MANAGER
EOF
    return 0
  fi

  cat <<EOF
$(msg install_complete)

$(msg platform): $PLATFORM
$(msg package_manager): $PACKAGE_MANAGER

$(msg open_shell)
  source ~/.zshrc

$(msg useful_commands)
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

  print_status_block "$(msg installed_tools)" "$INSTALLED_TOOLS"
  print_status_block "$(msg skipped_tools)" "$SKIPPED_TOOLS"
  print_status_block "$(msg unavailable_tools)" "$UNAVAILABLE_TOOLS"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        ;;
      --only-config)
        ONLY_CONFIG=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "unknown option: $1"
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"
  detect_platform
  detect_package_manager
  install_configs
  install_shell_integration
  if [ "$ONLY_CONFIG" -eq 0 ]; then
    install_tools
    install_compat_shims
    install_yazi_plugins
  else
    install_compat_shims
    log "$(msg skip_tool_installation)"
  fi
  print_summary
}

main "$@"
