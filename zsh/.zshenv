# .zshenv — 全シェル（インタラクティブ・非インタラクティブ）で読まれる
# ここには最小限の環境変数のみ書く。重い処理は .zshrc へ。

# zsh の設定ファイルを ~/.zsh/ にまとめる
export ZDOTDIR="$HOME"

# デフォルトのテキストエディタ
export EDITOR="vim"
export VISUAL="$EDITOR"

# 言語・ロケール（日本語端末でも英語メッセージを使う場合は en_US.UTF-8）
export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"

# Homebrew PATH（非ログインシェル・スクリプトでも有効にするためここで設定）
# .zprofile でも同様に設定しているが、Claude Code 等の非ログインシェルのために必要
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# XDG Base Directory（ツールの設定を ~/.config/ に集約）
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
