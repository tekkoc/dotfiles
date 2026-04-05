新しい Claude Code リモートセッションを起動してください。

## セッション名

$ARGUMENTS

## 手順

1. 上記の `$ARGUMENTS` からセッション名を読み取ります。引数が空の場合は `"new-session"` をデフォルト名として使用します。

2. 以下のコマンドをバックグラウンドで実行してください（`run_in_background: true`）：

```bash
claude remote-control --name "<セッション名>"
```

3. 実行後、以下を報告してください：
   - 起動したセッション名
   - `claude.ai/code` を開いてセッション一覧から接続できる旨
