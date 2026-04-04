# CLAUDE.md — dotfiles (macOS)

このファイルは Claude Code がこのリポジトリを扱うときに参照する指示書です。

---

## このリポジトリの目的

macOS 上での個人開発環境を Git で管理する dotfiles です。
主な構成要素は **Ghostty + zsh + tmux + Claude Code CLI** です。

---

## ファイル構成

```
dotfiles/
├── bin/install.sh          # セットアップスクリプト（冪等）
├── claude/
│   └── statusline.py       # Claude Code カスタムステータスライン
├── ghostty/config          # Ghostty ターミナル設定
├── git/.gitconfig          # Git 設定
├── homebrew/Brewfile       # Homebrew パッケージ一覧
├── tmux/.tmux.conf         # tmux 設定
└── zsh/
    ├── .zshenv             # 全シェル共通の環境変数（最小限）
    ├── .zprofile           # ログインシェル用（Homebrew PATH 等）
    ├── .zshrc              # インタラクティブシェル設定
    └── .zsh/
        ├── aliases.zsh         # エイリアス
        ├── functions.zsh       # シェル関数
        ├── ohmyposh-theme.json # Oh My Posh カスタムテーマ
        ├── reference.md        # キーバインド・エイリアスのリファレンス（? で表示）
        └── completions/        # 補完スクリプト置き場
```

シンボリックリンク先（`install.sh` が作成）：

| リポジトリ内のパス             | リンク先                          |
|------------------------------|----------------------------------|
| `zsh/.zshenv`                | `~/.zshenv`                      |
| `zsh/.zprofile`              | `~/.zprofile`                    |
| `zsh/.zshrc`                 | `~/.zshrc`                       |
| `zsh/.zsh/`                  | `~/.zsh/`                        |
| `tmux/.tmux.conf`            | `~/.tmux.conf`                   |
| `ghostty/config`             | `~/.config/ghostty/config`       |
| `git/.gitconfig`             | `~/.gitconfig`                   |
| `claude/statusline.py`       | `~/.claude/statusline.py`        |

`install.sh` はシンボリックリンク作成に加え、`~/.claude/settings.json` に statusLine と通知 hooks を自動設定する（既存設定とマージ）。

---

## 作業ルール

### 変更前に必ず確認すること

- **設定変更は小さく・1ファイルずつ**行う。複数ファイルを一括で変えない
- zsh の設定を変更したら `source ~/.zshrc` で反映確認を促す
- tmux の設定を変更したら `tmux source ~/.tmux.conf` で反映確認を促す
- `install.sh` を変更したら `--check` オプションで副作用を確認してから実行する

### 禁止事項

- `~/.zsh/local.zsh` への言及・編集（`.gitignore` 対象のプライベートファイル）
- `git/.gitconfig` への `user.name` / `user.email` の直接書き込み（`install.sh` が対話的に設定する）
- `Brewfile` への cask の追加（アプリ系は手動管理するため brew formula のみ提案する）

### 提案の作法

- 設定変更を提案する際は**変更理由を1行で添える**
- 複数の選択肢がある場合は比較を示してから選択を委ねる
- 既存の設定との**競合・重複**がないか確認してから追記する

---

## よくある作業パターン

### 新しい CLI ツールを導入する

1. `homebrew/Brewfile` に `brew "ツール名"` を追加
2. `zsh/.zsh/aliases.zsh` に必要なエイリアスを追加
3. `zsh/.zshrc` に初期化コード（`eval "$(tool init zsh)"` 等）を追加
4. 必要なら `zsh/.zsh/completions/` に補完スクリプトを追加

### tmux の設定を変更する

`tmux/.tmux.conf` を編集する。変更後のコマンドは：

```bash
tmux source ~/.tmux.conf
```

キーバインドを追加するときは既存の prefix との衝突を確認すること（現在の prefix は `Ctrl-z`）。

### Ghostty の設定を変更する

`ghostty/config` を編集する。変更は Ghostty の再起動か `Cmd+,` で設定を開いて確認。

日本語まわりで注意が必要な既知設定：
- `font-feature = -liga -dlig -calt` — CJK 入力時のリガチャ誤動作を回避するため無効化済み。削除しない
- `macos-option-as-alt = left` — zsh の Alt キーバインドを有効にするため設定済み。削除しない

### Brewfile を最新に更新する

現在インストール済みのパッケージを Brewfile に反映：

```bash
brew bundle dump --force --file=~/dotfiles/homebrew/Brewfile
```

その後、不要なものを手動で削除してからコミットする。

---

## コミットメッセージの規約

形式: `<scope>: <変更内容>`

| scope      | 対象                          |
|------------|------------------------------|
| `zsh`      | zsh 関連ファイル全般           |
| `tmux`     | `.tmux.conf`                 |
| `ghostty`  | Ghostty config               |
| `git`      | `.gitconfig`                 |
| `brew`     | `Brewfile`                   |
| `install`  | `bin/install.sh`             |
| `docs`     | `README.md` / `CLAUDE.md`    |

例：
```
zsh: fzf の補完設定を .zshrc に追加
tmux: ペイン移動キーバインドを hjkl に変更
ghostty: フォントサイズを 14 → 15 に変更
```

---

## 環境情報

- **OS**: macOS（Apple Silicon / Intel 両対応）
- **シェル**: zsh（Homebrew 版）
- **ターミナル**: Ghostty
- **マルチプレクサ**: tmux（prefix: `Ctrl-z`）
- **プロンプト**: Oh My Posh（カスタムテーマ: `zsh/.zsh/ohmyposh-theme.json`）
- **パッケージ管理**: Homebrew
- **バージョン管理**: mise（Node.js / Python 等）

---

## トラブルシューティングの定石

| 症状 | 確認箇所 |
|------|---------|
| zsh の設定が反映されない | `source ~/.zshrc` / シェルを再起動 |
| Homebrew コマンドが見つからない | `.zprofile` の `brew shellenv` が通っているか確認 |
| tmux 内で色がおかしい | `.tmux.conf` の `terminal-overrides` と `default-terminal` を確認 |
| Ghostty で日本語入力がおかしい | `font-feature` の設定と Ghostty のバージョンを確認 |
| `install.sh` でリンクが失敗する | `bash bin/install.sh --check` で状態確認 |
