-- https://zenn.dev/tekkoc/scraps/218aeb3d68f508

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.setting_files = {
	"core",
	"keymap",
	"commands",
}

for _, value in ipairs(vim.g.setting_files) do
	require(value)
end

-- lazy.nvim setup
require("lazy").setup("plugins")
