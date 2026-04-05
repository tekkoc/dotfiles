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

  -- telescope-fzf-native: ファジー検索のパフォーマンス改善
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- ==========================================================================
  -- LSP / 補完 / フォーマット
  -- ==========================================================================

  -- Mason: LSP・フォーマッタ・リンタのインストーラ（:Mason で GUI 起動）
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- mason-lspconfig: Mason と nvim-lspconfig の橋渡し
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        -- 自動インストールするサーバー（lua と rust は treesitter の ensure_installed に合わせる）
        ensure_installed = { "lua_ls", "rust_analyzer" },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig: LSP クライアント設定
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 全サーバー共通のキャパビリティ設定
      vim.lsp.config("*", { capabilities = capabilities })

      -- 共通のキーマップ（LSP アタッチ時に設定）
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      -- Lua（Neovim 設定ファイル向け）
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- サーバーを有効化
      vim.lsp.enable({ "lua_ls", "rust_analyzer" })
    end,
  },

  -- nvim-cmp: コード補完エンジン
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"]   = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]   = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- conform.nvim: フォーマッタ（:Format コマンドで実行）
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua        = { "stylua" },
          rust       = { "rustfmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json       = { "prettier" },
          markdown   = { "prettier" },
        },
        format_on_save = nil,  -- 手動フォーマットのみ（自動保存時フォーマットは無効）
      })
      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true })
      end, { desc = "Format current buffer" })
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
