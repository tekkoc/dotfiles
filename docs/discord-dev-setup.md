# Discord連携・通知セットアップ

## 概要

Mac miniで常時稼働するDiscord Botを通じて、外出中のiPhoneからClaude Codeに指示を出し、
作業完了時に通知を受け取る環境を構築する。

---

## Discord Bot

### 使用リポジトリ

**fredchu/discord-claude-code-bot**
https://github.com/fredchu/discord-claude-code-bot

### セットアップ

```bash
git clone https://github.com/fredchu/discord-claude-code-bot.git
cd discord-claude-code-bot
cp .env.example .env
npm install
npm start
```

### 環境変数 (.env)

```env
DISCORD_TOKEN=your_bot_token_here      # 必須: Discord Developer PortalのBotトークン
GUILD_ID=your_guild_id_here            # 推奨: スラッシュコマンドの即時反映
DEFAULT_CWD=/path/to/your/project      # 任意: デフォルト作業ディレクトリ
CLAUDE_BIN=claude                      # 任意: Claude CodeのPATH
```

### Discord Developer Portal設定

1. https://discord.com/developers/applications で新規アプリ作成
2. Bot → **Message Content Intent** を有効化
3. OAuth2 → URL Generator → スコープ: `bot` + `applications.commands`
4. Bot権限: Send Messages / Read Message History / Attach Files / Use Slash Commands
5. 生成URLでBotをサーバーに招待

### 主なスラッシュコマンド

| コマンド | 説明 |
|---|---|
| `/new` | セッションをリセットして新規開始 |
| `/model <n>` | opus / sonnet / haikuを切替 |
| `/cd <path>` | 作業ディレクトリを変更 |
| `/stop` | 実行中のClaudeプロセスを停止 |
| `/sessions` | アクティブなセッション一覧 |

---

## ターミナル ↔ Discord の行き来

Discordで開始したセッションをターミナルで引き継ぐことができる。

```bash
# セッションIDを確認
cat thread-map.json | jq '."<thread-id>".sessionId'

# ターミナルで同じセッションに接続
claude --resume <session-id>
```

- ターミナルでの操作はDiscordには表示されないが、Claudeの記憶は共有される
- 「iPhoneで指示 → 帰宅後にターミナルで細かい作業」が可能

---

## 完了通知

### Claude Code hooks設定

作業完了時にDiscordへWebhookで通知する。

```json
// ~/.claude/settings.json
{
  "hooks": {
    "Stop": [{ "command": "~/.claude/hooks/notify-discord.sh" }]
  }
}
```

### 通知スクリプト

```bash
# ~/.claude/hooks/notify-discord.sh
#!/bin/bash
curl -X POST "$DISCORD_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"✅ Claude Code 完了: $(pwd)\"}"
```

### Discord Webhook URLの取得

1. Discordサーバーの通知用チャンネルを作成
2. チャンネル設定 → 連携サービス → ウェブフック → 新しいウェブフック
3. WebhookのURLをコピーして環境変数に設定

```bash
# ~/.zshrc or ~/.zshenv に追加
export DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
```

---

## 常時起動設定（Mac mini）

### launchdで自動起動

```xml
<!-- ~/Library/LaunchAgents/com.discord-claude-bot.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.discord-claude-bot</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/bin/node</string>
    <string>/path/to/discord-claude-code-bot/src/index.js</string>
  </array>
  <key>WorkingDirectory</key>
  <string>/path/to/discord-claude-code-bot</string>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/discord-claude-bot.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/discord-claude-bot.error.log</string>
</dict>
</plist>
```

```bash
# 登録・起動
launchctl load ~/Library/LaunchAgents/com.discord-claude-bot.plist
```

---

## 構築順序

1. Discord Developer PortalでBotを作成しトークンを取得
2. Discordサーバーを作成しBotを招待
3. Webhook用チャンネルを作成しURLを取得
4. Mac miniにリポジトリをcloneして`.env`を設定
5. `npm start`で動作確認
6. Claude Code hooksと通知スクリプトを設定
7. launchdで常時起動設定
