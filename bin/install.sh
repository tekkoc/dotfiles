#!/usr/bin/env bash
# =============================================================================
# dotfiles install script (macOS)
# =============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LINK_ONLY=false
CHECK_ONLY=false

# -----------------------------------------------------------------------------
# オプション解析
# -----------------------------------------------------------------------------
for arg in "$@"; do
  case $arg in
    --link-only) LINK_ONLY=true ;;
    --check)     CHECK_ONLY=true ;;
  esac
done

# -----------------------------------------------------------------------------
# ユーティリティ
# -----------------------------------------------------------------------------
info()    { echo "  [INFO]  $*"; }
success() { echo "  [OK]    $*"; }
warning() { echo "  [WARN]  $*"; }
error()   { echo "  [ERROR] $*" >&2; exit 1; }

# シンボリックリンクを作成（既存ファイルはバックアップ）
link() {
  local src="$1"
  local dst="$2"

  # 親ディレクトリを作成
  mkdir -p "$(dirname "$dst")"

  if [[ "$CHECK_ONLY" == true ]]; then
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
      success "$dst -> $src"
    elif [[ -e "$dst" ]]; then
      warning "$dst (リンクではなく実ファイルが存在)"
    else
      warning "$dst (リンクなし)"
    fi
    return
  fi

  # すでに正しいリンクが存在する場合はスキップ
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    info "skip (already linked): $dst"
    return
  fi

  # 既存ファイル・リンクをバックアップ
  if [[ -e "$dst" || -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    warning "backup: $dst -> $backup"
    mv "$dst" "$backup"
  fi

  ln -sf "$src" "$dst"
  success "linked: $dst -> $src"
}

# -----------------------------------------------------------------------------
# macOS チェック
# -----------------------------------------------------------------------------
check_macos() {
  if [[ "$(uname)" != "Darwin" ]]; then
    error "このスクリプトは macOS 専用です"
  fi
}

# -----------------------------------------------------------------------------
# Homebrew のインストール
# -----------------------------------------------------------------------------
install_homebrew() {
  if command -v brew &>/dev/null; then
    info "Homebrew はインストール済みです"
    return
  fi
  info "Homebrew をインストールします..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon の場合 PATH を即時反映
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew のインストール完了"
}

# -----------------------------------------------------------------------------
# Brewfile からパッケージをインストール
# -----------------------------------------------------------------------------
install_brew_packages() {
  local brewfile="$DOTFILES_DIR/homebrew/Brewfile"
  if [[ ! -f "$brewfile" ]]; then
    warning "Brewfile が見つかりません: $brewfile"
    return
  fi
  info "Brewfile からパッケージをインストールします..."
  brew bundle install --file="$brewfile"
  success "Brewfile インストール完了"
}

# -----------------------------------------------------------------------------
# シンボリックリンクの作成
# -----------------------------------------------------------------------------
create_links() {
  info "シンボリックリンクを作成します..."

  # zsh
  link "$DOTFILES_DIR/zsh/.zshenv"   "$HOME/.zshenv"
  link "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
  link "$DOTFILES_DIR/zsh/.zshrc"    "$HOME/.zshrc"
  link "$DOTFILES_DIR/zsh/.zsh"      "$HOME/.zsh"

  # tmux
  link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

  # Ghostty
  link "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

  # Git
  link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
}

# -----------------------------------------------------------------------------
# Git のユーザー情報を設定（初回のみ）
# -----------------------------------------------------------------------------
setup_git_identity() {
  local local_gitconfig="$HOME/.gitconfig.local"

  # すでに設定済みならスキップ
  if [[ -f "$local_gitconfig" ]] && \
     grep -q "name\s*=" "$local_gitconfig" && \
     grep -q "email\s*=" "$local_gitconfig"; then
    info "Git ユーザー情報は設定済みです ($local_gitconfig)"
    return
  fi

  echo ""
  echo "Git のユーザー情報を設定します（~/.gitconfig.local に保存）："
  read -rp "  name  : " git_name
  read -rp "  email : " git_email

  cat > "$local_gitconfig" <<EOF
[user]
  name  = $git_name
  email = $git_email
EOF
  success "Git ユーザー情報を $local_gitconfig に保存しました"
}

# -----------------------------------------------------------------------------
# デフォルトシェルを zsh に設定
# -----------------------------------------------------------------------------
setup_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"

  if [[ "$SHELL" == "$zsh_path" ]]; then
    info "デフォルトシェルはすでに zsh です"
    return
  fi

  # /etc/shells に zsh が含まれていなければ追加
  if ! grep -q "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  chsh -s "$zsh_path"
  success "デフォルトシェルを zsh ($zsh_path) に変更しました"
}

# -----------------------------------------------------------------------------
# メイン
# -----------------------------------------------------------------------------
main() {
  echo ""
  echo "========================================="
  echo "  dotfiles セットアップ (macOS)"
  echo "========================================="
  echo "  DOTFILES_DIR: $DOTFILES_DIR"
  echo ""

  check_macos

  if [[ "$CHECK_ONLY" == true ]]; then
    echo "--- リンク状態の確認 ---"
    create_links
    exit 0
  fi

  if [[ "$LINK_ONLY" == false ]]; then
    install_homebrew
    install_brew_packages
  fi

  create_links
  setup_git_identity
  setup_default_shell

  echo ""
  success "セットアップ完了！新しいターミナルを開いてください。"
  echo ""
}

main
