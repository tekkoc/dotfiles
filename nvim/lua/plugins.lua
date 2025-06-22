return {
	-- テーマ
	{
		"EdenEast/nightfox.nvim",
		config = function()
			vim.cmd("colorscheme duskfox")
		end,
	},

	-- .git があるディレクトリをカレントディレクトリに
	"mattn/vim-findroot",

	-- 括弧自動入力
	"jiangmiao/auto-pairs",

	-- textobj系
	"kana/vim-textobj-user",
	"kana/vim-textobj-entire", -- ファイル全体
	"kana/vim-textobj-indent",
	"kana/vim-textobj-line",

	-- operator系
	"kana/vim-operator-user",
	{
		"kana/vim-operator-replace",
		keys = {
			{ "p", "<Plug>(operator-replace)", mode = "v" },
			{ "R", "<Plug>(operator-replace)", mode = "" },
		},
	},
	{
		"tyru/operator-camelize.vim",
		keys = {
			{ "<leader>c", "<Plug>(operator-camelize)", mode = "" },
			{ "<leader>C", "<Plug>(operator-decamelize)", mode = "" },
		},
	},

	-- コメントアウト
	{
		"tpope/vim-commentary",
		keys = {
			{ "CC", "gcl", mode = "n", remap = true },
			{ "C", "gc", mode = "" },
		},
	},

	-- コマンド補完
	{
		"thinca/vim-ambicmd",
		keys = {
			{ "<space>", [[ambicmd#expand("\<Space>")]], mode = "c", expr = true },
			{ "<CR>", [[ambicmd#expand("\<CR>")]], mode = "c", expr = true },
		},
	},

	-- insertモードのときに色を変える
	"cohama/vim-insert-linenr",

	-- url をブラウザで開く
	{
		"tyru/open-browser.vim",
		keys = {
			{ "<leader>o", "<Plug>(openbrowser-open)", mode = "n", silent = true },
		},
	},

	"rust-lang/rust.vim",

	-- プロジェクト別の init.lua を書けるように
	{
		"klen/nvim-config-local",
		config = function()
			require("config-local").setup({
				config_files = { "local.init.lua" },
			})
		end,
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>uf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>ub", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>uh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
			{ "<leader>ug", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							-- TODO C-l で normal モードにしたい
						},
						n = {
							["<C-l>"] = "close",
						},
					},
				},
			})
		end,
	},

	-- 最近開いたファイル
	{
		"nvim-telescope/telescope-frecency.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		keys = {
			{ "<leader>um", "<cmd>Telescope frecency<cr>", desc = "Frecency" },
		},
		config = function()
			require("telescope").load_extension("frecency")
		end,
	},

	-- ファイラ
	{
		"nvim-telescope/telescope-file-browser.nvim",
		keys = {
			{ "<leader>uF", ":Telescope file_browser<CR>", noremap = true },
		},
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},

	-- ハイライト
	"sheerun/vim-polyglot",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "rust" },
			})
		end,
	},

	-- ステータスライン
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					always_divide_middle = true,
					globalstatus = false,
				},
				sections = {
					lualine_a = {},
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "filetype" },
					lualine_y = {},
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = { "diff" },
					lualine_b = { { "filename", path = 1 } },
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- gitの変更を表示
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "gk", "<cmd>lua vim.lsp.buf.hover()<CR>", mode = "n" },
			{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", mode = "n" },
			{ "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", mode = "n" },
		},
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "tsserver" },
			})
			require("mason-lspconfig").setup_handlers({
				function(server)
					lspconfig[server].setup({})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			})
		end,
	},

	-- lsp の進捗表示(右下のやつ)
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	},

	-- LSP の diagnostics の表示を見やすく
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	},

	-- stylua などを lsp としてラップ
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.api.nvim_create_augroup("lsp_format", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = "lsp_format",
				callback = function()
					vim.lsp.buf.format()
				end,
			})

			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.prettier,
				},
			})
		end,
	},

	-- 補完
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
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
					["<C-c>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				experimental = {
					ghost_text = true,
				},
			})
		end,
	},
}