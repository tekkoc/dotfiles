-- https://zenn.dev/tekkoc/scraps/218aeb3d68f508

vim.g.setting_files = {
	"core",
	"keymap",
	"commands",
	"plugins",
}

for _, value in ipairs(vim.g.setting_files) do
	require(value)
end
