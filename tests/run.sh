#!/bin/sh

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/vibe-cli-kit-tests.XXXXXX")
PASS_COUNT=0
FAIL_COUNT=0

cleanup() {
  rm -rf "$TEST_ROOT"
}

trap cleanup EXIT INT TERM

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  printf 'ok  %s\n' "$1"
}

fail() {
  FAIL_COUNT=$((FAIL_COUNT + 1))
  printf 'not ok  %s\n' "$1" >&2
}

assert_contains() {
  haystack="$1"
  needle="$2"
  context="$3"
  case "$haystack" in
    *"$needle"*) ;;
    *)
      printf 'assertion failed: expected to find [%s] in [%s]\n' "$needle" "$context" >&2
      return 1
      ;;
  esac
}

assert_not_contains() {
  haystack="$1"
  needle="$2"
  context="$3"
  case "$haystack" in
    *"$needle"*)
      printf 'assertion failed: expected [%s] to be absent in [%s]\n' "$needle" "$context" >&2
      return 1
      ;;
    *)
      ;;
  esac
}

make_test_bin() {
  bin_dir="$1"
  mkdir -p "$bin_dir"
}

write_script() {
  path="$1"
  shift
  cat >"$path" <<EOF
$*
EOF
  chmod +x "$path"
}

run_test() {
  test_name="$1"
  shift
  if "$@"; then
    pass "$test_name"
  else
    fail "$test_name"
  fi
}

test_v_opens_cheatsheet() {
  workdir="$TEST_ROOT/v-opens"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config"

  write_script "$bin_dir/terminal-cheatsheet" '#!/bin/sh
printf "CHEATSHEET:%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v"
  )"

  assert_contains "$output" "CHEATSHEET:" "v no-arg output"
}

test_v_lang_passthrough() {
  workdir="$TEST_ROOT/v-lang"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config"

  write_script "$bin_dir/terminal-cheatsheet" '#!/bin/sh
printf "CHEATSHEET:%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" --lang ja
  )"

  assert_contains "$output" "CHEATSHEET:--lang ja" "v --lang passthrough"
}

test_cheatsheets_document_restart_shortcut() {
  zh_contents="$(cat "$REPO_ROOT/templates/cheatsheets/terminal-cheatsheet.zh-CN.md")"
  en_contents="$(cat "$REPO_ROOT/templates/cheatsheets/terminal-cheatsheet.en.md")"
  ja_contents="$(cat "$REPO_ROOT/templates/cheatsheets/terminal-cheatsheet.ja.md")"

  assert_contains "$zh_contents" '`v r 3000`' "zh cheatsheet restart shortcut" &&
    assert_contains "$en_contents" '`v r 3000`' "en cheatsheet restart shortcut" &&
    assert_contains "$ja_contents" '`v r 3000`' "ja cheatsheet restart shortcut"
}

test_zellij_shortcuts_and_starship_are_wired() {
  install_contents="$(cat "$REPO_ROOT/install.sh")"
  driver_contents="$(cat "$REPO_ROOT/templates/bin/v")"
  shell_contents="$(cat "$REPO_ROOT/templates/shell/zshrc.snippet")"
  zmx_contents="$(cat "$REPO_ROOT/templates/bin/zmx")"
  starship_template_contents="$(cat "$REPO_ROOT/templates/starship/starship.toml")"
  zh_contents="$(cat "$REPO_ROOT/templates/cheatsheets/terminal-cheatsheet.zh-CN.md")"
  en_contents="$(cat "$REPO_ROOT/templates/cheatsheets/terminal-cheatsheet.en.md")"
  ja_contents="$(cat "$REPO_ROOT/templates/cheatsheets/terminal-cheatsheet.ja.md")"

  assert_contains "$install_contents" "zellij" "install.sh lists zellij" &&
    assert_contains "$install_contents" "starship" "install.sh lists starship" &&
    assert_contains "$install_contents" 'cp "$TEMPLATE_DIR/bin/zmx" "$LOCAL_BIN_DIR/zmx"' "install.sh deploys zmx" &&
    assert_contains "$install_contents" 'cp "$TEMPLATE_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"' "install.sh deploys starship config" &&
  assert_contains "$driver_contents" 'check_cmd "zellij" "zellij"' "doctor checks zellij" &&
    assert_contains "$driver_contents" 'check_cmd "starship" "starship"' "doctor checks starship" &&
    assert_contains "$driver_contents" 'check_file "starship config" "$CONFIG_DIR/starship.toml"' "doctor checks starship config" &&
    assert_contains "$driver_contents" 'run_diff_pair "starship" "$TEMPLATE_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"' "diff covers starship config" &&
    assert_contains "$driver_contents" 'backup_copy_file starship "$CONFIG_DIR/starship.toml" "$root/starship/starship.toml"' "backup covers starship config" &&
    assert_contains "$driver_contents" "brew_update_formula zellij" "brew update covers zellij" &&
    assert_contains "$driver_contents" "brew_update_formula starship" "brew update covers starship" &&
    assert_contains "$driver_contents" "apt_update_package zellij" "apt update covers zellij" &&
    assert_contains "$driver_contents" "update_starship_fallback" "apt update covers starship fallback" &&
    assert_contains "$driver_contents" 'check_file "script: zmx" "$LOCAL_BIN_DIR/zmx"' "doctor checks zmx script" &&
    assert_contains "$shell_contents" 'eval "$(starship init zsh)"' "shell snippet initializes starship" &&
    assert_contains "$shell_contents" "zma()" "shell snippet adds zma" &&
    assert_contains "$shell_contents" "zmn()" "shell snippet adds zmn" &&
    assert_contains "$shell_contents" "alias zml='zellij list-sessions'" "shell snippet adds zml" &&
    assert_contains "$zmx_contents" 'exec zellij attach -c "$session"' "zmx attaches or creates session" &&
    assert_contains "$starship_template_contents" '$directory$git_branch$git_status$fill$cmd_duration' "starship template keeps first line layout" &&
    assert_contains "$starship_template_contents" '$nodejs$python$rust$golang$package' "starship template restores language runtime line" &&
    assert_contains "$starship_template_contents" '$character' "starship template keeps prompt marker" &&
    assert_contains "$starship_template_contents" 'palette = "catppuccin_mocha"' "starship template enables catppuccin palette" &&
    assert_contains "$starship_template_contents" 'fg:base bg:lavender' "starship template uses background color blocks" &&
    assert_contains "$starship_template_contents" 'truncation_length = 5' "starship template shows more path segments" &&
    assert_contains "$starship_template_contents" 'truncate_to_repo = false' "starship template does not collapse to repo root" &&
    assert_not_contains "$starship_template_contents" '[]' "starship template does not use powerline separators" &&
    assert_contains "$starship_template_contents" '[gcloud]' "starship template configures gcloud" &&
    assert_contains "$starship_template_contents" 'disabled = true' "starship template disables gcloud account display" &&
    assert_contains "$starship_template_contents" '[nodejs]' "starship template restores nodejs module" &&
    assert_contains "$starship_template_contents" '[python]' "starship template restores python module" &&
    assert_contains "$starship_template_contents" '[rust]' "starship template restores rust module" &&
    assert_contains "$starship_template_contents" '[golang]' "starship template restores golang module" &&
    assert_contains "$starship_template_contents" '[package]' "starship template restores package module" &&
    assert_contains "$zh_contents" "zellij" "zh cheatsheet lists zellij" &&
    assert_contains "$zh_contents" "starship" "zh cheatsheet lists starship" &&
    assert_contains "$zh_contents" "zmx [name]" "zh cheatsheet lists zmx" &&
    assert_contains "$en_contents" "zellij" "en cheatsheet lists zellij" &&
    assert_contains "$en_contents" "starship" "en cheatsheet lists starship" &&
    assert_contains "$en_contents" "zmx [name]" "en cheatsheet lists zmx" &&
    assert_contains "$ja_contents" "zellij" "ja cheatsheet lists zellij" &&
    assert_contains "$ja_contents" "starship" "ja cheatsheet lists starship" &&
    assert_contains "$ja_contents" "zmx [name]" "ja cheatsheet lists zmx"
}

test_install_prefers_configured_brew_on_macos() {
  workdir="$TEST_ROOT/install-brew-fallback"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config"

  write_script "$bin_dir/uname" '#!/bin/sh
printf "Darwin\n"'
  brew_log="$workdir/brew.log"
  write_script "$bin_dir/brew" '#!/bin/sh
printf "%s\n" "$*" >> "$BREW_TEST_LOG"
case "$1" in
  --prefix)
    printf "/fake/homebrew\n"
    ;;
  info|list)
    exit 1
    ;;
  install)
    exit 0
    ;;
esac'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    BREW_BIN="$bin_dir/brew" \
    BREW_TEST_LOG="$brew_log" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/install.sh" --dry-run
  )"
  brew_log_contents="$(cat "$brew_log")"

  assert_contains "$output" "Package manager: brew" "macOS uses configured brew" &&
    assert_not_contains "$output" "Package manager: apt" "macOS does not fall back to apt when brew is configured" &&
    assert_contains "$brew_log_contents" "info --formula starship" "install.sh uses fake brew for starship checks"
}

test_v_update_prefers_brew_path_fallback_on_macos() {
  workdir="$TEST_ROOT/v-update-brew-fallback"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  config_dir="$home_dir/.config"
  make_test_bin "$bin_dir"
  mkdir -p "$config_dir/vibe-cli-kit/templates"

  write_script "$bin_dir/uname" '#!/bin/sh
printf "Darwin\n"'
  write_script "$bin_dir/brew" '#!/bin/sh
case "$1" in
  list)
    exit 1
    ;;
  *)
    exit 0
    ;;
esac'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" update --dry-run --no-sync
  )"

  assert_contains "$output" "package-manager=brew" "v update prefers brew from PATH fallback on macOS" &&
    assert_not_contains "$output" "package-manager=apt" "v update does not fall back to apt when brew is on PATH"
}

test_terminal_theme_ghostty_dark() {
  workdir="$TEST_ROOT/theme-ghostty"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  config_dir="$home_dir/.config"
  make_test_bin "$bin_dir"
  mkdir -p "$config_dir/ghostty" "$config_dir/cheatsheets"

  cat >"$config_dir/ghostty/config" <<'EOF'
theme = Catppuccin Mocha
EOF
  cat >"$config_dir/cheatsheets/terminal-cheatsheet.en.md" <<'EOF'
# demo
EOF

  write_script "$bin_dir/bat" '#!/bin/sh
printf "%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    TERM_PROGRAM=ghostty \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/terminal-cheatsheet" --lang en
  )"

  assert_contains "$output" "--theme=OneHalfDark" "ghostty theme selection"
}

test_terminal_theme_tmux_dark() {
  workdir="$TEST_ROOT/theme-tmux"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  config_dir="$home_dir/.config"
  make_test_bin "$bin_dir"
  mkdir -p "$config_dir/cheatsheets"

  cat >"$home_dir/.tmux.conf" <<'EOF'
set -g status-style bg=colour234,fg=colour137
EOF
  cat >"$config_dir/cheatsheets/terminal-cheatsheet.en.md" <<'EOF'
# demo
EOF

  write_script "$bin_dir/bat" '#!/bin/sh
printf "%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    TMUX=/tmp/fake-tmux \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/terminal-cheatsheet" --lang en
  )"

  assert_contains "$output" "--theme=OneHalfDark" "tmux theme selection"
}

test_project_detection_nextjs() {
  workdir="$TEST_ROOT/project-nextjs"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  project_dir="$workdir/project"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config" "$project_dir"

  write_script "$bin_dir/pnpm" '#!/bin/sh
exit 0'

  cat >"$project_dir/package.json" <<'EOF'
{
  "name": "demo-next",
  "dependencies": { "next": "^15.0.0" },
  "scripts": {
    "dev": "next dev",
    "test:e2e": "playwright test",
    "test:unit": "vitest run"
  }
}
EOF
  : >"$project_dir/pnpm-lock.yaml"
  : >"$project_dir/next.config.ts"

  output="$(
    cd "$project_dir"
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" project
  )"

  assert_contains "$output" "type: nextjs" "nextjs type" &&
    assert_contains "$output" "runner: pnpm" "nextjs runner" &&
    assert_contains "$output" "dev: pnpm dev" "nextjs dev" &&
    assert_contains "$output" "test: pnpm test:unit" "nextjs best test"
}

test_project_detection_django() {
  workdir="$TEST_ROOT/project-django"
  home_dir="$workdir/home"
  project_dir="$workdir/project"
  mkdir -p "$home_dir/.config" "$project_dir"

  : >"$project_dir/manage.py"
  cat >"$project_dir/pyproject.toml" <<'EOF'
[project]
name = "demo-django"
EOF

  output="$(
    cd "$project_dir"
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" project
  )"

  assert_contains "$output" "type: django" "django type" &&
    assert_contains "$output" "dev: python3 manage.py runserver" "django dev"
}

test_project_detection_docker_compose() {
  workdir="$TEST_ROOT/project-compose"
  home_dir="$workdir/home"
  project_dir="$workdir/project"
  mkdir -p "$home_dir/.config" "$project_dir"

  cat >"$project_dir/docker-compose.yml" <<'EOF'
services: {}
EOF

  output="$(
    cd "$project_dir"
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" project
  )"

  assert_contains "$output" "type: docker-compose" "compose type" &&
    assert_contains "$output" "runner: docker" "compose runner" &&
    assert_contains "$output" "dev: docker compose up" "compose dev"
}

test_session_config_ai_layout() {
  workdir="$TEST_ROOT/session-ai"
  home_dir="$workdir/home"
  config_dir="$home_dir/.config"
  bin_dir="$workdir/bin"
  log_file="$workdir/tmux.log"
  pane_file="$workdir/pane-seq"
  make_test_bin "$bin_dir"
  mkdir -p "$config_dir/vibe-cli-kit"

  cat >"$config_dir/vibe-cli-kit/session.conf" <<'EOF'
VIBE_SESSION_AI_RIGHT_WIDTH=35
VIBE_SESSION_AI_TOP_LEFT_CMD='echo top-left'
VIBE_SESSION_AI_TOP_RIGHT_CMD='echo top-right'
VIBE_SESSION_AI_BOTTOM_LEFT_CMD='echo bottom-left'
VIBE_SESSION_AI_BOTTOM_RIGHT_CMD='echo bottom-right'
EOF

  write_script "$bin_dir/tmux" '#!/bin/sh
log_file="${FAKE_TMUX_LOG:?}"
pane_file="${FAKE_TMUX_PANE_FILE:?}"
cmd="$1"
shift || true
case "$cmd" in
  has-session)
    exit 1
    ;;
  new-session)
    printf "new-session %s\n" "$*" >>"$log_file"
    ;;
  display-message)
    printf "%%0\n"
    ;;
  split-window)
    seq=$(cat "$pane_file" 2>/dev/null || printf "0")
    seq=$((seq + 1))
    printf "%s\n" "$seq" >"$pane_file"
    printf "split-window %s\n" "$*" >>"$log_file"
    printf "%%%s\n" "$seq"
    ;;
  select-pane)
    printf "select-pane %s\n" "$*" >>"$log_file"
    ;;
  send-keys)
    printf "send-keys %s\n" "$*" >>"$log_file"
    ;;
  attach-session|switch-client|kill-session)
    printf "%s %s\n" "$cmd" "$*" >>"$log_file"
    ;;
  *)
    printf "%s %s\n" "$cmd" "$*" >>"$log_file"
    ;;
esac'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    FAKE_TMUX_LOG="$log_file" \
    FAKE_TMUX_PANE_FILE="$pane_file" \
    sh "$REPO_ROOT/templates/bin/v" session ai --name demo --reset
  )"

  log_contents="$(cat "$log_file")"

  assert_contains "$output" "ok    create ai session demo" "ai session create" &&
    assert_contains "$log_contents" "split-window -h -p 35" "ai right width override" &&
    assert_contains "$log_contents" "send-keys -t %0 echo top-left C-m" "ai top-left command" &&
    assert_contains "$log_contents" "send-keys -t %1 echo top-right C-m" "ai top-right command" &&
    assert_contains "$log_contents" "send-keys -t %2 echo bottom-left C-m" "ai bottom-left command" &&
    assert_contains "$log_contents" "send-keys -t %3 echo bottom-right C-m" "ai bottom-right command"
}

test_sync_session_preserves_user_overrides() {
  workdir="$TEST_ROOT/sync-session"
  home_dir="$workdir/home"
  config_dir="$home_dir/.config"
  kit_dir="$config_dir/vibe-cli-kit"
  mkdir -p "$kit_dir/templates/session"

  cp "$REPO_ROOT/templates/session/session.conf.example" "$kit_dir/templates/session/session.conf.example"
  cat >"$kit_dir/session.conf" <<'EOF'
VIBE_SESSION_AI_RIGHT_WIDTH=99
EOF
  cat >"$kit_dir/session.conf.example" <<'EOF'
# stale example
EOF

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" sync --only session
  )"

  session_contents="$(cat "$kit_dir/session.conf")"
  example_contents="$(cat "$kit_dir/session.conf.example")"

  assert_contains "$output" "skip  $kit_dir/session.conf" "session.conf preserved during sync" &&
    assert_contains "$output" "sync  $kit_dir/session.conf.example" "session.conf.example refreshed during sync" &&
    assert_contains "$session_contents" "VIBE_SESSION_AI_RIGHT_WIDTH=99" "session override retained" &&
    assert_contains "$example_contents" "VIBE_SESSION_AI_RIGHT_WIDTH=40" "session example refreshed from template"
}

test_backup_uses_unique_directory_per_run() {
  workdir="$TEST_ROOT/backup-unique"
  home_dir="$workdir/home"
  config_dir="$home_dir/.config"
  kit_dir="$config_dir/vibe-cli-kit"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$kit_dir"

  cat >"$kit_dir/session.conf" <<'EOF'
first backup
EOF

  write_script "$bin_dir/date" '#!/bin/sh
printf "20260423-120000\n"'

  output_one="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" backup --only session
  )"

  cat >"$kit_dir/session.conf" <<'EOF'
second backup
EOF

  output_two="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" backup --only session
  )"

  first_dir="$kit_dir/backups/20260423-120000"
  second_dir="$kit_dir/backups/20260423-120000-1"
  first_backup="$(cat "$first_dir/session/session.conf")"
  second_backup="$(cat "$second_dir/session/session.conf")"

  assert_contains "$output_one" "dir=$first_dir" "first backup dir" &&
    assert_contains "$output_two" "dir=$second_dir" "second backup dir" &&
    assert_contains "$first_backup" "first backup" "first backup preserved" &&
    assert_contains "$second_backup" "second backup" "second backup isolated"
}

test_project_ignores_non_script_package_keys() {
  workdir="$TEST_ROOT/project-non-scripts"
  home_dir="$workdir/home"
  project_dir="$workdir/project"
  mkdir -p "$home_dir/.config" "$project_dir"

  cat >"$project_dir/package.json" <<'EOF'
{
  "name": "demo-node",
  "config": {
    "test": "not-a-script"
  }
}
EOF

  output="$(
    cd "$project_dir"
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" project
  )"

  assert_contains "$output" "type: node" "node type from package.json" &&
    assert_contains "$output" "test: (no default suggestion)" "no synthetic test command" &&
    assert_not_contains "$output" "npm run test" "ignore non-script package keys"
}

test_restart_kills_port_and_runs_explicit_command() {
  workdir="$TEST_ROOT/restart-explicit"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config"

  write_script "$bin_dir/lsof" '#!/bin/sh
printf "1111\n2222\n"'

  write_script "$bin_dir/printf-argv" '#!/bin/sh
printf "CMD:%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" r --port 3000 -- printf-argv hello world
  )"

  assert_contains "$output" "ok    stop port 3000: 1111 2222" "restart stops explicit port" &&
    assert_contains "$output" "ok    port 3000 released" "restart marks port as released" &&
    assert_contains "$output" "ok    start command: printf-argv hello world" "restart logs explicit command" &&
    assert_contains "$output" "CMD:hello world" "restart executes explicit command"
}

test_restart_accepts_positional_port_and_command() {
  workdir="$TEST_ROOT/restart-positional-command"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config"

  write_script "$bin_dir/lsof" '#!/bin/sh
printf "3333\n"'

  write_script "$bin_dir/printf-argv" '#!/bin/sh
printf "CMD:%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" r 3000 printf-argv positional-ok
  )"

  assert_contains "$output" "ok    stop port 3000: 3333" "restart accepts positional port" &&
    assert_contains "$output" "ok    start command: printf-argv positional-ok" "restart logs positional command" &&
    assert_contains "$output" "CMD:positional-ok" "restart executes positional command"
}

test_restart_uses_detected_project_dev_command() {
  workdir="$TEST_ROOT/restart-project"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  project_dir="$workdir/project"
  log_file="$workdir/restart-project.log"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config" "$project_dir"

  cat >"$project_dir/package.json" <<'EOF'
{
  "name": "demo-vite",
  "scripts": {
    "dev": "printf project-dev\n"
  }
}
EOF
  : >"$project_dir/pnpm-lock.yaml"
  : >"$project_dir/vite.config.ts"

  write_script "$bin_dir/lsof" '#!/bin/sh
exit 0'

  write_script "$bin_dir/pnpm" '#!/bin/sh
printf "PNPM:%s\n" "$*"'

  output="$(
    cd "$project_dir"
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" r 5173
  )"

  assert_contains "$output" "ok    port 5173 already free" "restart detects free port" &&
    assert_contains "$output" "ok    start command: pnpm dev" "restart chooses detected dev command" &&
    assert_contains "$output" "PNPM:dev" "restart executes detected dev command"
}

test_restart_reports_actionable_hints_when_detection_fails() {
  workdir="$TEST_ROOT/restart-hints"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  project_dir="$workdir/project"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config" "$project_dir"

  cat >"$project_dir/package.json" <<'EOF'
{
  "name": "demo-node",
  "scripts": {
    "lint": "eslint .",
    "build": "tsc -p ."
  }
}
EOF

  write_script "$bin_dir/lsof" '#!/bin/sh
exit 0'

  write_script "$bin_dir/npm" '#!/bin/sh
exit 0'

  output="$(
    cd "$project_dir"
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" r 3000 2>&1
  )" || true

  assert_contains "$output" "fail  no command provided and no default dev command detected" "restart failure summary" &&
    assert_contains "$output" "hint  detected project type: node" "restart reports project type" &&
    assert_contains "$output" "hint  preferred runner: npm" "restart reports preferred runner" &&
    assert_contains "$output" "hint  package.json scripts: lint, build" "restart reports discovered scripts" &&
    assert_contains "$output" "hint    v r --port 3000 -- <your-start-command>" "restart suggests explicit fallback" &&
    assert_contains "$output" "hint  inspect the current detection with: v project" "restart suggests project inspection"
}

test_restart_alias_still_works() {
  workdir="$TEST_ROOT/restart-alias"
  home_dir="$workdir/home"
  bin_dir="$workdir/bin"
  make_test_bin "$bin_dir"
  mkdir -p "$home_dir/.config"

  write_script "$bin_dir/lsof" '#!/bin/sh
exit 0'

  write_script "$bin_dir/printf-argv" '#!/bin/sh
printf "CMD:%s\n" "$*"'

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$home_dir/.config" \
    PATH="$bin_dir:/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/templates/bin/v" restart --port 3001 -- printf-argv alias-ok
  )"

  assert_contains "$output" "ok    port 3001 already free" "restart alias detects free port" &&
    assert_contains "$output" "CMD:alias-ok" "restart alias executes command"
}

test_install_dry_run_config() {
  workdir="$TEST_ROOT/install-dry-run"
  home_dir="$workdir/home"
  config_dir="$home_dir/.config"
  mkdir -p "$config_dir"

  output="$(
    HOME="$home_dir" \
    XDG_CONFIG_HOME="$config_dir" \
    PATH="/usr/bin:/bin:/usr/sbin:/sbin" \
    sh "$REPO_ROOT/install.sh" --dry-run --only-config
  )"

  assert_contains "$output" "session.conf.example" "install dry-run session example" &&
    assert_contains "$output" "session.conf" "install dry-run session config" &&
    assert_contains "$output" "starship.toml" "install dry-run starship config"
}

run_test "v opens cheatsheet" test_v_opens_cheatsheet
run_test "v passes --lang to cheatsheet" test_v_lang_passthrough
run_test "cheatsheets document the v r restart shortcut" test_cheatsheets_document_restart_shortcut
run_test "zellij shortcuts and starship are wired in installer, shell, doctor, updater, and cheatsheets" test_zellij_shortcuts_and_starship_are_wired
run_test "install.sh prefers configured brew on macOS" test_install_prefers_configured_brew_on_macos
run_test "v update prefers brew from PATH on macOS" test_v_update_prefers_brew_path_fallback_on_macos
run_test "terminal-cheatsheet prefers dark Ghostty theme" test_terminal_theme_ghostty_dark
run_test "terminal-cheatsheet parses dark tmux status theme" test_terminal_theme_tmux_dark
run_test "v project detects nextjs and best test script" test_project_detection_nextjs
run_test "v project detects django" test_project_detection_django
run_test "v project detects docker compose" test_project_detection_docker_compose
run_test "v session ai reads session.conf overrides" test_session_config_ai_layout
run_test "v sync preserves user-owned session overrides" test_sync_session_preserves_user_overrides
run_test "v backup creates a unique directory per run" test_backup_uses_unique_directory_per_run
run_test "v project ignores non-script package.json keys" test_project_ignores_non_script_package_keys
run_test "v restart kills the old process before running an explicit command" test_restart_kills_port_and_runs_explicit_command
run_test "v restart accepts a positional port and command" test_restart_accepts_positional_port_and_command
run_test "v restart falls back to the detected project dev command" test_restart_uses_detected_project_dev_command
run_test "v restart explains what to do when auto detection fails" test_restart_reports_actionable_hints_when_detection_fails
run_test "v restart alias remains supported" test_restart_alias_still_works
run_test "install.sh dry-run exposes session example copy" test_install_dry_run_config

printf '\nSummary: pass=%s fail=%s\n' "$PASS_COUNT" "$FAIL_COUNT"
[ "$FAIL_COUNT" -eq 0 ]
