return {
	"akinsho/toggleterm.nvim",
	version = "*",
	event = "VeryLazy",
	opts = {},
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<F3>]],
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})
	end,
	init = function()
		local Terminal = require("toggleterm.terminal").Terminal
		local terminal = Terminal:new({
			shade_terminals = false,

			on_open = function(term)
				vim.b.display_name = "Terminal"
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })
			end,
		})
		local lazygit = Terminal:new({
			name = "lazygit",
			cmd = "lazygit",
			hidden = true,
			dir = "git_dir",
			direction = "float",
			float_opts = {
				border = "double",
			},
			-- function to run on opening the terminal
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.b.display_name = "LazyGit"
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})

		function _lazygit_toggle()
			lazygit:toggle()
		end

		function _terminal_toggle()
			terminal:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua _terminal_toggle()<CR>", { noremap = true, silent = true })
	end,
}
