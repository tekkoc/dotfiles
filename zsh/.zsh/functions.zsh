# functions.zsh — 関数定義

# -----------------------------------------------------------------------------
# mkcd: ディレクトリを作って移動
# -----------------------------------------------------------------------------
mkcd() { mkdir -p "$1" && cd "$1"; }

# -----------------------------------------------------------------------------
# fcd: fzf でディレクトリを選んで移動
# -----------------------------------------------------------------------------
fcd() {
  local dir
  dir=$(find "${1:-.}" -type d 2>/dev/null \
    | fzf --preview 'eza --tree --level=1 --icons {}' \
          --preview-window=right:40%) \
  && cd "$dir"
}

# -----------------------------------------------------------------------------
# ghq-fzf: ghq リポジトリを fzf で選んで移動
# （ghq を使っていない場合は不要）
# -----------------------------------------------------------------------------
ghq-fzf() {
  local repo
  repo=$(ghq list | fzf --preview "bat --color=always --style=header \
    $(ghq root)/{}/README.md 2>/dev/null || ls $(ghq root)/{}") \
  && cd "$(ghq root)/$repo"
}
bindkey -s '^g' 'ghq-fzf\n'

# -----------------------------------------------------------------------------
# t: 引数あり→セッションに attach（なければ作成）、引数なし→セッション一覧
# -----------------------------------------------------------------------------
t() {
  if [[ $# -eq 0 ]]; then
    tmux list-sessions
  else
    local name="$1"
    if tmux has-session -t "$name" 2>/dev/null; then
      tmux attach -t "$name"
    else
      tmux new-session -s "$name"
    fi
  fi
}

# -----------------------------------------------------------------------------
# path: PATH を見やすく表示
# -----------------------------------------------------------------------------
path() { echo "$PATH" | tr ':' '\n' | nl; }

# -----------------------------------------------------------------------------
# mm: Mac mini に接続（LAN 優先、圏外なら Tailscale 経由）[macOS]
# -----------------------------------------------------------------------------
mm() {
  local host
  if ssh -o ConnectTimeout=3 -o BatchMode=yes home true 2>/dev/null; then
    host=home
  else
    host=home-ts
  fi

  if [[ "$1" == "-t" ]]; then
    if [[ -n "$2" ]]; then
      ssh "$host" -t "tmux attach -t '$2' 2>/dev/null || tmux new-session -s '$2'"
    else
      ssh "$host" -t "tmux list-sessions"
    fi
  else
    ssh "$host"
  fi
}

# -----------------------------------------------------------------------------
# ssh: SSH 接続中に Ghostty の背景色を変えて視覚的に区別する [macOS]
# BatchMode=yes はテスト用の非インタラクティブ接続なので色を変えない
# -----------------------------------------------------------------------------
ssh() {
  if [[ " $* " == *"BatchMode=yes"* ]]; then
    command ssh "$@"
    return
  fi
  printf '\033]11;#3d1f1f\007'
  command ssh "$@"
  printf '\033]11;#1e1e2e\007'
}

# -----------------------------------------------------------------------------
# extract: 各種アーカイブを展開
# -----------------------------------------------------------------------------
extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)       tar xjf "$1" ;;
    *.tar.xz)        tar xJf "$1" ;;
    *.tar)           tar xf  "$1" ;;
    *.zip)           unzip   "$1" ;;
    *.gz)            gunzip  "$1" ;;
    *.bz2)           bunzip2 "$1" ;;
    *) echo "extract: '$1' は未対応の形式です" >&2 ;;
  esac
}
