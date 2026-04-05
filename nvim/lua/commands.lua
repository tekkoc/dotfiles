vim.api.nvim_create_user_command("Inbox", function()
  vim.cmd("edit " .. vim.fn.expand("~/.inbox.md"))
end, {})

vim.api.nvim_create_user_command("Temp", function(opts)
  local ext = opts.args ~= "" and opts.args or "txt"
  local path = vim.fn.expand("~/.vim_tmp/tmp." .. ext)
  vim.fn.mkdir(vim.fn.expand("~/.vim_tmp"), "p")
  vim.cmd("edit " .. path)
end, { nargs = "?" })
