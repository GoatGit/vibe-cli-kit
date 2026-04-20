# Terminal Cheatsheet

含まれるツール：Ghostty、Yazi、lsd、bat、tmux、fzf、fd、atuin、zoxide、Neovim、ripgrep、lazygit、rich-cli、glow。

このチートシートは、プロジェクトのデフォルト設定に基づいた高頻度操作向けの簡潔なリファレンスです。

## Quick Start

```sh
hk          # このチートシートを開く
tmn         # 現在のディレクトリ名で tmux セッションを作成/再利用
tmx dev     # dev セッションへ入る
y           # Yazi を開く
rg foo      # 全文検索
rg --files | fzf
z foo       # よく使うディレクトリへ移動
lazygit     # Git TUI を開く
nvim .      # 現在のディレクトリを開く
```

## Shell エントリ

- `hk` / `hotkeys`：チートシートを開く
- `tmx`：`main` に入る。存在すれば attach、なければ作成
- `tmx dev`：`dev` セッションへ入る
- `tmn`：現在のディレクトリ名でセッションを作成または再利用
- `tma`：`main` に attach。なければ作成
- `tml`：すべてのセッションを表示
- `y`：Yazi を開く
- `ll`：`lsd -lah`
- `vim`：`nvim`

## tmux

プレフィックス：`Ctrl+a`

- `Ctrl+a d`：detach
- `Ctrl+a c`：新しい window
- `Ctrl+a %`：左右分割
- `Ctrl+a "`：上下分割
- `Ctrl+a h/j/k/l`：pane 移動
- `Ctrl+a H/J/K/L`：pane サイズ変更
- `Ctrl+a Enter`：コピー・モード
- `Ctrl+a r`：設定再読み込み
- `Ctrl+a x` / `X`：pane / window を閉じる

コピー・モード：

- `v`：選択開始
- `y`：コピーして終了

## Ghostty

- `Cmd+t`：新しいタブ
- `Cmd+w`：現在のタブ / 分割を閉じる
- `Cmd+d`：右に分割
- `Cmd+Shift+d`：下に分割
- `Cmd+Alt+←/→/↑/↓`：分割間を移動
- `Cmd+Shift+e`：分割を均等化
- `Cmd+Shift+f`：分割を拡大 / 戻す
- `Cmd+Shift+←/→`：タブ切り替え
- `Cmd+Shift+,`：設定再読み込み
- `Ctrl+grave`：Quick Terminal を切り替え

## Yazi

- `j/k`：上下移動
- `h/l`：親ディレクトリ / ディレクトリへ入る
- `g` / `G`：先頭 / 末尾へ移動
- `/`：検索
- `Space`：選択
- `c/x/p`：コピー / カット / ペースト
- `r`：名前変更
- `d`：削除
- `o` / `Enter`：開く
- `q`：終了

## 検索と閲覧

ショートカット：

- `Ctrl+r`：履歴のあいまい検索
- `Ctrl+t`：ファイルパスをあいまい挿入
- `Alt+c`：ディレクトリをあいまい移動

高頻度の `rg / ripgrep`：

- `rg foo`：全文検索
- `rg -i foo`：大文字小文字を無視
- `rg -n foo`：行番号を表示
- `rg -C 2 foo`：前後の文脈を表示
- `rg foo templates`：特定ディレクトリだけ検索
- `rg foo -g "*.sh"`：特定の拡張子だけ検索
- `rg --files`：ファイル一覧
- `rg --files | fzf`：ファイルをあいまい選択

よく使うコマンド：

- `rg foo`：全文検索
- `bat file`：シンタックスハイライト付きで表示
- `lsd -lah`：見やすい `ls`

組み合わせ：

```sh
rg --files | fzf
fd . | fzf
```

## 履歴と移動

- `Ctrl+r`：atuin 履歴検索
- `z foo`：よく使うディレクトリへ移動
- `zi`：対話的ディレクトリ移動

## 編集と Git

- `nvim`：Neovim を開く
- `nvim .`：現在のディレクトリを開く
- `nvim file`：ファイル編集
- `lazygit`：Git TUI を開く
- `glow file.md`：ターミナルで Markdown を読む

## Markdown の閲覧

- `hk`：コマンドチートシートを開く
- `glow file.md`：ターミナルで Markdown を読む
- `y`：Yazi でファイルを閲覧。`.md` プレビューは `bat`
