-- カーソルを真ん中に
vim.o.scrolloff = 999

-- 行番号表示
vim.o.number = true
vim.o.relativenumber = true

-- 現在行・列を強調
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- 各種ファイルを生成しない
vim.o.autoread = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = false

-- 改行文字表示
vim.o.list = true
vim.o.listchars = "tab:¦ ,eol:↴,trail:-,nbsp:%,extends:>,precedes:<"

-- 検索
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = true
vim.o.incsearch = true

-- 新しいウィンドウを下に開く
vim.o.splitbelow = true

-- クリップボード
vim.o.clipboard = "unnamedplus"

-- タブ関連
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.smartindent = true

-- signcolumn を常に表示する
vim.o.signcolumn = "yes"
