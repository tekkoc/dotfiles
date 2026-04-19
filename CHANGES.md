# CHANGES.md — 変更ログ

## 2026-04-19

- nvim-treesitter: v1.0 の API 変更に対応（`nvim-treesitter.configs` → `nvim-treesitter`、highlight はデフォルト有効化）

- `ssh()` ラッパー関数を追加: SSH 接続中に Ghostty 背景色をネイビー（`#0f1f35`）に変更、切断後は catppuccin-mocha の背景色（`#1e1e2e`）へ復元。`BatchMode=yes` はスキップ [macOS]
- tmux ステータスバーに SSH インジケーターを追加（`SSH` を赤字表示）
- `.zshrc`: SSH セッション内の tmux 起動時に `SSH_CONNECTION` をグローバル環境変数として設定
- `/pull` スラッシュコマンドを追加（`origin/main` を `pull --rebase` で取り込み、変更サマリー表示・コンフリクト時は手動操作手順を強調表示）
- `t` エイリアス（`tmux`）を関数化（引数あり→セッション attach/作成、引数なし→セッション一覧）
- tmux のターミナル起動時自動アタッチ機能を削除
- setup.md: `t` を関数表に移動、`tmux-new` 関数エントリを削除、tmux「自動アタッチ」セクションを削除
- setup.md: `docker-completion` を Brewfile テーブルに追記 [Mac mini]

- `ghostty/xterm-ghostty.terminfo` を追加・`install.sh` の `setup_ghostty_terminfo` で自動インストール（SSH 先で `xterm-ghostty` 未登録エラーを解消）
- setup.md: SSH config の IdentityFile を `id_rsa` に修正、公開鍵登録コマンド（`ssh-copy-id`）を追記
- setup.md: トラブルシューティングに `xterm-ghostty` terminfo エラーの対処を追記

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
