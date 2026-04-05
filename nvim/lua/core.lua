local opt = vim.opt

-- 表示
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true
opt.scrolloff = 999
opt.signcolumn = "yes"
opt.wrap = false

-- 編集
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.clipboard = "unnamedplus"

-- 検索
opt.ignorecase = true
opt.smartcase = true

-- ウィンドウ分割
opt.splitbelow = true

-- 一時ファイル無効化
opt.backup = false
opt.swapfile = false
opt.undofile = false
