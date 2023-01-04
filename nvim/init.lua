setting_files = {
  'core',
  'keymap',
  'commands',
  'plugins',
}

for _, value in ipairs(setting_files) do
  require(value)
end
