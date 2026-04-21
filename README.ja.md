# vibe-cli-kit

macOS、Linux、WSL 向けのワンコマンド端末セットアップキット。

`ghostty` `yazi` `tmux` `fzf` `fd` `bat` `ripgrep` `lazygit` `nvim` `atuin` `zoxide` `glow` `fastfetch` `btop` と、shell 補助コマンド、ローカルチートシートをまとめて導入します。

## ひと目でわかること

- ツールと設定をまとめて導入
- `ghostty` `tmux` `yazi` をすぐ使える状態にする
- `hk` `v` `e` `fif` `p` `tmx` `tmn` `tma` `tml` `y` を追加
- `brew` と `apt` に対応
- ローカルテンプレートを保持し、`v doctor` と `v sync` を提供
- 環境に合わせて適応し、利用できないツールは安全にスキップ
- 実行後に installed / skipped / unavailable を要約表示

## クイックスタート

```sh
sh install.sh
source ~/.zshrc

hk
v doctor
v sync --dry-run --only tmux
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
hk
v doctor
v sync --dry-run --only tmux
e
fif tmux
p
tmn
y
tmx dev
rg foo
rg --files | fzf
z foo
lazygit
nvim .
glow README.ja.md
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
- `v sync --dry-run --only tmux`：設定同期をプレビュー
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
- `v sync --dry-run --only tmux`
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
