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
    setup = function()
      vim.keymap.set('n', 'sf', '<cmd>lua require("telescope.builtin").find_files()<cr>',{noremap = true})
      vim.keymap.set('n', 'sb', '<cmd>lua require("telescope.builtin").buffers()<cr>',{noremap = true})
      vim.keymap.set('n', 'sh', '<cmd>lua require("telescope.builtin").help_tags()<cr>',{noremap = true})
    end,
  }

  -- status line
  -- use 'sheerun/vim-polyglot'
  -- use 'dense-analysis/ale'
  -- tree-sitter
  -- nvcode-color-scheme
  -- filer
  -- fuzzy finder
  -- language server
end)
