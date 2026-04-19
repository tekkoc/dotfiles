dotfiles の実態ファイルを読み込んで setup.md を更新し、CHANGES.md に変更ログを追記します。

## 変更の概要（省略可）

$ARGUMENTS

---

## 手順

### 1. 実態ファイルの読み込み

以下のファイルをすべて読み込んで、現在の環境設定を把握する：

- `homebrew/Brewfile`
- `npm/packages.txt`
- `nvim/init.lua`
- `nvim/lua/plugins.lua`
- `nvim/lua/core.lua`
- `nvim/lua/keymap.lua`
- `nvim/lua/commands.lua`
- `zsh/.zshenv`
- `zsh/.zprofile`
- `zsh/.zshrc`
- `zsh/.zsh/aliases.zsh`
- `zsh/.zsh/functions.zsh`
- `tmux/.tmux.conf`
- `ghostty/config`
- `git/.gitconfig`
- `amethyst/com.amethyst.Amethyst.plist`
- `karabiner/karabiner.json`
- `claude/statusline.py`

### 2. setup.md との差分確認

`setup.md` を読み込み、上記ファイルの内容と比較する。

差分（setup.md に未反映・記述が古いもの）を列挙してから次のステップへ進む。
`$ARGUMENTS` が指定されている場合はその変更内容も考慮する。

### 3. setup.md の更新

差分に基づいて setup.md を更新する。

- 既存の記述と矛盾・重複がないか確認してから書き換える
- 新しいツール・設定は適切なセクションに追記（セクションがなければ新設）
- 削除・無効化した設定は除去する
- 「この環境はこう動作する」という事実ベースで記述する（手順書ではなく状態の記録）
- `最終更新` の日付を今日の日付に更新する

**export してはいけない情報（setup.md に含めない）：**

- 絶対パス（例: `/Users/tekkoc/...`）→ `~` や相対パスで表現するか省略する
- ユーザー名・ホスト名・マシン固有の識別子
- API キー・トークン・パスワード・秘密鍵などの秘匿情報
- `~/.zsh/local.zsh` など `.gitignore` 対象のプライベートファイルの内容
- IP アドレス・内部ネットワーク情報
- 環境固有の値（マシン固有のフォント名、特定ディスプレイの解像度など）で他環境では無意味なもの

### 4. CHANGES.md への追記

以下のコマンドで現在日付を取得する：

```bash
date '+%Y-%m-%d'
```

`CHANGES.md` の先頭（既存エントリの上）に以下の形式で追記する：

```
## YYYY-MM-DD

- <変更内容を箇条書きで>
```

同じ日付のエントリが既に存在する場合は、そのエントリに箇条書きを追記する。

### 5. 完了報告

- setup.md の変更箇所を要約して報告する
- CHANGES.md に追記した内容を表示する
