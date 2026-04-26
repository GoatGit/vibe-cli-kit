# Terminal Cheatsheet

含まれるツール：Ghostty、Yazi、lsd、bat、tmux、fzf、fd、atuin、zoxide、Neovim、ripgrep、lazygit、rich-cli、glow、fastfetch、btop。

## High Frequency

- `v`：引数なしでこのチートシートを開く
- `v doctor`：ツールと設定の状態を確認
- `v project`：プロジェクト種別と推奨コマンドを表示
- `v r 3000`：ポートを解放して現在のプロジェクトを再起動
- `v session code`：`code` workspace を開く
- `e`：ファイルをあいまい選択して `nvim` で開く
- `fif tmux`：内容検索してヒット位置へ移動
- `p`：プロジェクトディレクトリへ移動
- `tmn`：現在のディレクトリ名で tmux セッションを作成/再利用
- `y`：Yazi を開く
- `rg foo`：全文検索
- `z foo`：よく使うディレクトリへ移動
- `lazygit`：Git TUI を開く
- `nvim .`：現在のディレクトリを開く

## Shell

- `v` / `hk` / `hotkeys`：チートシートを開く
- `v doctor`：インストールと設定の状態を確認
- `v backup --only tmux`：現在の tmux 設定を退避
- `v diff --only tmux`：テンプレートとの差分を確認
- `v sync --dry-run --only tmux`：tmux 設定同期をプレビュー
- `v update --dry-run --no-sync`：ツール更新だけをプレビュー
- `v project`：現在のプロジェクト種別と推奨コマンドを表示
- `v r 3000`：ポートを解放して検出した起動コマンドを実行
- `v session code|backend|frontend|ai`：workspace を作成または再利用
- `p`：プロジェクトディレクトリへ移動
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

コピー・モード：`v` で選択、`y` でコピーして終了

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

- `y`：Yazi を開く
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

## Search

- `Ctrl+r`：履歴のあいまい検索
- `Ctrl+t`：ファイルパスをあいまい挿入
- `Alt+c`：ディレクトリをあいまい移動
- `rg foo`：全文検索
- `rg -i foo`：大文字小文字を無視
- `rg -n foo`：行番号を表示
- `rg --files`：ファイル一覧
- `rg --files | fzf`：ファイルをあいまい選択
- `bat file`：シンタックスハイライト付きで表示
- `fd . | fzf`：ファイルやディレクトリをあいまい選択

## Edit / Git

- `nvim`：Neovim を開く
- `nvim .`：現在のディレクトリを開く
- `nvim file`：ファイル編集
- `e`：ファイルをあいまい選択して開く
- `fif foo`：内容検索して該当行へ移動
- `lazygit`：Git TUI を開く
- `glow file.md`：ターミナルで Markdown を読む

## Jump

- `p`：共通プロジェクトルートからあいまい選択
- `p foo`：`zoxide` またはプロジェクト名で移動
- `z foo`：よく使うディレクトリへ移動
- `zi`：対話的ディレクトリ移動
- `tmx [name]`：tmux セッションへ入る。既定は `main`
- `tmx dev`：`dev` セッションへ入る
- `tmn`：現在のディレクトリ名でセッションを作成または再利用
- `tma`：`main` に attach
- `tml`：すべてのセッションを表示
