# vibe-cli-kit

macOS、Linux、WSL 向けのクロスプラットフォーム端末環境セットアップ。

CLI ツール、端末設定、Yazi プレビュー設定、tmux 設定、ローカルのチートシートをまとめて導入します。

## 言語

- English: `README.en.md`
- 简体中文: `README.zh-CN.md`
- 日本語: `README.ja.md`

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

補足：

- `ghostty` は macOS のみ自動インストール
- Linux / WSL では `ghostty` をスキップ
- Debian / Ubuntu / WSL では `batcat -> bat`、`fdfind -> fd` を自動調整

## インストール

通常インストール：

```sh
sh install.sh
source ~/.zshrc
```

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

さらに `~/.zshrc` の管理ブロックを更新します：

- `# >>> vibe-cli-kit >>>`
- `# <<< vibe-cli-kit <<<`

## 確認

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

システム言語から自動選択し、手動指定も可能です：

```sh
VIBE_CLI_KIT_LANG=ja hk
terminal-cheatsheet --lang en
terminal-cheatsheet --lang zh-CN
terminal-cheatsheet --lang ja
```

## メモ

- `hk` は `bat` を優先し、なければ `less`
- `vim` は `nvim` にマップ
- `--only-config` はツールをインストールしない
- `--dry-run` は実際には変更しない

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
