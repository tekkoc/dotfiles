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
  # 非ログインシェルでは brew が PATH にないため、既定パスを先に確認して PATH に追加
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if command -v brew &>/dev/null; then
    info "Homebrew はインストール済みです"
    return
  fi

  info "Homebrew をインストールします..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # インストール後に PATH を反映
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
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
  brew bundle install --no-upgrade --verbose --file="$brewfile"
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

  # Claude Code
  link "$DOTFILES_DIR/claude/statusline.py" "$HOME/.claude/statusline.py"

  # Neovim
  link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

  # lazygit
  link "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"
}

# -----------------------------------------------------------------------------
# Claude Code の設定（settings.json）
# statusLine と通知 hooks を設定する。既存設定はマージして保持する。
# -----------------------------------------------------------------------------
setup_claude_settings() {
  local settings_file="$HOME/.claude/settings.json"
  local script="$DOTFILES_DIR/claude/statusline.py"

  mkdir -p "$HOME/.claude"

  if [[ "$CHECK_ONLY" == true ]]; then
    if [[ -f "$settings_file" ]]; then
      if python3 -c "
import json
with open('$settings_file') as f: c = json.load(f)
assert 'statusLine' in c, 'statusLine missing'
assert 'hooks' in c, 'hooks missing'
" 2>/dev/null; then
        success "$settings_file (statusLine + hooks 設定済み)"
      else
        warning "$settings_file (statusLine または hooks が未設定)"
      fi
    else
      warning "$settings_file (ファイルなし)"
    fi
    return
  fi

  info "Claude Code settings.json を設定します..."

  # Python で JSON をマージ（既存設定を保持しつつ必要なキーを追加）
  python3 - "$settings_file" <<'PYEOF'
import json
import os
import sys

settings_path = sys.argv[1]

# 既存設定を読み込む（なければ空）
if os.path.exists(settings_path):
    with open(settings_path) as f:
        try:
            config = json.load(f)
        except Exception:
            config = {}
else:
    config = {}

changed = False

# env.PATH を追加（未設定の場合のみ）
if "env" not in config:
    config["env"] = {}
if "PATH" not in config["env"]:
    config["env"]["PATH"] = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    changed = True

# statusLine を追加（未設定の場合のみ）
if "statusLine" not in config:
    config["statusLine"] = {
        "type": "command",
        "command": "python3 ~/.claude/statusline.py",
        "padding": 1
    }
    changed = True

# hooks を追加（未設定の場合のみ）
if "hooks" not in config:
    config["hooks"] = {}

hooks = config["hooks"]

# PostToolUse hook（設定ファイル変更時の setup.md 更新リマインダー）
if "PostToolUse" not in hooks:
    hooks["PostToolUse"] = [
        {
            "matcher": "Edit|Write",
            "hooks": [
                {
                    "type": "command",
                    "command": "python3 -c \"\nimport json, sys, re\nd = json.load(sys.stdin)\nf = d.get('tool_input', {}).get('file_path', '')\npatterns = ['zshrc', 'zprofile', 'zshenv', r'aliases\\\\.zsh', r'functions\\\\.zsh', r'tmux\\\\.conf', 'ghostty/config', 'nvim/', 'Brewfile', r'packages\\\\.txt', r'\\\\.gitconfig']\nif f and any(re.search(p, f) for p in patterns):\n    print('[setup.md 更新チェック] ' + f + ' が変更されました。setup.md への反映が必要か確認し、必要なら /setup-sync を実行してください。')\n\""
                }
            ]
        }
    ]
    changed = True

# Stop hook（タスク完了通知）
if "Stop" not in hooks:
    hooks["Stop"] = [
        {
            "hooks": [
                {
                    "type": "command",
                    "command": "osascript -e 'display notification \"タスクが完了しました\" with title \"Claude Code\" sound name \"Glass\"'"
                }
            ]
        }
    ]
    changed = True

# Notification hook（入力待ち通知）
if "Notification" not in hooks:
    hooks["Notification"] = [
        {
            "hooks": [
                {
                    "type": "command",
                    "command": "osascript -e 'display notification \"入力を待っています\" with title \"Claude Code\" sound name \"Ping\"'"
                }
            ]
        }
    ]
    changed = True

if changed:
    os.makedirs(os.path.dirname(settings_path), exist_ok=True)
    with open(settings_path, "w") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)
    print(f"  [OK]    settings.json を更新しました: {settings_path}")
else:
    print(f"  [INFO]  settings.json は設定済みです（変更なし）")
PYEOF
}

# -----------------------------------------------------------------------------
# mise で Node.js をセットアップ（npm パッケージのインストールに必要）
# -----------------------------------------------------------------------------
setup_mise_node() {
  if ! command -v mise &>/dev/null; then
    warning "mise が見つかりません。Node.js のセットアップをスキップします"
    return
  fi

  if mise ls node 2>/dev/null | grep -q "(current)"; then
    info "mise Node.js はセットアップ済みです ($(mise exec node -- node --version 2>/dev/null))"
    return
  fi

  info "mise で Node.js (LTS) をセットアップします..."
  mise use -g node@lts
  success "Node.js のセットアップ完了"
}

# -----------------------------------------------------------------------------
# npm グローバルパッケージのインストール
# -----------------------------------------------------------------------------
install_npm_packages() {
  local packages_file="$DOTFILES_DIR/npm/packages.txt"
  if [[ ! -f "$packages_file" ]]; then
    warning "npm/packages.txt が見つかりません: $packages_file"
    return
  fi

  if ! command -v mise &>/dev/null; then
    warning "mise が見つかりません。npm パッケージのインストールをスキップします"
    return
  fi

  if ! mise exec node -- node --version &>/dev/null 2>&1; then
    warning "mise で Node.js が見つかりません。npm パッケージのインストールをスキップします"
    return
  fi

  # コメント・空行を除いたパッケージ名一覧（インラインコメントも除去）
  local packages
  packages=$(grep -v '^\s*#' "$packages_file" | grep -v '^\s*$' | awk '{print $1}')

  if [[ -z "$packages" ]]; then
    info "npm/packages.txt にパッケージが記載されていません"
    return
  fi

  info "npm グローバルパッケージをインストールします..."
  while IFS= read -r pkg; do
    if mise exec node -- npm list -g --depth=0 "$pkg" &>/dev/null 2>&1; then
      info "skip (already installed): $pkg"
    else
      mise exec node -- npm install -g "$pkg"
      success "npm install -g $pkg"
    fi
  done <<< "$packages"
}

# -----------------------------------------------------------------------------
# TPM (Tmux Plugin Manager) のインストール
# -----------------------------------------------------------------------------
setup_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if [[ "$CHECK_ONLY" == true ]]; then
    if [[ -d "$tpm_dir" ]]; then
      success "$tpm_dir (TPM インストール済み)"
    else
      warning "$tpm_dir (TPM 未インストール)"
    fi
    return
  fi

  if [[ -d "$tpm_dir" ]]; then
    info "TPM はインストール済みです: $tpm_dir"
    return
  fi

  if ! command -v git &>/dev/null; then
    warning "git が見つかりません。TPM のインストールをスキップします"
    return
  fi

  info "TPM (Tmux Plugin Manager) をインストールします..."
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  success "TPM をインストールしました: $tpm_dir"
  info "tmux 内で prefix + I を押してプラグインをインストールしてください"
}

# -----------------------------------------------------------------------------
# Ghostty terminfo のインストール（xterm-ghostty が未登録の場合）
# -----------------------------------------------------------------------------
setup_ghostty_terminfo() {
  local terminfo_src="$DOTFILES_DIR/ghostty/xterm-ghostty.terminfo"

  if [[ "$CHECK_ONLY" == true ]]; then
    if infocmp xterm-ghostty &>/dev/null; then
      success "xterm-ghostty terminfo: インストール済み"
    else
      warning "xterm-ghostty terminfo: 未インストール"
    fi
    return
  fi

  if infocmp xterm-ghostty &>/dev/null; then
    info "xterm-ghostty terminfo はインストール済みです"
    return
  fi

  if [[ ! -f "$terminfo_src" ]]; then
    warning "terminfo ファイルが見つかりません: $terminfo_src"
    return
  fi

  info "xterm-ghostty terminfo をインストールします..."
  tic -x "$terminfo_src"
  success "xterm-ghostty terminfo をインストールしました"
}

# -----------------------------------------------------------------------------
# Ghostty テーマのインストール
# -----------------------------------------------------------------------------
setup_ghostty_theme() {
  local themes_dir="$HOME/.config/ghostty/themes"
  local theme_file="$themes_dir/catppuccin-mocha"
  local theme_url="https://raw.githubusercontent.com/catppuccin/ghostty/main/themes/catppuccin-mocha.conf"

  if [[ -f "$theme_file" ]]; then
    info "Ghostty テーマはインストール済みです: $theme_file"
    return
  fi

  if ! command -v curl &>/dev/null; then
    warning "curl が見つかりません。Ghostty テーマをスキップします"
    return
  fi

  info "Ghostty テーマ (catppuccin-mocha) をダウンロードします..."
  mkdir -p "$themes_dir"
  if curl -fsSL "$theme_url" -o "$theme_file"; then
    success "Ghostty テーマをインストールしました: $theme_file"
  else
    warning "Ghostty テーマのダウンロードに失敗しました"
    rm -f "$theme_file"
  fi
}

# -----------------------------------------------------------------------------
# Karabiner-Elements の設定をコピー（シンボリックリンクは使わない）
# -----------------------------------------------------------------------------
setup_karabiner() {
  local src="$DOTFILES_DIR/karabiner/karabiner.json"
  local dst="$HOME/.config/karabiner/karabiner.json"

  if [[ ! -f "$src" ]]; then
    warning "karabiner/karabiner.json が見つかりません: $src"
    return
  fi

  if [[ "$CHECK_ONLY" == true ]]; then
    if [[ -f "$dst" ]]; then
      success "$dst (存在)"
    else
      warning "$dst (ファイルなし)"
    fi
    return
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  success "karabiner.json をコピーしました: $dst"
}

# -----------------------------------------------------------------------------
# macOS システム設定（defaults write）
# -----------------------------------------------------------------------------
setup_macos_defaults() {
  if [[ "$CHECK_ONLY" == true ]]; then
    local tap
    tap=$(defaults read com.apple.AppleMultitouchTrackpad Clicking 2>/dev/null || echo "0")
    local autohide
    autohide=$(defaults read com.apple.dock autohide 2>/dev/null || echo "0")
    [[ "$tap" == "1" ]] && success "トラックパッド: タップでクリック 有効" || warning "トラックパッド: タップでクリック 未設定"
    [[ "$autohide" == "1" ]] && success "Dock: 自動的に隠す 有効" || warning "Dock: 自動的に隠す 未設定"
    return
  fi

  info "macOS デフォルト設定を適用します..."

  # キーボード: キーリピートを有効にする（長押しで文字選択ポップアップを無効化）
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # トラックパッド: タップでクリックを有効にする
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Dock: 自動的に隠す
  defaults write com.apple.dock autohide -bool true
  # Dock: サイズ
  defaults write com.apple.dock tilesize -int 57
  # Dock: 最近使ったアプリを表示しない
  defaults write com.apple.dock show-recents -bool false

  # Finder: パスバーを表示
  defaults write com.apple.finder ShowPathbar -bool true

  # 設定を反映
  killall Dock 2>/dev/null || true

  success "macOS デフォルト設定を適用しました"
}

# -----------------------------------------------------------------------------
# Amethyst の設定をコピー（EncodedWindowManager は除外）
# -----------------------------------------------------------------------------
setup_amethyst() {
  local src="$DOTFILES_DIR/amethyst/com.amethyst.Amethyst.plist"
  local domain="com.amethyst.Amethyst"

  if [[ ! -f "$src" ]]; then
    warning "amethyst/com.amethyst.Amethyst.plist が見つかりません: $src"
    return
  fi

  if [[ "$CHECK_ONLY" == true ]]; then
    if defaults read "$domain" mod1 &>/dev/null; then
      success "Amethyst: 設定インポート済み"
    else
      warning "Amethyst: 設定未インポート"
    fi
    return
  fi

  defaults import "$domain" "$src"
  success "Amethyst 設定をインポートしました"
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
# Neovim プラグインの同期（Lazy sync）
# -----------------------------------------------------------------------------
setup_nvim_plugins() {
  if [[ "$CHECK_ONLY" == true ]]; then
    return
  fi

  if ! command -v nvim &>/dev/null; then
    warning "nvim が見つかりません。プラグインのセットアップをスキップします"
    return
  fi

  info "Neovim プラグインを同期します（Lazy sync）..."
  nvim --headless "+Lazy! sync" +qa 2>&1 | grep -v "^$" || true
  success "Neovim プラグイン同期完了"
}

# -----------------------------------------------------------------------------
# デフォルトシェルを zsh に設定
# -----------------------------------------------------------------------------
setup_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"

  # $SHELL のベース名が zsh なら（パスが異なっても）スキップ
  if [[ "$(basename "$SHELL")" == "zsh" ]]; then
    info "デフォルトシェルはすでに zsh です ($SHELL)"
    return
  fi

  # /etc/shells に zsh が含まれていなければ追加
  if ! grep -q "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi

  # chsh は対話的なパスワード入力を必要とするため、失敗してもスキップ
  if chsh -s "$zsh_path" 2>/dev/null; then
    success "デフォルトシェルを zsh ($zsh_path) に変更しました"
  else
    warning "デフォルトシェルの変更をスキップしました（手動で実行: chsh -s $zsh_path）"
  fi
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
    echo ""
    echo "--- Ghostty terminfo の確認 ---"
    setup_ghostty_terminfo
    echo ""
    echo "--- TPM の確認 ---"
    setup_tpm
    echo ""
    echo "--- Karabiner 設定の確認 ---"
    setup_karabiner
    echo ""
    echo "--- macOS デフォルト設定の確認 ---"
    setup_macos_defaults
    echo ""
    echo "--- Amethyst 設定の確認 ---"
    setup_amethyst
    echo ""
    echo "--- Claude Code 設定の確認 ---"
    setup_claude_settings
    exit 0
  fi

  if [[ "$LINK_ONLY" == false ]]; then
    install_homebrew
    install_brew_packages
    setup_mise_node
    install_npm_packages
  fi

  create_links
  setup_ghostty_terminfo
  setup_nvim_plugins
  setup_tpm
  setup_ghostty_theme
  setup_karabiner
  setup_macos_defaults
  setup_amethyst
  setup_git_identity
  setup_default_shell
  setup_claude_settings

  echo ""
  success "セットアップ完了！新しいターミナルを開いてください。"
  echo ""
}

main
