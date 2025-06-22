# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## リポジトリ概要

これは開発環境用の設定ファイルを含む個人のdotfilesリポジトリです。以下を中心とした構成になっています：

- **Neovim** のLua設定（モジュラー構造）
- **Fish shell** のカスタムエイリアスと統合
- **Tmux** のカスタムキーバインド
- **Git** の便利なエイリアス設定
- **Hammerspoon** のmacOS自動化（スクロール処理）
- **Karabiner Elements** のキーボードカスタマイズ

## セットアップとインストール

セットアップスクリプトを実行して設定をシンボリックリンクします：
```bash
./setup.sh
```

これにより、dotfilesから `~/.config/` やその他の標準ディレクトリの期待される場所にシンボリックリンクが作成されます。

## Neovim設定アーキテクチャ

Neovim設定は `nvim/` 内でモジュラーなLua構造に従っています：

- `init.lua` - すべてのモジュールを読み込むエントリーポイント
- `lua/core.lua` - 基本的なVim設定（scrolloff、行番号、クリップボードなど）
- `lua/keymap.lua` - カスタムキーマッピング（leader=`,`、`<C-l>`をエスケープなど）
- `lua/commands.lua` - カスタムコマンド
- `lua/plugins.lua` - Packerを使用したプラグイン管理

### 主要なNeovim機能

- **Packer.nvim** によるプラグイン管理とプラグインファイル変更時の自動リロード
- **LSP統合** とMasonによる言語サーバー管理
- **Telescope** によるファジーファインダー（ファイル、バッファ、grepなど）
- **Treesitter** によるシンタックスハイライト
- **自動フォーマット** - null-lsとPrettier/Styluaによる保存時フォーマット
- **プロジェクトローカル設定** - nvim-config-localによるサポート

### 重要なキーマッピング

- Leaderキー: `,`
- `<C-l>` がinsert/visual/commandモードで `<ESC>` にマップ
- `<Space>w` で保存
- `s` プレフィックスでウィンドウ/分割操作
- Telescopeバインド: `<leader>uf` (ファイル)、`<leader>ug` (grep)、`<leader>ub` (バッファ)

## シェル設定

- **Fish shell** がデフォルトシェル（`/opt/homebrew/bin/fish`）
- Gitエイリアス: `g` は `git`、`gcd` はghqリポジトリへのナビゲーション
- **Starship** プロンプト統合
- 環境変数用に `~/.fishenv` をソース

## Tmux設定

- プレフィックスキー: `<C-z>`
- Viモードキー有効
- `hjkl` によるカスタムペインナビゲーション
- マウスサポート有効
- 日付/時刻付きカスタムステータスバー

## Git設定

gitconfigで定義された便利なエイリアス:
- `co` = checkout
- `ci` = commit  
- `df` = diff
- `st` = status
- `br` = branch

## 開発ワークフロー

Neovim設定を変更する場合：
1. `lua/plugins.lua` でプラグイン設定を編集
2. ファイルが自動リロードされ、`:PackerCompile`、`:PackerInstall`、`:PackerClean` が実行される
3. `<Space>..` でinit.luaを素早く編集
4. `<Space>.r` で設定をリロード

## ファイル構造

```
nvim/
├── init.lua           # メインエントリーポイント
├── lua/
│   ├── core.lua      # 基本Vim設定
│   ├── keymap.lua    # キーマッピング
│   ├── commands.lua  # カスタムコマンド
│   └── plugins.lua   # プラグイン設定
└── plugin/
    └── packer_compiled.lua  # 自動生成
```