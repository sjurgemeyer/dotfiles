-- Fuzzy Finder for all the things
return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	branch = "0.1.x",
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
			-- pickers = {}
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
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", "<Cmd>Telescope frecency<CR>", { desc = "[S]earch Frecency" })
		vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "[S]earch Select [T]elescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>sp", ":Telescope lazy_plugins<CR>", { desc = "[P]lugin Config" })
		vim.keymap.set("n", "<leader>su", ":Telescope undo<CR>", { desc = "[U]ndo tree" })
		vim.keymap.set("n", "<leader>sc", ":Telescope git_file_history<CR>", { desc = "[S]earch [C]ommits" })

		-- fuzzy finder within file
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim config" })
	end,
}
