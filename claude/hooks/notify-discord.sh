#!/bin/bash
# DISCORD_WEBHOOK_URL が未設定ならスキップ（client では何もしない）
[[ -z "$DISCORD_WEBHOOK_URL" ]] && exit 0

curl -s -X POST "$DISCORD_WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "{\"content\": \"✅ Claude Code 完了: $(pwd)\"}"
