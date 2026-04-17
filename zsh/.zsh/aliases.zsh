# aliases.zsh — エイリアス定義

# =============================================================================
# ディレクトリ操作
# =============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'          # 直前のディレクトリへ戻る

# =============================================================================
# ls / eza
# =============================================================================
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --git --group-directories-first'
  alias la='eza -la --icons --git --group-directories-first'
  alias lt='eza --tree --icons --level=2'
else
  alias ls='ls -G'
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# =============================================================================
# Git
# =============================================================================
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpl='git pull'

# =============================================================================
# tmux
# =============================================================================
alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
# tmux-resurrect: セッションの手動保存・復元（キーバインドは無効化済み）
alias tmux-save='tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh'
alias tmux-restore='tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh'

# =============================================================================
# Claude Code (macOS 限定: パーミッション確認をスキップ)
# =============================================================================
alias c='claude --dangerously-skip-permissions'
alias cr='claude --resume --dangerously-skip-permissions'

# =============================================================================
# その他
# =============================================================================
alias grep='grep --color=auto'
alias cp='cp -i'            # 上書き前に確認
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -sh'
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
fi

# lazygit
alias lg='lazygit'

# キーバインド・エイリアスのリファレンスを表示
alias '?'='less ~/.zsh/reference.md 2>/dev/null || echo "~/.zsh/reference.md not found"'

# dotfiles を素早く開く
alias dotfiles='cd ~/dotfiles'
alias zshrc='${EDITOR} ~/dotfiles/zsh/.zshrc && source ~/.zshrc'
