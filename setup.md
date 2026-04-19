# 環境設定リファレンス

別環境での再現に必要な情報をまとめたドキュメント。「この環境はこう動作する」という事実ベースの記録。

最終更新: 2026-04-19（SSH 鍵認証・xterm-ghostty terminfo 自動インストール対応）

### 凡例

| バッジ | 意味 |
|------|------|
| [macOS] | macOS 固有の機能・アプリに依存する設定 |
| [Mac mini] | Mac mini（サーバー用途）でのみ必要な設定 |

バッジなしは環境を問わず再現可能な設定。

---

## 概要

| 項目           | 内容                                        |
|--------------|-------------------------------------------|
| OS           | macOS（Apple Silicon / Intel 両対応）          |
| シェル         | zsh（Homebrew 版）                           |
| ターミナル       | Ghostty [macOS]                           |
| マルチプレクサ    | tmux（prefix: `Ctrl-z`）                    |
| エディタ        | Neovim（lazy.nvim によるプラグイン管理）             |
| プロンプト       | Oh My Posh（カスタムテーマ: `ohmyposh-theme.json`） |
| バージョン管理    | mise（Node.js / Python / Ruby 等）           |
| パッケージ管理    | Homebrew                                  |
| ランチャー       | Raycast [macOS]                           |
| ウィンドウ管理    | Amethyst（タイル型）[macOS]                     |
| キーボード       | Karabiner-Elements [macOS]                |
| IME          | Google 日本語入力 [macOS]                     |

---

## セットアップ手順

```bash
# 1. リポジトリをクローン
git clone <repo-url> ~/dotfiles

# 2. install.sh を実行（シンボリックリンク作成 + Claude Code 設定）
bash ~/dotfiles/bin/install.sh

# 3. Homebrew パッケージをインストール
brew bundle install --file=~/dotfiles/homebrew/Brewfile

# 4. TPM（tmux プラグインマネージャ）を初期化
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tmux 起動後: prefix + I でプラグインインストール

# 5. Neovim 起動（lazy.nvim が自動インストール）
nvim
```

---

## Homebrew パッケージ

### CLI ツール（必須）

| パッケージ       | 用途                          |
|--------------|------------------------------|
| git          | Git 最新版                    |
| zsh          | zsh 最新版                    |
| tmux         | ターミナルマルチプレクサ           |
| oh-my-posh   | プロンプトエンジン               |

### モダン Unix ツール

| パッケージ          | 用途                                   |
|-----------------|---------------------------------------|
| eza             | ls の代替（アイコン・Git 表示）           |
| bat             | cat の代替（シンタックスハイライト）        |
| fd              | find の代替                            |
| ripgrep         | grep の代替（爆速）                     |
| fzf             | ファジーファインダー                      |
| zoxide          | cd の強化版（よく行くディレクトリを記憶）    |
| git-delta       | git diff のシンタックスハイライト          |
| ghq             | Git リポジトリをディレクトリ構造で管理      |
| jq              | JSON プロセッサ                         |
| yq              | YAML プロセッサ                         |
| mise            | Node.js / Python 等のバージョン管理      |
| lazygit         | Git TUI                               |
| gh              | GitHub CLI                            |
| glow            | ターミナルでの Markdown プレビュー        |
| direnv          | ディレクトリ別の環境変数を .envrc で管理   |
| neovim          | テキストエディタ                         |
| zsh-autosuggestions    | 入力履歴からの補完候補表示          |
| zsh-syntax-highlighting | コマンドのリアルタイム色分け       |

### フォント（Nerd Font）[macOS]

| パッケージ                     | 用途                                          |
|------------------------------|----------------------------------------------|
| font-jetbrains-mono-nerd-font | JetBrains Mono Nerd Font                     |
| font-udev-gothic-nf           | UDEV Gothic NF（BIZ UD Gothic + JetBrains Mono 合成、日本語等幅対応） |

### コンテナ / 言語

| パッケージ          | 用途                              |
|-----------------|----------------------------------|
| colima          | macOS 向け軽量コンテナランタイム [Mac mini] |
| docker          | Docker CLI [Mac mini]            |
| docker-compose  | Docker Compose [Mac mini]        |
| docker-completion | Docker シェル補完 [Mac mini]     |
| go              | Go プログラミング言語               |
| php             | PHP                              |

### アプリケーション（cask）[macOS]

| パッケージ                | 用途                            |
|------------------------|-------------------------------|
| ghostty                | ターミナルエミュレータ              |
| vivaldi                | ウェブブラウザ                    |
| claude                 | Claude デスクトップアプリ          |
| discord                | チャット・コミュニティ              |
| slack                  | ビジネスチャット                   |
| notion                 | ドキュメント・データベース           |
| spotify                | 音楽ストリーミング                  |
| amethyst               | タイル型ウィンドウマネージャ         |
| karabiner-elements     | キーボードカスタマイズ              |
| google-japanese-ime    | Google 日本語入力                 |
| logi-options+          | Logicool マウス・キーボード設定     |
| raycast                | ランチャー・ユーティリティ           |
| tailscale-app          | VPN メッシュネットワーク（リモートアクセス）[Mac mini] |

---

## Claude Code

- npm 経由でインストール（`npm/packages.txt` で管理、`install.sh` が mise 経由で自動インストール）
- カスタムステータスライン: `claude/statusline.py`（`~/.claude/statusline.py` にシンボリックリンク）
  - カレントディレクトリ、Git ブランチ（変更状態付き）、worktree 名、モデル名を表示
  - コンテキスト使用率・レート制限（5h / 7d）を点字ドット風バーで可視化
  - カラーパレット: Oh My Posh / tmux テーマと統一（ライトブルー #9FDAF4 ベース）

### エイリアス

| コマンド | 動作                                           |
|--------|-----------------------------------------------|
| `c`    | `claude --dangerously-skip-permissions`        |
| `cr`   | `claude --resume --dangerously-skip-permissions` |

---

## Ghostty [macOS]

フォント・外観:

| 設定                    | 値                              |
|------------------------|--------------------------------|
| フォント                 | UDEV Gothic NFLG               |
| フォントサイズ            | 14                             |
| リガチャ                 | 無効（-liga, -dlig, -calt）CJK 誤動作回避 |
| テーマ                   | catppuccin-mocha               |
| 背景透明度               | 0.95                           |
| 背景ブラー                | 20                             |
| タイトルバー              | transparent                    |
| カーソル                  | bar（点滅あり）                  |

シェル統合: `shell-integration = zsh`（cursor, sudo, title）

キーバインド:

| キー             | 動作               |
|----------------|------------------|
| `Cmd+Enter`    | フルスクリーン切り替え [macOS] |
| `Cmd+,`        | 設定を開く [macOS]   |

その他:
- `macos-option-as-alt = left` — 左 Alt を Meta キーとして使用（zsh キーバインド有効化）[macOS]
- クリップボード読み書き: allow、末尾スペースのトリム: on
- スクロールバック: 10000 行
- デスクトップ通知: on

---

## tmux

prefix: `Ctrl-z`

### ウィンドウ操作

| キー               | 動作                     |
|------------------|------------------------|
| `prefix c / z`   | 新規ウィンドウ（現在パスを引き継ぐ） |
| `prefix n / C-n` | 次のウィンドウ（repeat可）   |
| `prefix p / C-p` | 前のウィンドウ（repeat可）   |
| `prefix w / C-w` | ウィンドウ一覧             |
| `prefix ,`       | ウィンドウ名変更             |
| `prefix &`       | ウィンドウを閉じる           |
| `prefix S`       | セッション一覧（ツリー形式）   |
| `prefix N`       | 新規セッション              |
| `prefix d / C-d` | デタッチ                  |

### ペイン操作

| キー                   | 動作                   |
|----------------------|----------------------|
| `prefix v`           | 左右に分割              |
| `prefix s`           | 上下に分割              |
| `prefix h/j/k/l`     | ペイン移動（vim 風、repeat可） |
| `prefix H/J/K/L`     | ペインサイズ変更（5セルずつ） |
| `prefix q / C-q`     | ペインを閉じる           |
| `prefix m`           | ペインズーム（最大化）     |
| `prefix x / C-x`     | ペイン番号表示           |
| `prefix o / C-o`     | ペインローテーション       |

### コピーモード（vi キーバインド）

| キー       | 動作                  |
|----------|---------------------|
| `v`      | ビジュアル選択開始        |
| `C-v`    | 矩形選択              |
| `y`      | コピー（pbcopy に送る）[macOS] |
| `Enter`  | コピー＆終了           |

### プラグイン（TPM）

| プラグイン              | 動作                              |
|--------------------|---------------------------------|
| tmux-resurrect     | セッション保存・復元（`tmux-save` / `tmux-restore` エイリアスで操作） |
| tmux-continuum     | 15 分ごとに自動保存、起動時に自動復元    |

resurrect のデフォルトキーバインドは F10/F11 に退避（通常操作から外している）。

ステータスバー: Night Owl カラーパレット（背景 #011627、アクセント #9FDAF4）

---

## zsh

### 環境変数（.zshenv）

| 変数            | 値                |
|---------------|-----------------|
| EDITOR        | vim             |
| VISUAL        | vim             |
| LANG / LC_ALL | ja_JP.UTF-8     |
| XDG_CONFIG_HOME | ~/.config     |

Homebrew PATH は `.zshenv` で設定（非ログインシェル・Claude Code 等でも有効）。

### オプション

| オプション             | 動作                              |
|--------------------|----------------------------------|
| AUTO_CD            | ディレクトリ名だけで cd              |
| AUTO_PUSHD         | cd のたびにスタックへ積む           |
| CORRECT            | コマンドのタイポを提案              |
| HIST_IGNORE_ALL_DUPS | 全履歴から重複を除去             |
| SHARE_HISTORY      | 複数セッション間で履歴を共有        |
| EXTENDED_HISTORY   | タイムスタンプを記録               |

履歴: 100,000 件、`~/.zsh_history` に保存。

### キーバインド（Emacs スタイル）

| キー      | 動作                        |
|---------|---------------------------|
| `Ctrl+R` | 履歴インクリメンタル検索       |
| `Ctrl+P` | 前の履歴                   |
| `Ctrl+N` | 次の履歴                   |
| `Ctrl+g`（bindkey -s） | ghq-fzf でリポジトリ移動 |

`stty susp '^]'`: `Ctrl+z` を tmux prefix に明け渡すため、サスペンドを `Ctrl+]` に移動。

### エイリアス

| コマンド     | 動作                                        |
|-----------|-------------------------------------------|
| `ls`      | `eza --icons --group-directories-first`   |
| `ll`      | `eza -l --icons --git --group-directories-first` |
| `la`      | `eza -la --icons --git --group-directories-first` |
| `lt`      | `eza --tree --icons --level=2`            |
| `cat`     | `bat --paging=never`                      |
| `g`       | `git`                                     |
| `gs`      | `git status -sb`                          |
| `ga`      | `git add`                                 |
| `gc`      | `git commit`                              |
| `gco`     | `git checkout`                            |
| `gb`      | `git branch`                              |
| `gd`      | `git diff`                                |
| `gl`      | `git log --oneline --graph --decorate -20` |
| `gp`      | `git push`                                |
| `gpl`     | `git pull`                                |
| `lg`      | `lazygit`                                 |
| `ta`      | `tmux attach -t`                          |
| `tl`      | `tmux list-sessions`                      |
| `tn`      | `tmux new-session -s`                     |
| `tk`      | `tmux kill-session -t`                    |
| `tmux-save`    | tmux-resurrect セッション手動保存      |
| `tmux-restore` | tmux-resurrect セッション手動復元      |
| `c`       | `claude --dangerously-skip-permissions`   |
| `cr`      | `claude --resume --dangerously-skip-permissions` |
| `p`       | `pipes.sh`                                |
| `dotfiles` | `cd ~/dotfiles`                          |
| `zshrc`   | dotfiles の .zshrc を開いて source       |
| `?`       | キーバインド・エイリアスリファレンス表示     |

### シェル関数

| 関数        | 動作                                           |
|-----------|----------------------------------------------|
| `t`       | 引数あり → セッションに attach（なければ作成）、引数なし → セッション一覧 |
| `mkcd`    | ディレクトリを作って移動                          |
| `fcd`     | fzf でディレクトリを選んで移動                    |
| `ghq-fzf` | ghq リポジトリを fzf で選んで移動（`Ctrl+g` にバインド） |
| `path`    | PATH を番号付きで表示                            |
| `extract` | 各種アーカイブを展開（.tar.gz, .zip 等）          |
| `mm`      | Mac mini に SSH 接続（LAN 優先、圏外なら Tailscale 経由で自動切替）[macOS] |

### プラグイン

- `zsh-autosuggestions`: 入力履歴からゴーストテキストで補完候補を表示
- `zsh-syntax-highlighting`: 入力中のコマンドをリアルタイムで色分け（必ず最後に読み込む）

---

## Git

設定ファイル: `git/.gitconfig`（`~/.gitconfig` にリンク）
ユーザー情報（name / email）は `install.sh` が `~/.gitconfig.local` に対話的に設定。

| 設定               | 値                                        |
|------------------|------------------------------------------|
| core.editor      | vim                                      |
| core.pager       | delta（git-delta）                        |
| init.defaultBranch | main                                   |
| pull.rebase      | true（マージコミットを作らない）              |
| fetch.prune      | true（削除済みリモートブランチを自動削除）     |
| push.default     | current                                  |
| merge.conflictstyle | zdiff3（base を表示）                   |
| diff.algorithm   | histogram                                |

### git-delta

| 設定           | 値                  |
|--------------|-------------------|
| navigate     | true（n/N で差分移動） |
| side-by-side | true              |
| line-numbers | true              |
| syntax-theme | Catppuccin-mocha  |

### Git エイリアス

| エイリアス  | 動作                               |
|----------|----------------------------------|
| `st`     | `status -sb`                     |
| `lg`     | `log --oneline --graph --decorate` |
| `lga`    | `log --oneline --graph --decorate --all` |
| `amend`  | `commit --amend --no-edit`        |
| `brs`    | ブランチ一覧（最終更新日付き）        |
| `sync`   | リモートのデフォルトブランチへ rebase |
| `nuke`   | 作業ツリーを完全リセット（危険）       |

---

## Neovim

設定: `nvim/`（`~/.config/nvim/` にリンク）
プラグインマネージャ: lazy.nvim（`init.lua` で自動ブートストラップ）

### 基本設定（core.lua）

| 設定               | 値                         |
|------------------|--------------------------|
| number           | true（行番号表示）            |
| relativenumber   | true                      |
| cursorline       | true                      |
| cursorcolumn     | true                      |
| scrolloff        | 999（カーソルを常に中央付近に）  |
| signcolumn       | yes                       |
| expandtab        | true                      |
| tabstop / shiftwidth / softtabstop | 2       |
| clipboard        | unnamedplus（システムクリップボードと共有） |
| ignorecase / smartcase | true              |
| splitbelow       | true                      |
| backup / swapfile / undofile | false（一時ファイル無効） |

Leader キー: `,`

### キーマッピング（keymap.lua）

| キー         | モード    | 動作                        |
|------------|--------|---------------------------|
| `;`        | normal | `:` に                     |
| `:`        | normal | `;` に（入れ替え）           |
| `Ctrl+l`   | insert/visual/command | ESC           |
| `Ctrl+l`   | normal | `:nohlsearch`（検索ハイライト消去） |
| `Ctrl+l`   | terminal | ノーマルモードへ             |
| `ESC`      | terminal | ノーマルモードへ             |
| `J / K / H / L` | normal/visual | 10 行/列ずつ高速移動   |
| `Space+w`  | normal | ファイル保存                 |
| `Enter`    | normal | 下に空行挿入                 |
| `Space+d`  | normal | 行内容を削除（空行にする）     |
| `q`        | normal | Nop（誤操作防止）            |
| `Q`        | normal | マクロ記録（q の代替）         |

ウィンドウ分割（`s` プレフィックス）:

| キー   | 動作                |
|------|-------------------|
| `sq` | ウィンドウを閉じる    |
| `ss` | 水平分割            |
| `sv` | 垂直分割            |
| `sj/k/h/l` | ペイン移動     |
| `sJ/K/H/L` | ペインを移動（ウィンドウ全体） |
| `sT` | ターミナルを下に分割   |

タブページ:

| キー   | 動作               |
|------|--------------------|
| `st` | 新規タブ           |
| `sn` | 次のタブ           |
| `sp` | 前のタブ           |
| `sN` | タブを右に移動      |
| `sP` | タブを左に移動      |

設定ファイル:

| キー        | 動作              |
|-----------|-----------------|
| `Space+..` | init.lua を開く  |
| `Space+.r` | init.lua を再読み込み |

### プラグイン一覧

**外観・UI**

| プラグイン                      | 動作                              |
|-----------------------------|----------------------------------|
| catppuccin/nvim              | カラースキーム（mocha フレーバー）    |
| nvim-lualine/lualine.nvim    | ステータスライン（catppuccin テーマ） |
| cohama/vim-insert-linenr     | Insert モード時の行番号色変更       |
| lewis6991/gitsigns.nvim      | Git 変更をガターに表示              |

**編集補助**

| プラグイン                       | キー / コマンド             | 動作                        |
|------------------------------|--------------------------|---------------------------|
| jiangmiao/auto-pairs         | —                        | 括弧の自動入力               |
| kana/vim-textobj-user        | —                        | テキストオブジェクト拡張フレームワーク |
| kana/vim-textobj-entire      | `ae / ie`                | バッファ全体をテキストオブジェクトに |
| kana/vim-textobj-indent      | `ai / ii`                | インデントブロックをテキストオブジェクトに |
| kana/vim-textobj-line        | `al / il`                | 行をテキストオブジェクトに      |
| kana/vim-operator-replace    | `R`（normal/visual）, `p`（visual） | レジスタ内容で置き換え   |
| tyru/operator-camelize.vim   | `Leader+c / C`           | キャメルケース変換・解除       |
| tpope/vim-commentary         | `C` / `CC`               | コメントアウト               |
| thinca/vim-ambicmd           | Space / Enter（command）  | コマンド補完（大文字小文字無視） |
| mattn/vim-findroot           | —                        | .git があるディレクトリを自動 cwd 設定 |
| klen/nvim-config-local       | —                        | プロジェクト別設定（local.init.lua） |
| tyru/open-browser.vim        | `Leader+o`               | URL をブラウザで開く          |

**ファジーファインダー（Telescope）**

| キー          | 動作                                  |
|-------------|-------------------------------------|
| `Leader+uf` | ファイル検索（隠しファイル含む、.git/objects 除外） |
| `Leader+ub` | バッファ一覧                          |
| `Leader+uh` | ヘルプタグ                           |
| `Leader+ug` | Live Grep（ripgrep）                 |
| `Leader+um` | 最近開いたファイル                     |

`Ctrl+l` でウィンドウを閉じる（Telescope ウィンドウ内）。

**ファイラ（neo-tree.nvim）**

| キー / 設定    | 動作                             |
|-------------|--------------------------------|
| `Leader+ff` | Neotree toggle reveal          |
| `S`         | 水平分割で開く                   |
| `V`         | 垂直分割で開く                   |
| 隠しファイル  | 表示（hide_dotfiles = false）    |
| .gitignore  | 非表示（hide_gitignored = true） |

**LSP / 補完 / フォーマット**

| プラグイン                       | 動作                              |
|------------------------------|----------------------------------|
| williamboman/mason.nvim       | LSP・フォーマッタ・リンタのインストーラ（`:Mason`） |
| williamboman/mason-lspconfig  | Mason と nvim-lspconfig の橋渡し    |
| neovim/nvim-lspconfig         | LSP クライアント設定                |
| hrsh7th/nvim-cmp              | コード補完エンジン                  |
| L3MON4D3/LuaSnip              | スニペットエンジン                  |
| stevearc/conform.nvim         | フォーマッタ（`:Format` コマンド）  |

自動インストールされる LSP: `lua_ls`（Lua）, `rust_analyzer`（Rust）

対応フォーマッタ: stylua（Lua）, rustfmt（Rust）, prettier（JS / TS / JSON / Markdown）

LSP キーマップ（アタッチ時に有効化）:

| キー          | 動作             |
|-------------|----------------|
| `gd`        | 定義へジャンプ     |
| `K`         | ホバー情報表示    |
| `Leader+rn` | シンボルリネーム   |
| `Leader+ca` | コードアクション   |
| `gr`        | 参照一覧         |
| `[d / ]d`   | 前後の診断へ移動  |

**Treesitter**

自動インストール: lua, rust, typescript, tsx, javascript

**言語サポート**

| プラグイン          | 動作         |
|-----------------|------------|
| rust-lang/rust.vim | Rust サポート |

**カスタムコマンド**

| コマンド        | 動作                                   |
|--------------|--------------------------------------|
| `:Inbox`     | `~/.inbox.md` を開く                  |
| `:Temp [拡張子]` | `~/.vim_tmp/tmp.<拡張子>` を開く（デフォルト .txt） |
| `:Format`    | conform.nvim で現在バッファをフォーマット |

---

## SSH 設定 [macOS]

設定ファイル: `~/.ssh/config`（dotfiles 管理外・手動設定）

```
# 自宅 LAN（mDNS）
Host home
    HostName home.local
    User tekkoc
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60

# Tailscale 経由（外出時）
Host home-ts
    HostName home.tail90e844.ts.net
    User tekkoc
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
```

Mac mini へのパスワードなし接続には公開鍵の登録が必要:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub home
```

`mm` 関数はこの設定を前提とし、`home`（LAN）への接続を試みて失敗した場合に `home-ts`（Tailscale）へ自動切替する。

---

## macOS システム設定 [macOS]

### IME（Google 日本語入力）

1. **入力ソースに Google 日本語入力を追加**（システム設定 > キーボード > 入力ソース）
2. **Ctrl+Space の IME 切替を解除**（システム設定 > キーボード > キーボードショートカット > 入力ソース）
   - 「前の入力ソースを選択」「入力メニューの次のソースを選択」のチェックを外す
   - Raycast のショートカットと競合するため

### Karabiner-Elements [macOS]

Kinesis キーボード向けのキー変更:

| 変更前        | 変更後         | 目的                   |
|-------------|-------------|----------------------|
| CapsLock    | IME off（英数） | IME を確実に無効化        |
| Right Command | IME on（かな） | IME を確実に有効化        |

> **注意**: CapsLock を Ctrl にリマップする設定（macOS 標準の「修飾キー」設定）は **しないこと**。Karabiner と競合する。

起動後、アクセシビリティ・入力監視の権限を付与すること。

### Raycast [macOS]

- 起動ショートカット: `Ctrl+Space`（デフォルトの `Cmd+Space` から変更）
- Spotlight のショートカットは別キーに退避するか無効化する

### Vivaldi [macOS]

- デフォルトブラウザに設定
- タブバーを左側に配置（設定 > 外観 > タブの位置: 左）
- Vivaldi アカウントでログインしてブックマーク・設定を同期

### Mac mini ロック画面 [Mac mini]

- ロック画面のロック処理を無効化（システム設定 > ロック画面 > スリープまたはスクリーンセーバーの開始後にパスワードを要求 → 「しない」）
- 常時稼働サーバーとして使うため、物理アクセスがない前提でロックを省略する

---

## トラブルシューティング

| 症状                       | 確認箇所                                              |
|--------------------------|------------------------------------------------------|
| zsh の設定が反映されない       | `source ~/.zshrc` / シェルを再起動                     |
| Homebrew コマンドが見つからない | `.zprofile` の `brew shellenv` が通っているか確認      |
| tmux 内で色がおかしい         | `.tmux.conf` の `terminal-overrides` / `default-terminal` を確認 |
| Ghostty で日本語入力がおかしい | `font-feature` の設定と Ghostty のバージョンを確認       |
| `install.sh` でリンクが失敗   | `bash bin/install.sh --check` で状態確認              |
| Neovim で LSP が動かない      | `:Mason` でサーバーの状態を確認                        |
| SSH 接続時に `missing or unsuitable terminal: xterm-ghostty` | 接続先で `install.sh` を実行（`xterm-ghostty` terminfo を自動インストール） |
