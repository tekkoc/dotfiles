vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'cocopon/iceberg.vim'

  use 'mattn/vim-findroot'

  use 'jiangmiao/auto-pairs'

  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-entire'
  use 'kana/vim-textobj-indent'
  use 'kana/vim-textobj-line'

  use 'kana/vim-operator-user'
  use {
    'kana/vim-operator-replace',
    setup = function()
      vim.keymap.set('v', 'p', '<Plug>(operator-replace)')
      vim.keymap.set('', 'R', '<Plug>(operator-replace)')
    end,
  }
  use {
    'tyru/operator-camelize.vim',
    setup = function()
      vim.keymap.set('', '<leader>c', '<Plug>(operator-camelize)')
      vim.keymap.set('', '<leader>C', '<Plug>(operator-decamelize)')
    end,
  }

  use {
    'tpope/vim-commentary',
    setup = function()
      vim.keymap.set('n', 'CC', 'gcl', {remap = true})
      vim.keymap.set('', 'C', 'gc', {remap = true})
    end,
  }

  use 'mhinz/vim-signify'

  use 'cohama/vim-insert-linenr'

  use 'rust-lang/rust.vim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>uf', builtin.find_files)
      vim.keymap.set('n', '<leader>ub', builtin.buffers)
      vim.keymap.set('n', '<leader>uh', builtin.help_tags)
      vim.keymap.set('n', '<leader>ug', builtin.live_grep)
      require('telescope').setup{
        defaults = {
          mappings = {
            i = {
              ["<C-l>"] = "close"
            }
          }
        }
      }
    end,
  }

  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = {"kkharji/sqlite.lua"},
    config = function()
      require"telescope".load_extension("frecency")

      vim.keymap.set('n', '<leader>um', require('telescope').extensions.frecency.frecency)
    end,
  }

  use 'sheerun/vim-polyglot'
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {'lua', 'rust'},
      }
    end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = {},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'filetype'},
          lualine_y = {},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {'diff'},
          lualine_b = {{'filename', path = 1}},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {'location'},
        },
      }
    end,
  }

  -- use 'dense-analysis/ale'
  -- filer
  -- language server
end)
