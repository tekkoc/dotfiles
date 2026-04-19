# CHANGES.md — 変更ログ

## 2026-04-19

- `/pull` スラッシュコマンドを追加（`origin/main` を `pull --rebase` で取り込み、変更サマリー表示・コンフリクト時は手動操作手順を強調表示）
- `t` エイリアス（`tmux`）を関数化（引数あり→セッション attach/作成、引数なし→セッション一覧）
- tmux のターミナル起動時自動アタッチ機能を削除
- setup.md: `t` を関数表に移動、`tmux-new` 関数エントリを削除、tmux「自動アタッチ」セクションを削除
- setup.md: `docker-completion` を Brewfile テーブルに追記 [Mac mini]

- `mm` 関数を追加（Mac mini への SSH 接続、LAN 優先・圏外時は Tailscale 自動切替）[macOS]
- setup.md に SSH config・macOS システム設定セクションを追加
  - `~/.ssh/config` の `home` / `home-ts` 設定を記載
  - Karabiner-Elements のキーマップ（CapsLock→IME off、Right Command→IME on）を記載
  - Raycast 起動ショートカット（Ctrl+Space）を記載
  - macOS IME 設定（Ctrl+Space 解除、Google 入力ソース追加）を記載
  - Vivaldi の設定（デフォルトブラウザ、タブ左配置）を記載
  - Mac mini ロック画面無効化を記載 [Mac mini]

---

- setup.md を新規作成（初回 export）
- 全実態ファイルを読み込み、環境設定リファレンスとして記録
  - Ghostty / tmux / zsh / Neovim / Git / Claude Code の設定を網羅
  - neo-tree.nvim（ファイラ）を記載（telescope-file-browser から移行済み）
  - Telescope の隠しファイル表示・.git/objects 除外設定を記載
