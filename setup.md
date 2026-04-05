# 開発環境設定リファレンス

このドキュメントは開発環境の設定内容をまとめたものです。
別の dotfiles リポジトリで同等の環境を再現する際の参考として使用してください。

**このファイルについて:** 設定ファイルの変更時に `/setup-sync` スラッシュコマンドで更新します。

---

## 概要

- **シェル**: zsh（Emacs スタイルキーバインド）
- **プロンプト**: Oh My Posh（カスタムテーマ）
- **ターミナル**: Ghostty
- **マルチプレクサ**: tmux
- **エディタ**: Neovim（lazy.nvim + Lua 設定）
- **フォント**: UDEV Gothic NFLG（BIZ UD Gothic + JetBrains Mono 合成フォント／日本語等幅・Nerd Font・リガチャ対応）

---

## ターミナルエミュレータ（Ghostty）

### フォント・外観

| 設定 | 値 |
|---|---|
| フォント | UDEV Gothic NFLG, サイズ 14 |
| リガチャ | 無効（`-liga -dlig -calt`）— CJK 入力時の誤動作回避のため |
| テーマ | catppuccin-mocha |
| 背景不透明度 | 0.95 |
| 背景ブラー | 20 |
| ウィンドウパディング | x=12, y=8 |
| タイトルバー | transparent |
| カーソル | bar + blink |

### 主要設定

| 設定 | 値 |
|---|---|
| シェル統合 | zsh（cursor, sudo, title） |
| スクロールバック | 10,000 行 |
| macOS Option | left のみ Meta キー（right は macOS 特殊文字入力用） |
| マウス | タイピング中は非表示 |
| デスクトップ通知 | 有効 |

### キーバインド

| キー | 動作 |
|---|---|
| `Cmd+Enter` | フルスクリーン切り替え |
| `Cmd+,` | 設定ファイルを開く |

---

## シェル（zsh）

### キーバインドモード

Emacs スタイル（`bindkey -e`）:

| 操作 | キー |
|---|---|
| 行頭へ移動 | `Ctrl+a` |
| 行末へ移動 | `Ctrl+e` |
| 行末まで削除 | `Ctrl+k` |
| 単語単位で前後移動 | `Alt+f` / `Alt+b` |
| ghq リポジトリ選択 | `Ctrl+g`（fzf で選択して移動） |

### サスペンドキーの変更

`Ctrl+z` を tmux prefix として使うため、シェルのサスペンド (`susp`) を `Ctrl+]` に再割り当て。

### 起動時の動作

- ターミナル起動時に tmux セッション "main" へ自動アタッチ（セッションがなければ新規作成）
- Ghostty シェル統合を自動読み込み（`$GHOSTTY_RESOURCES_DIR` が設定されている場合）

### zsh プラグイン

| プラグイン | 機能 |
|---|---|
| zsh-autosuggestions | 入力履歴からゴーストテキストで補完候補を表示 |
| zsh-syntax-highlighting | 入力中のコマンドをリアルタイムで色分け（必ず最後に読み込む） |

---

## プロンプト（Oh My Posh）

カスタムテーマ。左プロンプトに以下のセグメントを Powerline スタイルで表示：

| セグメント | 内容 | 補足 |
|---|---|---|
| OS アイコン | OS に対応した Nerd Font グリフ | ライトブルー `#9FDAF4` |
| パス | カレントディレクトリ（agnoster_short スタイル、最大深度 3） | 暗背景 `#011627` にライトブルー |
| Git | ブランチ名 + `*`（未ステージ変更）+ `+`（ステージ済み変更） | 状態により色変化 |
| 実行時間 | コマンド実行時間（2 秒以上の場合のみ表示） | 紫 `#534AB7` |
| プロンプト文字 | `❯`（正常: 緑、エラー: 赤） | 改行後に表示 |

**Git セグメントの色:**

| 状態 | 色 |
|---|---|
| クリーン | 緑 `#ADDB67` |
| 変更あり（unstaged） | オレンジ `#EF9F27` |
| リモートより遅れている | 赤 `#E24B4A` |
| リモートより進んでいる | 緑 `#ADDB67` |

**カラーパレット**（tmux ステータスバーと共通）:
- 背景: `#011627`
- アクセント: `#9FDAF4`（ライトブルー）

---

## tmux

### プレフィックスキー

`Ctrl+z`（デフォルトの `Ctrl+b` は解除。`Ctrl+a` は Emacs 行頭移動のために空ける）

### セッション・ウィンドウ操作

すべて prefix（`Ctrl+z`）の後に押す。`Ctrl` を押しっぱなしでも動作（例: `Ctrl+z` → `Ctrl+n`）。

| 操作 | キー |
|---|---|
| 新規ウィンドウ | `c` / `z`（`Ctrl+c` / `Ctrl+z` でも可） |
| 新規セッション | `N` |
| 次のウィンドウ ★ | `n`（`Ctrl+n` でも可） |
| 前のウィンドウ ★ | `p`（`Ctrl+p` でも可） |
| ウィンドウ一覧 | `w`（`Ctrl+w` でも可） |
| ウィンドウ検索 | `f`（`Ctrl+f` でも可） |
| セッション一覧 | `S` |
| デタッチ | `d`（`Ctrl+d` でも可） |

★ = `repeat-time`（1 秒）以内なら prefix 再入力不要で連続操作可能

### ペイン操作

| 操作 | キー |
|---|---|
| 左右に分割 | `v` |
| 上下に分割 | `s` |
| ペイン移動 ★ | `h` / `j` / `k` / `l`（`Ctrl+h/j/k/l` でも可） |
| ペインリサイズ ★ | `H` / `J` / `K` / `L`（5 セルずつ） |
| ペインズーム | `m`（`Ctrl+m` でも可） |
| ペインを閉じる | `q`（`Ctrl+q` でも可） |
| ペイン番号表示 | `x`（`Ctrl+x` でも可） |
| ペインローテーション | `o`（`Ctrl+o` でも可） |

### その他の設定

| 設定 | 値 |
|---|---|
| マウス操作 | 有効（スクロール、クリックでペイン選択） |
| ウィンドウ・ペイン番号 | 1 から始まる |
| ESC キー遅延 | 0ms（Vim 使用時に重要） |
| スクロールバッファ | 10,000 行 |
| repeat-time | 1,000ms |
| 設定リロード | `r`（`Ctrl+r` でも可） |
| ウィンドウ名の自動変更 | 無効（プロンプトと干渉しないため） |

### ステータスバー

Oh My Posh テーマと同じカラーパレット（背景 `#011627`、アクセント `#9FDAF4`）。
左側にセッション名と区切り線、右側に日付（YYYY-MM-DD）と時刻（HH:MM）を表示。

### プラグイン（TPM）

TPM（Tmux Plugin Manager）で管理。初回は `prefix + I` でインストール。

| プラグイン | 機能 |
|---|---|
| tmux-continuum | 15 分ごとに自動保存・起動時に自動復元 |
| tmux-resurrect | Neovim セッションも含めてセッション保存・復元（`:session` 戦略） |

**resurrect のキーバインド**: デフォルト（`prefix + Ctrl+s/r`）は無効化済み。代わりに zsh エイリアス `tmux-save` / `tmux-restore` で手動操作。

---

## CLI ツール

| ツール | 役割 |
|---|---|
| fzf | ファジーファインダー。`Ctrl+r` で履歴検索、`Ctrl+t` でファイル検索、`Alt+c` でディレクトリ検索 |
| ripgrep (`rg`) | 高速 grep。`.gitignore` を自動的に考慮 |
| fd | 高速 find。`.gitignore` を自動的に考慮 |
| bat | `cat` 置換。シンタックスハイライト・行番号付き |
| eza | `ls` 置換。カラー・アイコン・Git ステータス・ツリー表示対応 |
| zoxide | `cd` 置換。移動履歴を学習し `z KEYWORD` で高速ジャンプ |
| lazygit | Git TUI。ステージング・リベース等をキーボード操作 |
| delta | Git diff ビューア。シンタックスハイライト・サイドバイサイド表示・行番号付き |
| jq | JSON プロセッサ。API レスポンスの整形・フィルタ |
| direnv | ディレクトリ別の環境変数を `.envrc` で自動ロード |
| colima | macOS 向け軽量コンテナランタイム（Docker Desktop 代替）|
| docker / docker-compose | コンテナ操作 CLI |
| go | Go プログラミング言語 |
| php | PHP |

---

## エイリアス

### ディレクトリ移動

| エイリアス | 展開先 |
|---|---|
| `..` / `...` / `....` | `cd ../` / `cd ../../` / `cd ../../../` |
| `-` | `cd -`（直前のディレクトリ） |
| `dotfiles` | `cd ~/dotfiles` |
| `zshrc` | dotfiles の .zshrc をエディタで開いて `source` |

### ファイル操作

| エイリアス | 展開先 | 備考 |
|---|---|---|
| `ls` | `eza --icons --group-directories-first` | |
| `ll` | `eza -l --icons --git --group-directories-first` | |
| `la` | `eza -la --icons --git --group-directories-first` | |
| `lt` | `eza --tree --icons --level=2` | |
| `cat` | `bat --paging=never` | |
| `cp` / `mv` / `rm` | `-i` オプション付き | 上書き前に確認 |
| `mkdir` | `mkdir -p` | |
| `df` / `du` | `-h` / `-sh` オプション付き | |
| `grep` | `grep --color=auto` | |

### Git

| エイリアス | 展開先 |
|---|---|
| `g` | `git` |
| `gs` | `git status -sb` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `gd` | `git diff` |
| `gl` | `git log --oneline --graph --decorate -20` |
| `gp` | `git push` |
| `gpl` | `git pull` |

### tmux

| エイリアス | 展開先 |
|---|---|
| `t` | `tmux` |
| `ta` | `tmux attach -t` |
| `tl` | `tmux list-sessions` |
| `tn` | `tmux new-session -s` |
| `tk` | `tmux kill-session -t` |
| `tmux-save` | tmux-resurrect でセッションを手動保存 |
| `tmux-restore` | tmux-resurrect でセッションを手動復元 |

### Claude Code

| エイリアス | 展開先 | 備考 |
|---|---|---|
| `c` | `claude --enable-auto-mode` | |
| `cr` | `claude --resume --enable-auto-mode` | 直前のセッションを再開 |

### その他

| エイリアス | 展開先 |
|---|---|
| `lg` | `lazygit` |
| `?` | キーバインド・エイリアスのリファレンスを表示（`~/.zsh/reference.md`） |

---

## zsh 関数

| 関数 | 動作 |
|---|---|
| `mkcd <dir>` | ディレクトリを作成して移動 |
| `fcd [dir]` | fzf でディレクトリを選択して移動（eza のツリープレビュー付き） |
| `ghq-fzf` | ghq リポジトリを fzf で選択して移動（`Ctrl+g` でも起動） |
| `tmux-new [name]` | 指定名のセッションを作成（既存なら attach）。省略時は "main" |
| `path` | `$PATH` を1行ずつ番号付きで表示 |
| `extract <file>` | tar.gz / zip / gz / bz2 など各種アーカイブを展開 |

---

## Git 設定

### エイリアス（`.gitconfig`）

| エイリアス | コマンド |
|---|---|
| `st` | `status` |
| `co` | `checkout` |
| `br` | `branch` |
| `ci` | `commit` |
| `df` | `diff` |

### delta（diff ビューア）

- グローバルの `core.pager` として設定
- サイドバイサイド表示: 有効
- 行番号: 表示
- ナビゲートモード: 有効（`n`/`N` でセクション間ジャンプ）
- コンフリクトスタイル: `zdiff3`

---

## Neovim

プラグインマネージャー: **lazy.nvim**（初回起動時に自動インストール）

### 基本設定

| 設定 | 値 |
|---|---|
| カーソル常時中央 | `scrolloff = 999` |
| 行番号 | 絶対 + 相対 |
| インデント | スペース 2 幅 |
| クリップボード | システムクリップボードと連携（`unnamedplus`） |
| 一時ファイル | backup / swapfile / undofile すべて無効 |

### キーマッピング

**Leader キー: `,`**

| キー | モード | 動作 |
|---|---|---|
| `;` | Normal | `:` （コマンドモード） |
| `:` | Normal | `;` （文字検索） |
| `<C-l>` | Insert / Visual / Command | `<ESC>` |
| `<C-l>` | Normal | 検索ハイライト消去 |
| `<C-l>` / `<ESC>` | Terminal | Normal モードへ |
| `J` / `K` / `H` / `L` | Normal / Visual | 10 行 / 文字移動 |
| `<Space>w` | Normal | ファイル保存 |
| `<CR>` | Normal | 下に空行挿入 |
| `<Space>d` | Normal | 行内容を削除 |
| `q` | Normal | 無効化（誤操作防止） |
| `Q` | Normal | マクロ記録 |

**ウィンドウ操作（`s` プレフィックス）:**

| キー | 動作 |
|---|---|
| `sq` | ウィンドウを閉じる |
| `ss` / `sv` | 水平 / 垂直分割 |
| `sj/k/h/l` | 分割先へ移動 |
| `sJ/K/H/L` | 分割を移動 |
| `sT` | 水平分割してターミナル起動 |
| `st` / `sn` / `sp` | 新規タブ / 次 / 前のタブ |
| `sN` / `sP` | タブを右 / 左へ移動 |
| `<Space>..` | `init.lua` を開く |
| `<Space>.r` | 設定をリロード |

**LSP キーマップ（LSP アタッチ時のみ有効）:**

| キー | 動作 |
|---|---|
| `gd` | 定義へジャンプ |
| `K` | ホバードキュメント表示 |
| `<leader>rn` | シンボルリネーム |
| `<leader>ca` | コードアクション |
| `gr` | 参照一覧 |

### カスタムコマンド

| コマンド | 動作 |
|---|---|
| `:Inbox` | `~/.inbox.md` を開く |
| `:Temp [拡張子]` | `~/.vim_tmp/tmp.<拡張子>` を開く（省略時は `.txt`） |
| `:Format` | conform.nvim でファイルをフォーマット |

### プラグイン

| プラグイン | 説明 |
|---|---|
| catppuccin/nvim | カラースキーム（Mocha）|
| nvim-lualine/lualine.nvim | ステータスライン |
| jiangmiao/auto-pairs | 括弧の自動入力 |
| kana/vim-textobj-entire | テキストオブジェクト: ファイル全体（`ae`/`ie`） |
| kana/vim-textobj-indent | テキストオブジェクト: インデントブロック（`ai`/`ii`） |
| kana/vim-textobj-line | テキストオブジェクト: 行（`al`/`il`） |
| kana/vim-operator-replace | `R` でレジスタ内容置き換え |
| tyru/operator-camelize.vim | `<leader>c/C` でキャメルケース変換 |
| tpope/vim-commentary | `C` / `CC` でコメントアウト |
| thinca/vim-ambicmd | コマンド補完（大文字小文字無視） |
| telescope.nvim | ファジーファインダー（`<leader>uf/ub/uh/ug/um/uF`）。`um` は oldfiles（最近開いたファイル） |
| telescope-fzf-native.nvim | telescope の fzf パフォーマンス強化 |
| nvim-treesitter | シンタックスハイライト（lua / rust） |
| vim-polyglot | 多言語シンタックスハイライト |
| lewis6991/gitsigns.nvim | Git 変更をサインカラムに表示 |
| mattn/vim-findroot | `.git` のあるディレクトリを自動 cwd に設定 |
| klen/nvim-config-local | プロジェクト別設定（`local.init.lua`） |
| tyru/open-browser.vim | `<leader>o` で URL をブラウザで開く |
| rust-lang/rust.vim | Rust サポート |
| vim-insert-linenr | Insert モード時に行番号の色を変更 |
| mason.nvim | LSP・フォーマッタ・リンタのインストーラ（`:Mason` で GUI 起動） |
| mason-lspconfig.nvim | Mason と nvim-lspconfig の橋渡し |
| nvim-lspconfig | LSP クライアント設定（lua_ls, rust_analyzer） |
| nvim-cmp | コード補完エンジン（LSP + LuaSnip） |
| conform.nvim | フォーマッタ（`:Format` コマンドで実行） |

---

## Claude Code 連携

### ステータスライン

Claude Code のステータスラインに以下の情報を表示するカスタム Python スクリプト:

| 表示内容 | 備考 |
|---|---|
| カレントディレクトリ | `~` に短縮表示 |
| Git ブランチ名 + 変更状態 | `*` = unstaged 変更あり、`+` = staged あり |
| Git worktree 名 | worktree 内にいる場合のみ |
| モデル名 | 使用中の Claude モデル |
| コンテキストウィンドウ使用率 | 点字ドット進捗バー + % |
| 5 時間レート制限使用率 | 点字ドット進捗バー + % |
| 7 日間レート制限使用率 | 点字ドット進捗バー + % |

カラーは Oh My Posh テーマのパレットに合わせて統一（ライトブルー `#9FDAF4`、グリーン `#ADDB67`、オレンジ `#EF9F27`）。

### OS 通知

Claude Code のタスク完了時またはユーザーの入力待ち状態になったとき、OS 固有の手段でデスクトップ通知を送る設定をしている。

---

## パッケージ管理

### Homebrew（`homebrew/Brewfile`）

`brew bundle install --file=homebrew/Brewfile` で CLI ツール・フォント・GUI アプリを一括インストール。`install.sh` が自動で実行する。

### npm グローバルパッケージ（`npm/packages.txt`）

`install.sh` が mise 経由で Node.js を使い、`npm/packages.txt` に記載されたパッケージをグローバルインストールする。

| パッケージ | 用途 |
|---|---|
| `@anthropic-ai/claude-code` | Claude Code CLI |

新しいパッケージを追加する場合は `npm/packages.txt` に1行追記するだけでよい。

---

*最終更新: 2026-04-05*
