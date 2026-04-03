# .zshrc — インタラクティブシェルのみ読まれる

# =============================================================================
# 基本オプション
# =============================================================================
setopt AUTO_CD              # ディレクトリ名だけで cd
setopt AUTO_PUSHD           # cd のたびにスタックへ積む
setopt PUSHD_IGNORE_DUPS    # スタックの重複を除去
setopt CORRECT              # コマンドのタイポを提案
setopt INTERACTIVE_COMMENTS # インタラクティブでも # コメントを有効に
setopt NO_BEEP              # ビープ音を消す

# =============================================================================
# 履歴
# =============================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS     # 直前と同じコマンドは記録しない
setopt HIST_IGNORE_ALL_DUPS # 全履歴から重複を除去
setopt HIST_IGNORE_SPACE    # スペースで始まるコマンドは記録しない
setopt HIST_REDUCE_BLANKS   # 余分な空白を削除して記録
setopt SHARE_HISTORY        # 複数セッション間で履歴を共有
setopt EXTENDED_HISTORY     # タイムスタンプを記録

# =============================================================================
# 補完
# =============================================================================
autoload -Uz compinit
# 毎回再ビルドせず、1日1回だけ再生成（起動を速くする）
if [[ -n "$HOME/.zcompdump"(#qNmh-20) ]]; then
  compinit -C
else
  compinit
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# ユーザー補完ディレクトリ
fpath=("$HOME/.zsh/completions" $fpath)

# =============================================================================
# キーバインド（vi ライク）
# =============================================================================
bindkey -v
export KEYTIMEOUT=1         # vi モード切替を素早く

# Ctrl+R で履歴検索（vi モードでも有効）
bindkey '^R' history-incremental-search-backward
# Ctrl+P / Ctrl+N で前後の履歴
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
# Delete キー
bindkey '^[[3~' delete-char

# =============================================================================
# Ghostty シェル統合
# =============================================================================
# Ghostty が自動で注入するが、明示的に読み込んでおく
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# =============================================================================
# プロンプト — Starship
# =============================================================================
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# =============================================================================
# ツール初期化
# =============================================================================
# mise（Node.js / Python 等のバージョン管理）
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# zoxide（cd の強化版）
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# fzf
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi

# =============================================================================
# 追加設定ファイルを読み込む
# =============================================================================
for f in "$HOME/.zsh"/*.zsh; do
  [[ -r "$f" ]] && source "$f"
done

# =============================================================================
# ローカル設定（Git 管理外・秘密情報・マシン固有の設定）
# =============================================================================
[[ -f "$HOME/.zsh/local.zsh" ]] && source "$HOME/.zsh/local.zsh"
