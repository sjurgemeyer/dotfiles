-- Fuzzy Finder for all the things
return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	dependencies = {
		"polirritmico/telescope-lazy-plugins.nvim",
		"nvim-lua/plenary.nvim",
		"debugloop/telescope-undo.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		-- requires nerdfont
		{ "nvim-tree/nvim-web-devicons" },
		{
			"isak102/telescope-git-file-history.nvim",
			dependencies = { "tpope/vim-fugitive" },
		},
	},
	config = function()
		local gfh_actions = require("telescope").extensions.git_file_history.actions
		require("telescope").setup({
			defaults = {
				path_display = {
					truncate = 3,
				},
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.6,
					},
				},
				mappings = {
					i = { ["<c-enter>"] = "to_fuzzy_refine" },
					n = {
						["<c-d>"] = require("telescope.actions").delete_buffer,
					},
				},
			},
			pickers = {
			    find_files = {
			      find_command = { "fd", "--hidden" }
			    },
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				git_file_history = {
					mappings = {},
				},
			},
		})

		-- specifically create a view for browsing files
		pcall(require("telescope").load_extension, "file_browser")
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "lazy_plugins")
		pcall(require("telescope").load_extension, "undo")
		require("telescope").load_extension("git_file_history")

		local builtin = require("telescope.builtin")

		local wk = require("which-key")
		wk.add({
			{ "<leader><leader>.", builtin.oldfiles, desc = 'Recent Files ("." for repeat)', mode = "n", icon = "" },
			{ "<leader><leader>b", builtin.buffers, desc = "Find Open buffers", mode = "n", icon = "󰈙" },
			{ "<leader><leader>c", ":Telescope git_file_history<CR>", desc = "Find [C]ommits", mode = "n", icon = "󰊢" },
			{ "<leader><leader>d", builtin.diagnostics, desc = "Search [D]iagnostics", mode = "n", icon = "󰒡" },
			{ "<leader><leader>f", builtin.find_files, desc = "Find [F]iles", mode = "n", icon = "󰱼" },
			{ "<leader><leader>g", function() builtin.live_grep({ additional_args = { "--hidden" } }) end, desc = "Search by [G]rep", mode = "n", icon = "󰍉" },
			{ "<leader><leader>h", builtin.help_tags, desc = "Find [H]elp topics", mode = "n", icon = "󰘥" },
			{ "<leader><leader>k", builtin.keymaps, desc = "Search [K]eymaps", mode = "n", icon = "󰌌" },
			{ "<leader><leader>n", ":Telescope notify<CR>", desc = "Search [N]otifications", mode = "n", icon = "󰂚" },
			{ "<leader><leader>p", ":Telescope lazy_plugins<CR>", desc = "Find [P]lugin Config", mode = "n", icon = "󰏓" },
			{ "<leader><leader>r", builtin.resume, desc = "Search [R]esume", mode = "n", icon = "󰑓" },
			{ "<leader><leader>s", "<Cmd>Telescope frecency<CR>", desc = "Find by Frecency", mode = "n", icon = "󰙄" },
			{ "<leader><leader>t", builtin.builtin, desc = "Find [T]elescope functions", mode = "n", icon = "󰹢" },
			{ "<leader><leader>u", ":Telescope undo<CR>", desc = "Search [U]ndo tree", mode = "n", icon = "󰕍" },
			{ "<leader><leader>v", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search [N]eovim config", mode = "n", icon = "" },
			{ "<leader><leader>w", builtin.grep_string, desc = "Search current [W]ord", mode = "n", icon = "󰬶" },
			{ "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, desc = "Fuzzily search in current buffer", mode = "n", icon = "󰊄" },
			{ "<leader><leader>/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, desc = "Search [/] in Open Buffers", mode = "n", icon = "󰺮" },
		})
	end,
}
