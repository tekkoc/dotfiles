vim.g.mapleader = ","

-- ; : の入れ替え
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":", ";")

-- <C-l> を ESC に
vim.keymap.set({ "v", "i", "c" }, "<C-l>", "<ESC>")
vim.keymap.set("n", "<C-l>", ":nohlsearch<CR>", { silent = true })

-- terminal でも同じマッピングで normal モードに
vim.keymap.set("t", "<C-l>", "<C-\\><C-n>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- 移動
vim.keymap.set({ "n", "v" }, "J", "10j")
vim.keymap.set({ "n", "v" }, "K", "10k")
vim.keymap.set({ "n", "v" }, "H", "10h")
vim.keymap.set({ "n", "v" }, "L", "10l")

-- 保存
vim.keymap.set("n", "<SPACE>w", ":write<CR>")

-- Qキーをマクロに
vim.keymap.set("n", "q", "<NOP>")
vim.keymap.set("n", "Q", "q")

-- s を 画面移動系のprefixに
vim.keymap.set("n", "s", "<NOP>")

vim.keymap.set("n", "sq", ":quit<CR>", { silent = true })

-- 分割
vim.keymap.set("n", "ss", ":sp<CR>", { silent = true })
vim.keymap.set("n", "sv", ":vs<CR>", { silent = true })

-- 分割移動
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sJ", "<C-w>J")
vim.keymap.set("n", "sK", "<C-w>K")
vim.keymap.set("n", "sH", "<C-w>H")
vim.keymap.set("n", "sL", "<C-w>L")

-- タブページ
vim.keymap.set("n", "st", ":tabnew<CR>", { silent = true })
vim.keymap.set("n", "sn", "gt")
vim.keymap.set("n", "sp", "gT")
vim.keymap.set("n", "sN", ":tabmove +1<CR>", { silent = true })
vim.keymap.set("n", "sP", ":tabmove -1<CR>", { silent = true })

-- 分割しつつ terminal を起動
vim.keymap.set("n", "sT", ":sp<CR>:terminal<CR>i", { silent = true })

-- 編集支援系
vim.keymap.set("n", "<CR>", "o<ESC>")
vim.keymap.set("n", "<SPACE>d", "cc<ESC>")

-- init.lua 関連
local dotfiles_path = "~/dev/src/github.com/tekkoc/dotfiles"
local init_path = dotfiles_path .. "/nvim/init.lua"
vim.keymap.set("n", "<SPACE>..", ":edit " .. init_path .. "<CR>", { silent = true })
vim.keymap.set("n", "<SPACE>.r", function()
  for _, value in ipairs(vim.g.setting_files) do
    package.loaded[value] = nil
  end
  vim.cmd(":source " .. init_path)
end)
