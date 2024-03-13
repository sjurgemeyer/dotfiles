return {
	"nanozuki/tabby.nvim",
	event = "VimEnter",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.keymap.set("n", "ta", ":$tabnew<CR>", { noremap = true, desc = "New Tab" })
		vim.keymap.set("n", "tc", ":tabclose<CR>", { noremap = true, desc = "Close Tab" })
		vim.keymap.set("n", "to", ":tabonly<CR>", { noremap = true, desc = "Close all other tabs" })
		vim.keymap.set("n", "tn", ":tabn<CR>", { noremap = true, desc = "Next Tab" })
		vim.keymap.set("n", "tp", ":tabp<CR>", { noremap = true, desc = "Previous Tab" })
		-- move current tab to previous position
		vim.api.nvim_set_keymap(
			"n",
			"tmp",
			":-tabmove<CR>",
			{ noremap = true, desc = "Move current tab to previous position" }
		)
		-- move current tab to next position
		vim.api.nvim_set_keymap(
			"n",
			"tmn",
			":+tabmove<CR>",
			{ noremap = true, desc = "Move current tab to next position" }
		)
		--
		require("tabby.tabline").use_preset("active_wins_at_tail", {
			theme = {
				fill = "TabLineFill", -- tabline background
				head = "TabLine", -- head element highlight
				current_tab = "TabLineSel", -- current tab label highlight
				tab = "TabLine", -- other tab label highlight
				win = "TabLine", -- window highlight
				tail = "TabLine", -- tail element highlight
			},
			nerdfont = true, -- whether use nerdfont
			lualine_theme = nil, -- lualine theme name
			-- tab_name = {
			-- 	name_fallback = function(tabid)
			-- 		return tabid
			-- 	end,
			-- },
			buf_name = {
				mode = "'unique'|'relative'|'tail'|'shorten'",
			},
		})
	end,
	opts = {},
}
