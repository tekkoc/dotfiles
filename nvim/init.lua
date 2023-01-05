vim.g.setting_files = {
  'core',
  'keymap',
  'commands',
  'plugins',
}

for _, value in ipairs(vim.g.setting_files) do
  require(value)
end
