# .zprofile — ログインシェルのみ読まれる（GUI ターミナルの初回起動など）
# PATH など一度だけ設定すべきものをここに書く。

# =============================================================================
# Homebrew
# =============================================================================
# Apple Silicon Mac は /opt/homebrew、Intel Mac は /usr/local
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# =============================================================================
# PATH の追加
# =============================================================================
# ユーザーローカルの bin を優先
export PATH="$HOME/.local/bin:$PATH"

# mise（旧 rtx）— Node.js / Python / Ruby などのバージョン管理
# 使わない場合はコメントアウト
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh --shims)"
fi
