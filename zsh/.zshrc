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
# キーバインド（Emacs スタイル）
# =============================================================================
bindkey -e

# Ctrl+R で履歴インクリメンタル検索
bindkey '^R' history-incremental-search-backward
# Ctrl+P / Ctrl+N で前後の履歴
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history
# Home / End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
# Delete キー
bindkey '^[[3~' delete-char

# Ctrl+z を tmux prefix として使うため、サスペンドを Ctrl+] に移動
# （tmux 内では Ctrl+z が prefix として機能するため、この設定は tmux 外のみ有効）
stty susp '^]'

# =============================================================================
# Ghostty シェル統合
# =============================================================================
# Ghostty が自動で注入するが、明示的に読み込んでおく
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# =============================================================================
# プロンプト — Oh My Posh
# =============================================================================
if command -v oh-my-posh &>/dev/null; then
  eval "$(oh-my-posh init zsh --config ~/.zsh/ohmyposh-theme.json)"
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

# direnv（ディレクトリ別の環境変数を .envrc で自動ロード）
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
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

# =============================================================================
# zsh プラグイン（for ループの後、ローカル設定の後に読み込む）
# =============================================================================
# zsh-autosuggestions: 入力履歴からゴーストテキストで補完候補を表示
# HOMEBREW_PREFIX は .zprofile の brew shellenv で設定される（Apple Silicon / Intel 両対応）
[[ -f "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting: 入力中のコマンドをリアルタイムで色分け（必ず最後に）
[[ -f "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# =============================================================================
# tmux 自動アタッチ（セッション "main" に接続、なければ作成）
# ターミナル起動時に自動実行。tmux 内ではスキップ
# =============================================================================
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
  tmux new-session -A -s main
fi
