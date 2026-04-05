# 開発環境設定リファレンス

このドキュメントは開発環境の設定内容をまとめたものです。
別の dotfiles リポジトリで同等の環境を再現する際の参考として使用してください。

**このファイルについて:** Claude Code のメモリ機能により、`configs/` や `lib/` 配下の設定ファイルが変更された際に自動的に内容が更新されます。

---

## 概要

- **シェル**: zsh（Emacs スタイルキーバインド）
- **プロンプト**: Oh My Posh（カスタムテーマ）
- **マルチプレクサ**: tmux
- **エディタ**: Neovim（lazy.nvim + Lua 設定）
- **フォント**: UDEV Gothic NFLG（BIZ UD Gothic + JetBrains Mono 合成フォント／日本語等幅・Nerd Font・リガチャ対応）

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

### サスペンドキーの変更

`Ctrl+z` を tmux prefix として使うため、シェルのサスペンド (`susp`) を `Ctrl+]` に再割り当て。

### 起動時の動作

- ターミナル起動時に tmux セッション "main" へ自動アタッチ（セッションがなければ新規作成）

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
左側にセッション名、右側に時刻を表示。

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

### zsh プラグイン

| プラグイン | 機能 |
|---|---|
| zsh-autosuggestions | 入力履歴からゴーストテキストで補完候補を表示 |
| zsh-syntax-highlighting | 入力中のコマンドをリアルタイムで色分け |

---

## エイリアス

| エイリアス | 展開先 | 備考 |
|---|---|---|
| `c` | `claude --enable-auto-mode` | `--no-auto` オプションで auto-mode を無効化して起動 |
| `cr` | `claude --resume --enable-auto-mode` | 直前のセッションを再開 |
| `g` | `git` | |
| `g wt` | `git worktree` | |
| `t` | `tmux` | |
| `lg` | `lazygit` | |
| `ls` | `eza` | |
| `ll` | `eza -l --git` | |
| `la` | `eza -la --git` | |
| `lt` | `eza --tree --level=3` | |
| `?` | `less <mappings file>` | キーバインド・エイリアスのリファレンスを表示 |

---

## Git 設定

### エイリアス

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

### カスタムコマンド

| コマンド | 動作 |
|---|---|
| `:Inbox` | `~/.inbox.md` を開く |
| `:Temp [拡張子]` | `~/.vim_tmp/tmp.<拡張子>` を開く（省略時は `.txt`） |

### プラグイン

| プラグイン | 説明 |
|---|---|
| catppuccin/nvim | カラースキーム（Mocha）|
| nvim-lualine/lualine.nvim | ステータスライン |
| jiangmiao/auto-pairs | 括弧の自動入力 |
| kana/vim-textobj-* | テキストオブジェクト拡張（entire / indent / line） |
| kana/vim-operator-replace | `R` でレジスタ内容置き換え |
| tyru/operator-camelize.vim | `<leader>c/C` でキャメルケース変換 |
| tpope/vim-commentary | `C` / `CC` でコメントアウト |
| thinca/vim-ambicmd | コマンド補完（大文字小文字無視） |
| telescope.nvim | ファジーファインダー（`<leader>uf/ub/uh/ug/um/uF`）。`um` は oldfiles（最近開いたファイル） |
| nvim-treesitter | シンタックスハイライト（lua / rust） |
| lewis6991/gitsigns.nvim | Git 変更をサインカラムに表示 |
| mattn/vim-findroot | `.git` のあるディレクトリを自動 cwd に設定 |
| klen/nvim-config-local | プロジェクト別設定（`local.init.lua`） |
| tyru/open-browser.vim | `<leader>o` で URL をブラウザで開く |
| rust-lang/rust.vim | Rust サポート |

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

*最終更新: 2026-04-03*
