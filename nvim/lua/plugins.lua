vim.api.nvim_create_augroup('packer_user_config', {})
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'packer_user_config',
    pattern = {"plugins.lua"},
    callback = function()
      vim.cmd('source ' .. vim.fn.expand("%"))
      vim.cmd('PackerCompile')
      vim.cmd('PackerInstall')
      vim.cmd('PackerClean')
    end,
  })

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

  use {
    'thinca/vim-ambicmd',
    setup = function()
      vim.keymap.set('c', '<space>', [[ambicmd#expand("\<Space>")]], {expr = true})
      vim.keymap.set('c', '<CR>', [[ambicmd#expand("\<CR>")]], {expr = true})
    end,
  }

  use 'cohama/vim-insert-linenr'

  use {
    'tyru/open-browser.vim',
    config = function()
      vim.keymap.set('n', '<leader>o', '<Plug>(openbrowser-open)', {silent = true})
    end,
  }


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

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      vim.keymap.set('n', 'gk',  '<cmd>lua vim.lsp.buf.hover()<CR>')
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
      vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    end,
  }
  use {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  }
  use {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      local lspconfig = require('lspconfig')
      require("mason-lspconfig").setup({
          ensure_installed = { "sumneko_lua" }
        })
      require('mason-lspconfig').setup_handlers({
          function(server)
            lspconfig[server].setup({})
          end,
          ["sumneko_lua"] = function ()
            lspconfig.sumneko_lua.setup {
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" }
                  }
                }
              }
            }
          end,
        })
    end,
  }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
          sources = {
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          },
          mapping = cmp.mapping.preset.insert({
              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-n>"] = cmp.mapping.select_next_item(),
              ['<C-c>'] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm { select = true },
            }),
          experimental = {
            ghost_text = true,
          },
        })
    end,
  }

  -- use 'dense-analysis/ale'
  -- filer
end)
