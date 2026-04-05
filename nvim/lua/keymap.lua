local map = vim.keymap.set

vim.g.mapleader = ","

-- コマンドモード入力の入れ替え
map("n", ";", ":", { noremap = true })
map("n", ":", ";", { noremap = true })

-- ESC
map({ "i", "v", "c" }, "<C-l>", "<ESC>", { noremap = true })
map("n", "<C-l>", ":nohlsearch<CR>", { noremap = true, silent = true })
map("t", "<C-l>", "<C-\\><C-n>", { noremap = true })
map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

-- 高速移動
map({ "n", "v" }, "J", "10j", { noremap = true })
map({ "n", "v" }, "K", "10k", { noremap = true })
map({ "n", "v" }, "H", "10h", { noremap = true })
map({ "n", "v" }, "L", "10l", { noremap = true })

-- ファイル保存
map("n", "<Space>w", ":write<CR>", { noremap = true, silent = true })

-- 下に空行挿入
map("n", "<CR>", "o<ESC>", { noremap = true })

-- 行内容を削除（空行にする）
map("n", "<Space>d", "cc<ESC>", { noremap = true })

-- マクロ操作
map("n", "q", "<Nop>", { noremap = true })
map("n", "Q", "q", { noremap = true })

-- ウィンドウ・分割操作 (s プレフィックス)
map("n", "sq", ":close<CR>", { noremap = true, silent = true })
map("n", "ss", ":split<CR>", { noremap = true, silent = true })
map("n", "sv", ":vsplit<CR>", { noremap = true, silent = true })
map("n", "sj", "<C-w>j", { noremap = true })
map("n", "sk", "<C-w>k", { noremap = true })
map("n", "sh", "<C-w>h", { noremap = true })
map("n", "sl", "<C-w>l", { noremap = true })
map("n", "sJ", "<C-w>J", { noremap = true })
map("n", "sK", "<C-w>K", { noremap = true })
map("n", "sH", "<C-w>H", { noremap = true })
map("n", "sL", "<C-w>L", { noremap = true })
map("n", "sT", ":split | terminal<CR>", { noremap = true, silent = true })

-- タブページ
map("n", "st", ":tabnew<CR>", { noremap = true, silent = true })
map("n", "sn", ":tabnext<CR>", { noremap = true, silent = true })
map("n", "sp", ":tabprevious<CR>", { noremap = true, silent = true })
map("n", "sN", ":tabmove +1<CR>", { noremap = true, silent = true })
map("n", "sP", ":tabmove -1<CR>", { noremap = true, silent = true })

-- 設定ファイル
map("n", "<Space>..", ":edit $MYVIMRC<CR>", { noremap = true, silent = true })
map("n", "<Space>.r", ":source $MYVIMRC<CR>", { noremap = true, silent = true })
