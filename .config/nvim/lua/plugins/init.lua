return {
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- window resize mode with C-e
	"simeji/winresizer",
	-- rainbow brances
	"HiPhish/rainbow-delimiters.nvim",
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	-- maximize window
	{
		"caenrique/nvim-maximize-window-toggle",
		config = function()
			vim.keymap.set("n", "<CR>", ":ToggleOnly<CR>")
		end,
	},
	-- highlight RGB colors in files
	{ "brenoprata10/nvim-highlight-colors", opts = {} },
	{
		"max397574/colortils.nvim",
		opts = {},
		config = function()
			require("colortils").setup({})
		end,
	},
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	-- indentation guides
	-- { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	--

	-- status line of code context
	{
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig",
		config = function() -- This is the function that runs, AFTER loading
			require("nvim-navic").setup({ lsp = {
				auto_attach = false,
				preference = nil,
			} })
		end,
	},
	-- Help text for key bindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()
			-- Create heading descriptions
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>e"] = { name = "[E]xecute", _ = "which_key_ignore" },
				["<leader>g"] = { name = "[G]o", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>t"] = { name = "[T]erminal", _ = "which_key_ignore" },
				["<leader>tt"] = { name = "[T]erminal", _ = "which_key_ignore" },
				["<leader>tg"] = { name = "Lazy[G]it", _ = "which_key_ignore" },
				["vv"] = { name = "Expand code block select", _ = "which_key_ignore" },
				["bb"] = { name = "Decrease code block select", _ = "which_key_ignore" },
				["t"] = { name = "[T]abs", _ = "which_key_ignore" },
				["tm"] = { name = "[T]ab [M]ove", _ = "which_key_ignore" },
			})
		end,
	},
	-- Tree view
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
						["u"] = "navigate_up",
					},
				},

				vim.keymap.set("n", "<Tab>", ":Neotree toggle<CR>", { desc = "Toggle filetree" }),
				vim.keymap.set("n", "<F12>", ":Neotree reveal<CR>", { desc = "Reveal current file in filetree" }),
				vim.keymap.set(
					"n",
					"<leader><Tab>",
					":Neotree toggle position=current<CR>",
					{ desc = "Open filetree in full view" }
				),
			})
		end,
	},
	-- file browser in telescope
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		mappings = {
			["n"] = {
				["<leader>fb"] = ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
			},
		},
	},
	-- smart sorting on search
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
	},
	-- switch between cases
	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("textcase").setup({})
			require("telescope").load_extension("textcase")
		end,
		keys = {
			"ga", -- Default invocation prefix
			{ "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
		},
		cmd = {
			-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
			"Subs",
			"TextCaseOpenTelescope",
			"TextCaseOpenTelescopeQuickChange",
			"TextCaseOpenTelescopeLSPChange",
			"TextCaseStartReplacingCommand",
		},
		-- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
		-- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
		-- available after the first executing of it or after a keymap of text-case.nvim has been used.
		lazy = false,
	},
	-- Rust
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
	},
	-- Autoformat
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},

	-- Highlight todo, notes, etc in comments
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },
	-- Collection of various small independent plugins/modules
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]parenthen
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			--  More at: https://github.com/echasnovski/mini.nvim
		end,
	},
	-- Highlight, edit, and navigate code
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" },
				-- Autoinstall languages that are not installed
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				-- select blocks of code, by continuously hitting `vv`.  `bb` to reduce scope of selection
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "vv", -- set to `false` to disable one of the mappings
						node_incremental = "vv",
						scope_incremental = "vb",
						node_decremental = "bb",
					},
				},
			})

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see :help nvim-treesitter-incremental-selection-mod
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
}
