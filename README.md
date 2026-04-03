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
- Xcode Command Line Tools (`xcode-select --install`)

### 手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/<your-name>/dotfiles.git ~/dotfiles

# 2. セットアップスクリプトを実行
cd ~/dotfiles
bash bin/install.sh
```

スクリプトは以下を行います：

1. Homebrew のインストール（未インストールの場合）
2. `Brewfile` からパッケージをインストール
3. 各設定ファイルをホームディレクトリへシンボリックリンク
4. zsh をデフォルトシェルに設定

### 手動でシンボリックリンクのみ貼り直す場合

```bash
bash bin/install.sh --link-only
```

## 各ツールの設定概要

### Ghostty

`~/.config/ghostty/config` にシンボリックリンクを貼ります。
日本語 IME 対応・True Color・tmux 互換の設定が含まれています。

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

## メンテナンス

### Brewfile の更新

```bash
brew bundle dump --force --file ~/dotfiles/homebrew/Brewfile
```

### 差分確認

```bash
# シンボリックリンクの状態確認
bash bin/install.sh --check
```
