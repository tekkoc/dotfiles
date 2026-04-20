# Discord リモート開発・通知 運用ガイド

## 構成概要

```
iPhone (Discord)
    ↕ スラッシュコマンド
Discord Bot (Mac mini 常時起動)
    ↕ claude --resume
Claude Code (Mac mini)
    ↓ 完了時 Webhook
Discord 通知チャンネル
```

---

## Discord 完了通知 ✅

Claude Code がタスクを完了したとき、Discord チャンネルへ Webhook 通知が届く。

- **仕組み**: `~/.claude/settings.json` の Stop hook で `~/.claude/hooks/notify-discord.sh` を実行
- **環境変数**: `DISCORD_WEBHOOK_URL` を `~/.zsh/local.zsh` に設定（gitignore 対象）
- **Macbook への影響なし**: `DISCORD_WEBHOOK_URL` が未設定の場合はスクリプトが即 exit 0

---

## Discord Bot によるリモート操作 [Mac mini]

> **TODO**: Bot への指示送信が未動作。調査・修正が必要。

### セットアップ済みの内容

- `~/dev/discord-claude-code-bot` にインストール済み
- launchd (`com.discord-claude-bot`) で常時起動
- `.env` に `DISCORD_TOKEN` / `GUILD_ID` / `DEFAULT_CWD` を設定済み

### 想定する操作フロー（確認後に更新）

| 操作 | コマンド |
|---|---|
| セッション開始 | `/new` |
| 作業ディレクトリ変更 | `/cd ~/dev/project` |
| Claude への指示 | 通常のメッセージを送信 |
| モデル切り替え | `/model opus` |
| 実行停止 | `/stop` |

### ターミナルとのセッション共有

```bash
# Discord で開始したセッションをターミナルで引き継ぐ
cat ~/dev/discord-claude-code-bot/thread-map.json | jq '."<thread-id>".sessionId'
claude --resume <session-id>
```

---

## トラブルシューティング

| 症状 | 確認箇所 |
|---|---|
| Bot がオフライン | `launchctl list \| grep discord-claude-bot` で PID 確認 |
| Bot ログ確認 | `cat /tmp/discord-claude-bot.log` / `discord-claude-bot.error.log` |
| 通知が届かない | `echo $DISCORD_WEBHOOK_URL` で環境変数の確認 |
| Bot を手動再起動 | `launchctl kickstart -k gui/$(id -u)/com.discord-claude-bot` |

---

## 関連ファイル

- セットアップ手順: [`docs/discord-dev-setup.md`](discord-dev-setup.md)
- 通知スクリプト: `claude/hooks/notify-discord.sh`
- Bot: `~/dev/discord-claude-code-bot/` (gitignore 対象外リポジトリ)
