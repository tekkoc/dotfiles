#!/usr/bin/env python3
"""
Claude Code カスタムステータスライン
~/.claude/statusline.py（dotfiles/claude/statusline.py からシンボリックリンク）

stdin から JSON を受け取り、ステータスラインの内容を stdout に出力する。
設定: ~/.claude/settings.json の "statusLine.command" に登録する。

カラーパレット（Oh My Posh / tmux テーマと統一）:
  ライトブルー: #9FDAF4
  グリーン:     #ADDB67
  オレンジ:     #EF9F27
  紫:           #534AB7
"""

import json
import os
import subprocess
import sys


# ANSI カラー定義（Truecolor）
def fg(hex_color: str) -> str:
    r = int(hex_color[1:3], 16)
    g = int(hex_color[3:5], 16)
    b = int(hex_color[5:7], 16)
    return f"\033[38;2;{r};{g};{b}m"


RESET = "\033[0m"
BOLD = "\033[1m"

BLUE = fg("#9FDAF4")    # ライトブルー（アクセント）
GREEN = fg("#ADDB67")   # グリーン
ORANGE = fg("#EF9F27")  # オレンジ（警告）
RED = fg("#E24B4A")     # レッド（危険）
PURPLE = fg("#534AB7")  # 紫
DIM = fg("#4a5568")     # 暗めのグレー


def braille_bar(pct: float, width: int = 8) -> str:
    """点字ドット風の進捗バーを生成する（0-100%）"""
    FULL = "⣿"
    EMPTY = "⣀"
    filled = round(pct / 100 * width)
    return FULL * filled + EMPTY * (width - filled)


def color_for_pct(pct: float) -> str:
    """使用率に応じたカラーを返す"""
    if pct >= 80:
        return RED
    elif pct >= 50:
        return ORANGE
    else:
        return GREEN


def get_git_info() -> tuple[str, str]:
    """
    (ブランチ表示, worktree名) を返す。
    取得できない場合は空文字列。
    """
    try:
        branch = subprocess.check_output(
            ["git", "branch", "--show-current"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        if not branch:
            # detached HEAD
            branch = subprocess.check_output(
                ["git", "rev-parse", "--short", "HEAD"],
                stderr=subprocess.DEVNULL,
                text=True,
            ).strip()
            branch = f"@{branch}"
    except Exception:
        return "", ""

    # 変更状態
    try:
        status_lines = subprocess.check_output(
            ["git", "status", "--porcelain"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).splitlines()
        unstaged = any(l[1] != " " and l[1] != "?" for l in status_lines if len(l) >= 2)
        staged = any(l[0] != " " and l[0] != "?" for l in status_lines if len(l) >= 2)
        if unstaged:
            branch += " *"
        if staged:
            branch += " +"
    except Exception:
        pass

    # worktree 判定（.git がファイルなら worktree 内）
    worktree = ""
    try:
        toplevel = subprocess.check_output(
            ["git", "rev-parse", "--show-toplevel"],
            stderr=subprocess.DEVNULL,
            text=True,
        ).strip()
        git_path = os.path.join(toplevel, ".git")
        if os.path.isfile(git_path):
            worktree = os.path.basename(toplevel)
    except Exception:
        pass

    return branch, worktree


def short_path(path: str) -> str:
    """ホームディレクトリを ~ に短縮する"""
    home = os.path.expanduser("~")
    if path.startswith(home):
        return "~" + path[len(home):]
    return path


def main() -> None:
    # stdin から JSON を読み込む
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    # --- データ取得 ---
    cwd = data.get("workspace", {}).get("current_dir", os.getcwd())
    model = data.get("model", {}).get("display_name", "")

    ctx_pct = float(data.get("context_window", {}).get("used_percentage") or 0)

    rate_limits = data.get("rate_limits", {})
    rate5h_pct = float(
        (rate_limits.get("five_hour") or {}).get("used_percentage") or 0
    )
    rate7d_pct = float(
        (rate_limits.get("seven_day") or {}).get("used_percentage") or 0
    )

    git_branch, worktree = get_git_info()

    # --- 出力組み立て ---
    parts = []

    # カレントディレクトリ
    parts.append(f"{BLUE}{short_path(cwd)}{RESET}")

    # Git ブランチ
    if git_branch:
        branch_color = ORANGE if ("*" in git_branch or "+" in git_branch) else GREEN
        parts.append(f"{branch_color}{git_branch}{RESET}")

    # worktree 名
    if worktree:
        parts.append(f"{DIM}({worktree}){RESET}")

    # モデル名
    if model:
        parts.append(f"{PURPLE}{model}{RESET}")

    sep = f" {DIM}│{RESET} "
    line1 = sep.join(parts)

    # コンテキスト使用率バー
    ctx_color = color_for_pct(ctx_pct)
    ctx_bar = f"{ctx_color}{braille_bar(ctx_pct)}{RESET}"
    ctx_label = f"{ctx_color}{ctx_pct:.0f}%{RESET}"

    # レート制限バー（取得できた場合のみ表示）
    rate_parts = [f"ctx {ctx_bar} {ctx_label}"]
    if rate5h_pct > 0 or rate5h_pct == 0 and "five_hour" in rate_limits:
        c = color_for_pct(rate5h_pct)
        rate_parts.append(f"5h {c}{braille_bar(rate5h_pct)}{RESET} {c}{rate5h_pct:.0f}%{RESET}")
    if rate7d_pct > 0 or rate7d_pct == 0 and "seven_day" in rate_limits:
        c = color_for_pct(rate7d_pct)
        rate_parts.append(f"7d {c}{braille_bar(rate7d_pct)}{RESET} {c}{rate7d_pct:.0f}%{RESET}")

    line2 = f"  {sep.join(rate_parts)}"

    print(line1)
    print(line2)


if __name__ == "__main__":
    main()
