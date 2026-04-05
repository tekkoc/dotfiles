# トラブルシューティング記録

過去に発生した問題とその解決策をまとめたファイル。
同じ問題が再発したときにまず参照すること。

---

## Claude Code CLI: キー入力の異常（Ghostty + tmux + macOS）

**発生日:** 2026-04-05

### 症状

- Enter を押すと送信されるが、次のプロンプトに元の文字列が残り、再度 Enter で再送信される
- Shift+Enter / Ctrl+Enter が改行にならず送信になる
- WSL 環境・アプリ版（claude.ai/code）では正常動作

### 原因

**原因1:** `ghostty/config` の `keybind = shift+enter=text:\n` が Shift+Enter を通常の `\n` に変換してしまい、Claude Code CLI が Shift+Enter と Enter を区別できなくなっていた。

**原因2:** `~/.claude/keybindings.json` の `enter: chat:newline` が CLI 版で意図通りに機能せず、テキスト残存の副作用を引き起こしていた。

### 解決策

**1. `ghostty/config` から shift+enter のオーバーライドを削除**

```diff
- keybind = shift+enter=text:\n
```

Ghostty のデフォルト（kitty keyboard protocol: `\x1b[13;2u`）に戻すことで、CLI がキーを正しく識別できるようになる。

**2. `tmux/.tmux.conf` に extended-keys を追加**

```
set -g extended-keys on
```

tmux が kitty keyboard protocol シーケンスをアプリにパススルーする。

**3. `~/.claude/keybindings.json` を修正**

```json
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "shift+enter": "chat:newline",
        "ctrl+enter": "chat:newline"
      }
    }
  ]
}
```

- `enter: chat:newline` を削除 → Enter がデフォルト動作（送信）に戻りテキスト残存が解消
- Shift+Enter・Ctrl+Enter を明示的に改行に割り当て

### 反映手順

```bash
# Ghostty リロード
Cmd+Shift+,（または Ghostty 再起動）

# tmux リロード
tmux source ~/.tmux.conf

# Claude Code 再起動
```

### 備考

- WSL では Windows Terminal が Ghostty と異なるキーシーケンス処理をするため問題が発生しなかった
- `ghostty/config` に `shift+enter=text:\n` を**再追加しない**こと（この設定が根本原因）
