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
	{
		"kana/vim-textobj-entire", -- ファイル全体
		dependencies = { "kana/vim-textobj-user" },
	},
	{
		"kana/vim-textobj-indent",
		dependencies = { "kana/vim-textobj-user" },
	},
	{
		"kana/vim-textobj-line",
		dependencies = { "kana/vim-textobj-user" },
	},

	-- operator系
	"kana/vim-operator-user",
	{
		"kana/vim-operator-replace",
		dependencies = { "kana/vim-operator-user" },
		keys = {
			{ "p", "<Plug>(operator-replace)", mode = "v" },
			{ "R", "<Plug>(operator-replace)", mode = "" },
		},
	},
	{
		"tyru/operator-camelize.vim",
		dependencies = { "kana/vim-operator-user" },
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

}