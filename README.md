# dotfiles (macOS)

macOS 専用の dotfiles です。Ghostty + zsh + tmux + Claude Code CLI を中心とした開発環境を管理します。

## 構成

```
dotfiles/
├── bin/
│   └── install.sh       # セットアップスクリプト
├── ghostty/
│   └── config           # Ghostty 設定
├── git/
│   └── .gitconfig       # Git 設定
├── homebrew/
│   └── Brewfile         # Homebrew パッケージ一覧
├── tmux/
│   └── .tmux.conf       # tmux 設定
└── zsh/
    ├── .zshenv          # 環境変数（全シェル共通、最初に読まれる）
    ├── .zprofile        # ログインシェル用（Homebrew PATH など）
    ├── .zshrc           # インタラクティブシェル用
    └── .zsh/
        ├── aliases.zsh  # エイリアス
        ├── functions.zsh # 関数
        └── completions/ # 補完スクリプト置き場
```

## セットアップ

### 前提条件

- macOS 14 (Sonoma) 以降
- Xcode Command Line Tools（後述の手順で導入）

### 初回セットアップ手順

**Terminal.app**（macOS 標準）から実行します。Ghostty はまだ入っていないため、
`install.sh` を実行してから Ghostty を起動してください。

#### Step 1: 事前準備

```bash
# Xcode Command Line Tools をインストール（git に必要）
xcode-select --install

# SSH キーを生成して GitHub に登録
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
# 表示された公開鍵を GitHub → Settings → SSH and GPG keys に登録
```

#### Step 2: install.sh を実行

```bash
# リポジトリをクローン（SSH）
git clone git@github.com:<your-name>/dotfiles.git ~/dev/dotfiles

# セットアップスクリプトを実行
bash ~/dev/dotfiles/bin/install.sh
```

`install.sh` は以下を順に実行します：

1. Homebrew のインストール（未インストールの場合）
2. `Brewfile` からパッケージをインストール（Ghostty・Slack・Discord など）
3. mise で Node.js (LTS) をセットアップ
4. npm グローバルパッケージのインストール（Claude Code CLI など）
5. 各設定ファイルをホームディレクトリへシンボリックリンク
6. Ghostty テーマ（catppuccin-mocha）をダウンロード
7. macOS デフォルト設定を適用（Dock・Finder・キーリピートなど）
8. Git ユーザー情報の設定（初回のみ対話入力）
9. zsh をデフォルトシェルに設定

> **注意:** `install.sh` を完了する前に Ghostty を起動するとテーマが見つからないエラーが出ます。

#### Step 3: install.sh 完了後の手動作業

```bash
# Claude Code にログイン
claude login

# Tailscale にログイン（Mac mini などリモートアクセスが必要な場合）
tailscale login
```

tmux を起動し、`prefix + I`（`Ctrl-z` → `I`）でプラグインをインストールしてください。

**GUI での手動設定が必要なもの:**

| アプリ | 作業内容 |
|---|---|
| Karabiner-Elements | システム設定 → プライバシーとセキュリティ → アクセシビリティで権限付与 |
| Raycast | システム設定 → プライバシーとセキュリティ → アクセシビリティで権限付与 |
| Google 日本語入力 | システム設定 → キーボード → 入力ソースでデフォルト IME に設定 |

### install.sh オプション

| オプション | 動作 |
|---|---|
| （なし） | フルセットアップ。Homebrew・パッケージ・リンク・テーマ・Git 設定・シェル変更をすべて実行 |
| `--link-only` | Homebrew・パッケージインストールをスキップし、リンク作成とテーマダウンロードのみ実行。再セットアップや設定ファイルの追加時に使う |
| `--check` | 実際には何も変更せず、シンボリックリンクの状態を確認するだけ |

```bash
# 設定ファイルを追加・変更したあとにリンクを貼り直す
bash bin/install.sh --link-only

# シンボリックリンクが正しく張られているか確認する
bash bin/install.sh --check
```

## 各ツールの設定概要

### Ghostty

`~/.config/ghostty/config` にシンボリックリンクを貼ります。
日本語 IME 対応・True Color・tmux 互換の設定が含まれています。

テーマ（catppuccin-mocha）は `~/.config/ghostty/themes/` にダウンロードされます。
`install.sh` が自動で取得するため、手動インストールは不要です。

### zsh

| ファイル | 役割 |
|---|---|
| `.zshenv` | `ZDOTDIR` など最小限の環境変数 |
| `.zprofile` | Homebrew PATH、ログイン時のみ実行 |
| `.zshrc` | プロンプト、補完、プラグインなど |

### tmux

prefix キーは `Ctrl-a` です（`Ctrl-b` から変更）。
True Color・マウス操作・vi キーバインドを有効にしています。

### Git

`~/.gitconfig` にシンボリックリンクを貼ります。
ユーザー情報（name / email）は初回セットアップ時に入力を求めます。

## リモートアクセス（Tailscale + SSH）

### Tailscale

Brewfile に含まれているため `install.sh` でインストールされます。
インストール後はメニューバーのアイコンからログインし、両機を同じ Tailnet に参加させてください。
MagicDNS を有効にすると `<hostname>.<tailnet>.ts.net` で名前解決できます。

### SSH 設定

`~/.ssh/config` はマシン固有の接続先情報を含むため dotfiles では管理しません。
以下を参考に各マシンで手動設定してください。

**クライアント側（MacBook）の `~/.ssh/config` 例:**

```sshconfig
# 自宅 LAN（mDNS）
Host mac-mini
    HostName mac-mini.local
    User <username>
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60

# Tailscale 経由（外出時）
Host mac-mini-ts
    HostName <mac-mini>.<tailnet>.ts.net
    User <username>
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
```

> **SSH 接続される側（Mac mini など）の追加設定:**
>
> システム設定で SSH サーバを有効にしないと接続できません。
> **システム設定 → 一般 → 共有 → 「リモートログイン」をオン**
>
> あわせて公開鍵を登録しておくとパスワード不要になります:
> ```bash
> ssh-copy-id -i ~/.ssh/id_ed25519.pub <username>@mac-mini.local
> ```

## メンテナンス

### Brewfile の更新

```bash
brew bundle dump --force --file ~/dotfiles/homebrew/Brewfile
```

### シンボリックリンクの状態確認

```bash
bash bin/install.sh --check
```
