# キーバインド・エイリアス リファレンス

`q` で閉じる

---

## tmux キーバインド

prefix = `Ctrl+z`（prefix の後に以下のキーを押す。`Ctrl` を押しっぱなしでも動作）

### セッション・ウィンドウ操作

| 操作               | キー                        |
|-------------------|-----------------------------|
| 新規ウィンドウ      | `c` / `z`（`Ctrl+c` / `Ctrl+z`） |
| 次のウィンドウ      | `n`（`Ctrl+n`）★             |
| 前のウィンドウ      | `p`（`Ctrl+p`）★             |
| ウィンドウ一覧      | `w`（`Ctrl+w`）              |
| ウィンドウ検索      | `f`（`Ctrl+f`）              |
| セッション一覧      | `S`                         |
| デタッチ           | `d`（`Ctrl+d`）              |

★ = repeat-time（1 秒）以内なら prefix 再入力不要で連続操作可能

### ペイン操作

| 操作               | キー                        |
|-------------------|-----------------------------|
| 左右に分割         | `v`                         |
| 上下に分割         | `s`                         |
| ペイン移動         | `h` / `j` / `k` / `l`（`Ctrl+h/j/k/l`）★ |
| ペインリサイズ      | `H` / `J` / `K` / `L`（5セルずつ）★ |
| ペインを閉じる      | `q`（`Ctrl+q`）              |
| ペイン番号表示      | `x`（`Ctrl+x`）              |
| ペインローテーション | `o`（`Ctrl+o`）              |
| ペインズーム       | `m`                         |

### その他

| 操作               | キー                        |
|-------------------|-----------------------------|
| 設定リロード       | `r`（`Ctrl+r`）              |

---

## zsh キーバインド（Emacs スタイル）

| 操作               | キー                        |
|-------------------|-----------------------------|
| 行頭へ移動         | `Ctrl+a`                    |
| 行末へ移動         | `Ctrl+e`                    |
| 行末まで削除       | `Ctrl+k`                    |
| 単語単位で前後移動  | `Alt+f` / `Alt+b`           |
| 履歴インクリメンタル検索 | `Ctrl+r`               |
| 前の履歴           | `Ctrl+p`                    |
| 次の履歴           | `Ctrl+n`                    |
| サスペンド（プロセス停止） | `Ctrl+]`（tmux 外のみ） |

---

## エイリアス

### Claude Code

| エイリアス | 展開先                              |
|----------|--------------------------------------|
| `c`      | `claude --enable-auto-mode`          |
| `cr`     | `claude --resume --enable-auto-mode` |

### Git

| エイリアス | 展開先                              |
|----------|--------------------------------------|
| `g`      | `git`                                |
| `gs`     | `git status -sb`                     |
| `ga`     | `git add`                            |
| `gc`     | `git commit`                         |
| `gco`    | `git checkout`                       |
| `gb`     | `git branch`                         |
| `gd`     | `git diff`                           |
| `gl`     | `git log --oneline --graph --decorate -20` |
| `gp`     | `git push`                           |
| `gpl`    | `git pull`                           |
| `lg`     | `lazygit`                            |

### ファイル操作（eza）

| エイリアス | 展開先                              |
|----------|--------------------------------------|
| `ls`     | `eza --icons --group-directories-first` |
| `ll`     | `eza -l --icons --git --group-directories-first` |
| `la`     | `eza -la --icons --git --group-directories-first` |
| `lt`     | `eza --tree --icons --level=2`       |

### tmux

| エイリアス | 展開先                  |
|----------|--------------------------|
| `t`      | `tmux`                   |
| `ta`     | `tmux attach -t`         |
| `tl`     | `tmux list-sessions`     |
| `tn`     | `tmux new-session -s`    |
| `tk`     | `tmux kill-session -t`   |

### その他

| エイリアス | 展開先                              |
|----------|--------------------------------------|
| `?`      | このファイルを表示                    |
| `cat`    | `bat --paging=never`（bat がある場合） |
| `..`     | `cd ..`                              |
| `...`    | `cd ../..`                           |
| `-`      | `cd -`（直前のディレクトリへ）        |
| `dotfiles` | `cd ~/dotfiles`                  |
| `zshrc`  | .zshrc を編集して再読み込み           |

---

## git エイリアス（.gitconfig）

| エイリアス | 展開先               |
|----------|----------------------|
| `st`     | `status`             |
| `co`     | `checkout`           |
| `br`     | `branch`             |
| `ci`     | `commit`             |
| `df`     | `diff`               |
