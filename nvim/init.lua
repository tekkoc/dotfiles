vim.g.mapleader = ","

-- カーソルを真ん中に
vim.o.scrolloff = 999

-- 行番号表示
vim.o.number = true
vim.o.relativenumber = true

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
vim.o.listchars = 'tab:¦ ,eol:↴,trail:-,nbsp:%,extends:>,precedes:<'

-- 検索
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = true
vim.o.incsearch = true

-- 新しいウィンドウを下に開く
vim.o.splitbelow = true

-- クリップボード
vim.o.clipboard='unnamedplus'

-- タブ関連
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.autoindent = true
vim.o.smartindent = true

vim.cmd 'colorscheme iceberg'

-- ; : の入れ替え
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

-- <C-l> を ESC に
vim.keymap.set({'v', 'i', 'c'}, '<C-l>', '<ESC>')
vim.keymap.set('n', '<C-l>', ':nohlsearch<CR>')

-- 移動
vim.keymap.set({'n', 'v'}, 'J', '10j')
vim.keymap.set({'n', 'v'}, 'K', '10k')
vim.keymap.set({'n', 'v'}, 'H', '10h')
vim.keymap.set({'n', 'v'}, 'L', '10l')

-- 保存
vim.keymap.set('n', '<SPACE>w', ':write<CR>')

-- Qキーをマクロに
vim.keymap.set('n', 'q', '<NOP>')
vim.keymap.set('n', 'Q', 'q')

-- s を 画面移動系のprefixに
vim.keymap.set('n', 's', '<NOP>')

vim.keymap.set('n', 'sq', ':quit<CR>')

-- 分割
vim.keymap.set('n', 'ss', ':sp<CR>')
vim.keymap.set('n', 'sv', ':vs<CR>')

-- 分割移動
vim.keymap.set('n', 'sj', '<C-w>j')
vim.keymap.set('n', 'sk', '<C-w>k')
vim.keymap.set('n', 'sh', '<C-w>h')
vim.keymap.set('n', 'sl', '<C-w>l')
vim.keymap.set('n', 'sJ', '<C-w>J')
vim.keymap.set('n', 'sK', '<C-w>K')
vim.keymap.set('n', 'sH', '<C-w>H')
vim.keymap.set('n', 'sL', '<C-w>L')

-- タブページ
vim.keymap.set('n', 'st', ':tabnew<CR>')
vim.keymap.set('n', 'sn', 'gt')
vim.keymap.set('n', 'sp', 'gT')
vim.keymap.set('n', 'sN', ':tabmove +1')
vim.keymap.set('n', 'sP', ':tabmove -1')

-- 編集支援系
vim.keymap.set('n', '<CR>', 'o<ESC>')
vim.keymap.set('n', '<SPACE>d', 'cc<ESC>')

-- init.lua 関連
dotfiles_path = '~/dev/src/github.com/tekkoc/dotfiles'
init_path = dotfiles_path .. '/nvim/init.lua'
plugin_path = dotfiles_path .. '/nvim/lua/plugins.lua'
vim.keymap.set('n', '<SPACE>..', ':edit ' .. init_path .. '<CR>')
vim.keymap.set('n', '<SPACE>.e', ':edit ' .. init_path .. '<CR>')
vim.keymap.set('n', '<SPACE>.p', ':edit ' .. plugin_path .. '<CR>')
vim.keymap.set('n', '<SPACE>.r', ':source ' .. init_path .. '<CR>')

vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require('plugins')
