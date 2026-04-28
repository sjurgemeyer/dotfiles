return {
	"mikesmithgh/kitty-scrollback.nvim", {},
	{"sindrets/diffview.nvim", 
		config = function()
			vim.keymap.set("n", "<leader>go", ":DiffviewOpen<CR>", { desc = "[G]it Diff [O]pen" })
			vim.keymap.set("n", "<leader>gc", ":DiffviewOpen<CR>", { desc = "[G]it Diff [C]lose"})
		end
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{ "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
			{ "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
			{ "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
			{ "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
		},
		config = function()
			require("neo-tree").setup({
				skipInsignificantPunctuation = true,
				subwordMovement = false,
				consistentOperatorPending = false, -- see the README for details
				customPatterns = {},
			})
		end
	},
	-- quick navigation of buffers
	{
	  "leath-dub/snipe.nvim",
	  keys = {
	    {"gb", function () require("snipe").open_buffer_menu() end, desc = "Open Snipe buffer menu"}
	  },
	  opts = {}
	},
	-- better completion windows
	"onsails/lspkind.nvim",
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
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
	-- Collection of various small independent plugins/modules
	{
		"nvim-mini/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]parenthen
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.files").setup()
			-- require("mini.icons")setup()

			-- Toggle mini.files
			vim.keymap.set("n", "<leader>f", function()
				local MiniFiles = require("mini.files")
				if not MiniFiles.close() then
					MiniFiles.open(vim.api.nvim_buf_get_name(0))
				end
			end, { desc = "Toggle mini.files" })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
	-- Highlight, edit, and navigate code
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",

		init = function()
			-- Enable highlighting and indentation via built-in treesitter
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- Incremental selection keymaps (using Neovim 0.12 built-in)
			vim.keymap.set("v", "v", "an", { remap = true, desc = "Expand treesitter selection" })
			vim.keymap.set("v", "V", "in", { remap = true, desc = "Shrink treesitter selection" })
		end,
	},
	-- fancy UI
	{
	  "folke/noice.nvim",
	  event = "VeryLazy",
	  opts = {
	    -- add any options here
	  },
	  dependencies = {
	    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	    "MunifTanjim/nui.nvim",
	    -- OPTIONAL:
	    --   `nvim-notify` is only needed, if you want to use the notification view.
	    --   If not available, we use `mini` as the fallback
	    "rcarriga/nvim-notify",
	  }
	},
	-- pretty markdown
	-- {
	-- 	'MeanderingProgrammer/render-markdown.nvim',
	-- 	dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	-- 	opts = {},
	-- },
	-- Extra theme, currently used for markdown
	-- many small plugins, currently using the image rendering
	{
	    "folke/snacks.nvim",
	    opts = {
		image = {
		    enabled = true,
		    backend = "kitty",
		},
	    },
	},
}
