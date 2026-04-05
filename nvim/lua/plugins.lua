local map = vim.keymap.set

return {
  -- カラースキーム
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "catppuccin" },
      })
    end,
  },

  -- Insertモード時に行番号の色を変更
  { "cohama/vim-insert-linenr" },

  -- 括弧の自動入力
  { "jiangmiao/auto-pairs" },

  -- テキストオブジェクト拡張
  { "kana/vim-textobj-user" },
  { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } },
  { "kana/vim-textobj-indent", dependencies = { "kana/vim-textobj-user" } },
  { "kana/vim-textobj-line",   dependencies = { "kana/vim-textobj-user" } },

  -- レジスタ内容で置き換え
  {
    "kana/vim-operator-replace",
    dependencies = { "kana/vim-operator-user" },
    config = function()
      map({ "n", "v", "o" }, "R", "<Plug>(operator-replace)", {})
      map("v", "p", "<Plug>(operator-replace)", {})
    end,
  },
  { "kana/vim-operator-user" },

  -- キャメルケース変換
  {
    "tyru/operator-camelize.vim",
    dependencies = { "kana/vim-operator-user" },
    config = function()
      map({ "n", "v", "o" }, "<leader>c", "<Plug>(operator-camelize)", {})
      map({ "n", "v", "o" }, "<leader>C", "<Plug>(operator-decamelize)", {})
    end,
  },

  -- コメントアウト
  {
    "tpope/vim-commentary",
    config = function()
      map({ "n", "v", "o" }, "C", "<Plug>Commentary", {})
      map("n", "CC", "<Plug>CommentaryLine", {})
    end,
  },

  -- コマンド補完（大文字小文字無視）
  {
    "thinca/vim-ambicmd",
    config = function()
      vim.api.nvim_set_keymap("c", "<Space>", [[ambicmd#expand('<Space>')]], { expr = true, noremap = true })
      vim.api.nvim_set_keymap("c", "<CR>",    [[ambicmd#expand('<CR>')]], { expr = true, noremap = true })
    end,
  },

  -- ファジーファインダー (Telescope)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          mappings = {
            n = { ["<C-l>"] = "close" },
          },
        },
      })
      telescope.load_extension("file_browser")

      map("n", "<leader>uf", builtin.find_files, { noremap = true })
      map("n", "<leader>ub", builtin.buffers, { noremap = true })
      map("n", "<leader>uh", builtin.help_tags, { noremap = true })
      map("n", "<leader>ug", builtin.live_grep, { noremap = true })
      map("n", "<leader>um", builtin.oldfiles, { noremap = true })
      map("n", "<leader>uF", telescope.extensions.file_browser.file_browser, { noremap = true })
    end,
  },

  -- シンタックスハイライト
  { "sheerun/vim-polyglot" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust" },
        highlight = { enable = true },
      })
    end,
  },

  -- Git変更表示
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- .gitのあるディレクトリを自動でcwd設定
  { "mattn/vim-findroot" },

  -- プロジェクト別設定
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup({
        config_files = { "local.init.lua" },
      })
    end,
  },

  -- URLをブラウザで開く
  {
    "tyru/open-browser.vim",
    config = function()
      map("n", "<leader>o", "<Plug>(openbrowser-smart-search)", {})
    end,
  },

  -- Rustサポート
  { "rust-lang/rust.vim" },
}
