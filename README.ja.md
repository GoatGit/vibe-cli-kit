# vibe-cli-kit

巨人の肩ではなく、巨人のシャベルの上に立つ。

vibe-cli-kit は macOS、Linux、WSL 向けのクロスプラットフォーム端末ワークベンチで、端末中心のコーディング環境を導入したその日から使える状態に整えることを目指しています。

考え方はシンプルです。実績のある端末ツールを作り直すのではなく、その上に薄く実用的なデフォルトを重ね、速く、使いやすく、長く運用しやすい環境を作ります。

vibe-cli-kit は重い個人用設定フレームワークを目指すのではなく、軽くて使いやすい、すぐに使い始められる端末の基準セットを提供します。`ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop` と、shell 補助コマンド、ローカルチートシートをまとめて導入します。

## ひと目でわかること

- ツールと設定をまとめて導入
- 重い dotfiles フレームワークにしない
- 単なるツール集ではなく、コーディング導線を中心に設計
- `ghostty` `tmux` `yazi` をすぐ使える状態にする
- `hk` `v` `e` `fif` `p` `tmx` `tmn` `tma` `tml` `y` を追加
- `brew` と `apt` に対応
- ローカルテンプレートを保持し、`v doctor` `v backup` `v diff` `v sync` `v update` `v project` `v session` を提供
- 環境に合わせて適応し、利用できないツールは安全にスキップ
- 実行後に installed / skipped / unavailable を要約表示

## クイックスタート

```sh
sh install.sh
source ~/.zshrc

hk
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

## 言語

- English: [README.en.md](README.en.md)
- 简体中文: [README.zh-CN.md](README.zh-CN.md)
- 日本語: [README.ja.md](README.ja.md)

## 対応環境

- macOS
- Linux
- WSL

対応パッケージマネージャー：

- Homebrew
- apt

補足：

- macOS は Homebrew 前提
- Ubuntu / Debian / WSL は apt を優先
- Linux / WSL で `apt` と `brew` の両方がある場合は `apt` を優先
- それ以外の Linux は `apt` か `brew` が必要

## インストールされるツール

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

補足：

- `ghostty` は macOS のみ自動インストール
- Linux / WSL では `ghostty` をスキップ
- Debian / Ubuntu / WSL では `batcat -> bat`、`fdfind -> fd` を自動調整

## インストール

ドライラン：

```sh
sh install.sh --dry-run
```

設定だけ更新：

```sh
sh install.sh --only-config
source ~/.zshrc
```

ヘルプ：

```sh
sh install.sh --help
```

## 書き込まれるファイル

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

さらに `~/.zshrc` の管理ブロックを更新します：

- `# >>> vibe-cli-kit >>>`
- `# <<< vibe-cli-kit <<<`

## 確認

```sh
source ~/.zshrc
hk                           # ローカルチートシートを開く
v doctor                     # ツールと設定の状態を確認
v backup --only tmux         # tmux 設定だけバックアップ
v diff --only tmux           # tmux テンプレートとの差分を確認
v update --dry-run --no-sync # 設定同期なしで更新をプレビュー
v project                    # プロジェクト種別と推奨コマンドを表示
v sync --dry-run --only tmux # tmux 設定同期をプレビュー
v session code               # code workspace を開く
e                            # ファイルをあいまい選択して nvim で開く
fif tmux                     # 内容検索してヒット位置へ移動
p                            # プロジェクトディレクトリへ移動
tmn                          # 現在のディレクトリ名で tmux セッションを作成/再利用
y                            # Yazi を開く
tmx dev                      # dev セッションへ入る
rg foo                       # 全文検索
rg --files | fzf             # ファイルをあいまい選択
z foo                        # よく使うディレクトリへ移動
lazygit                      # Git TUI を開く
nvim .                       # 現在のディレクトリを開く
glow README.ja.md            # glow で README を読む
```

## デフォルトの使い方

### Terminal

- macOS では Ghostty を推奨
- `Ctrl+grave` で Quick Terminal

### tmux

- prefix: `Ctrl+a`
- `tmx`: セッションへスマートに入る
- `tmn`: 現在のディレクトリ名でセッションを作成/再利用
- `tma`: 指定セッションへ attach / create
- `tml`: セッション一覧

### ワークフローコマンド

- `v doctor`：ツール、設定、スクリプト、shell 統合を確認
- `v backup --only tmux`：現在の設定をバックアップ
- `v diff --only tmux`：現在の設定とテンプレート差分を確認
- `v update --dry-run --no-sync`：設定同期なしで更新をプレビュー
- `v project`：現在のプロジェクト種別と推奨コマンドを表示
- `v sync --dry-run --only tmux`：設定同期をプレビュー
- `v session code`：コーディング用 workspace を作成または再利用
- `v session backend`：バックエンド workspace を作成または再利用
- `v session frontend`：フロントエンド workspace を作成または再利用
- `v session ai`：AI workspace を作成または再利用
- `v sync --only yazi`：Yazi 設定だけ同期
- `v sync --mode backup`：上書き前にバックアップ
- `e`：ファイルをあいまい選択して `nvim` で開く
- `e README.md`：指定ファイルを直接 `nvim` で開く
- `fif tmux`：内容検索してヒット行へ移動
- `fif`：対話型の全文検索
- `p`：プロジェクトディレクトリへ移動
- `p vibe-cli-kit`：`zoxide` またはプロジェクト候補から移動

### Yazi

- `y` で起動
- 終了時に shell の cwd を更新
- テキストは `nvim` で開く
- Markdown プレビューは `bat --language=markdown`
- その他テキストも `bat`

### Markdown 閲覧

- Yazi 内: `bat`
- 端末内で単独閲覧: `glow file.md`

### チートシート

- `hk`
- `hotkeys`
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

システム言語から自動選択し、手動指定も可能です：

```sh
VIBE_CLI_KIT_LANG=ja hk
terminal-cheatsheet --lang en
terminal-cheatsheet --lang zh-CN
terminal-cheatsheet --lang ja
```

## コマンド説明

### `v doctor`

確認内容：

- テンプレートストアの存在
- `ghostty` / `tmux` / `yazi` 設定の配置
- `terminal-cheatsheet`、`tmx`、`v`、`e`、`fif` のインストール
- `~/.zshrc` の管理ブロック
- 主要 CLI ツールの利用可否

出力：

- `ok`：正常
- `warn`：利用はできるが確認推奨
- `fail`：インストールまたは設定が不完全

### `v sync`

用途：

- ローカルテンプレートから設定を再同期
- ツールの再インストールはしない
- テンプレート更新後の再反映に向く

主なオプション：

- `--dry-run`
- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`
- `--mode overwrite|skip|backup`

例：

```sh
v sync --dry-run --only tmux
v sync --only shell
v sync --only bin --mode backup
v sync --mode skip
```

### `v diff`

用途：

- ローカルテンプレートと現在の設定差分を比較
- ファイルは変更しない
- `sync` 前の確認に向く

主なオプション：

- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`

例：

```sh
v diff
v diff --only tmux
v diff --only shell
```

### `v backup`

用途：

- 現在の設定をタイムスタンプ付きディレクトリへ退避
- 今のファイルは変更しない
- `sync` 前や手動編集前の退避に向く

主なオプション：

- `--only all|ghostty|yazi|tmux|cheatsheets|bin|shell`

例：

```sh
v backup
v backup --only tmux
v backup --only shell
```

### `v update`

用途：

- 現在のプラットフォーム向けに関連ツールを更新
- `brew` では formula / cask を個別更新
- `apt` では `--only-upgrade` を個別実行
- 既定では更新後に `v sync` も実行

主なオプション：

- `--dry-run`
- `--no-sync`

例：

```sh
v update --dry-run --no-sync
v update --dry-run
v update
```

### `v session`

用途：

- プリセットレイアウトから tmux workspace を作成
- 同名 session があれば再利用
- tmux 内では `switch-client`、外では `attach-session`

レイアウト：

- `code`：yazi + shell + git
- `backend`：server + tests + git
- `frontend`：yazi + dev + git
- `ai`：yazi + agent + shell

命名規則：

- `code` は現在ディレクトリ名を既定値にする
- 他のレイアウトは `現在ディレクトリ名-レイアウト名`
- `--name` で上書き可能。例：`v session ai --name semibot-ai`

例：

```sh
v session code
v session backend
v session frontend
v session ai
v session ai --name vibe-ai
```

補足：

- `code` レイアウトでは左大 pane で `yazi` を起動
- `frontend` と `ai` も左大 pane は `yazi`
- `yazi` からテキストを開くと、その pane 内で `nvim` が開く
- `nvim` を閉じると `yazi` に戻る
- `backend` / `frontend` は現在のプロジェクト種別から dev / test コマンドを補う

### `v project`

用途：

- 現在のプロジェクト種別を判定
- 推奨 runner を表示
- 推奨 dev / test コマンドを表示

現在の判定規則：

- `package.json` -> Node
- `pyproject.toml` -> Python
- `Cargo.toml` -> Rust
- `go.mod` -> Go

例：

```sh
v project
```

### `e`

用途：

- `rg --files` または `fd` でファイル一覧
- `fzf` で選択
- `nvim` で開く

例：

```sh
e
e README.ja.md
```

### `fif`

用途：

- `rg` で内容検索
- `fzf` で候補選択
- 対応行を `nvim` で開く

例：

```sh
fif tmux
fif install_yazi_plugins
fif
```

### `p`

用途：

- プロジェクトディレクトリへ素早く移動
- 指定ディレクトリがあれば直接 `cd`
- 次に `zoxide query`
- それ以外は共通プロジェクトルートから git リポジトリを検索

デフォルト探索先：

- `$HOME/AI`
- `$HOME/Code`
- `$HOME/Projects`
- `$HOME/workspace`
- `$HOME/src`

上書き：

```sh
export VIBE_PROJECT_DIRS="$HOME/AI:$HOME/work:$HOME/src"
```

## メモ

- `hk` は `bat` を優先し、なければ `less`
- `vim` は `nvim` にマップ
- `--only-config` はツールをインストールしない
- `--dry-run` は実際には変更しない
- `v sync` は `~/.config/vibe-cli-kit/templates/` をローカルテンプレートとして使う
- `v backup` は `~/.config/vibe-cli-kit/backups/<timestamp>/` に保存する
- `v diff --only shell` は `~/.zshrc` の管理ブロックだけを比較する
- `v update` は単一項目が失敗しても全体を止めずに続行する
- `v session` は現在のディレクトリを起点に tmux workspace を作る
- `p` は現在の shell ディレクトリを変えるため、独立コマンドではなく shell 関数

## メンテナンス

主なテンプレート：

- `templates/ghostty/config`
- `templates/tmux/tmux.conf`
- `templates/yazi/yazi.toml`
- `templates/yazi/package.toml`
- `templates/shell/zshrc.snippet`
- `templates/cheatsheets/`
- `templates/bin/terminal-cheatsheet`
- `templates/bin/tmx`
