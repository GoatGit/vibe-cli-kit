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
    assert_contains "$output" "session.conf" "install dry-run session config"
}

run_test "v opens cheatsheet" test_v_opens_cheatsheet
run_test "v passes --lang to cheatsheet" test_v_lang_passthrough
run_test "terminal-cheatsheet prefers dark Ghostty theme" test_terminal_theme_ghostty_dark
run_test "terminal-cheatsheet parses dark tmux status theme" test_terminal_theme_tmux_dark
run_test "v project detects nextjs and best test script" test_project_detection_nextjs
run_test "v project detects django" test_project_detection_django
run_test "v project detects docker compose" test_project_detection_docker_compose
run_test "v session ai reads session.conf overrides" test_session_config_ai_layout
run_test "v sync preserves user-owned session overrides" test_sync_session_preserves_user_overrides
run_test "v backup creates a unique directory per run" test_backup_uses_unique_directory_per_run
run_test "v project ignores non-script package.json keys" test_project_ignores_non_script_package_keys
run_test "install.sh dry-run exposes session example copy" test_install_dry_run_config

printf '\nSummary: pass=%s fail=%s\n' "$PASS_COUNT" "$FAIL_COUNT"
[ "$FAIL_COUNT" -eq 0 ]
