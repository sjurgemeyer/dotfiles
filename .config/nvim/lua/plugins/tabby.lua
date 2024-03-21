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
		local theme = {

			fill = { fg = "#AEA79F", bg = "#262626", style = "bold" }, -- tabline background
			head = { fg = "#FFFFFF", bg = "#000000", style = "bold" }, -- head element highlight
			current_tab = { fg = "#DFDFDF", bg = "#415D34", style = "bold" }, -- current tab label highlight
			tab = { fg = "#AEA79F", bg = "#262626", style = "bold" }, -- other tab label highlight
			win = { fg = "#000000", bg = "#569CD6", style = "bold" }, -- window highlight
			tail = { fg = "#000000", bg = "#907aa9", style = "bold" }, -- tail element highlight
		}
		-- require("tabby.tabline").use_preset("tab_with_top_win", {
		-- 	nerdfont = true, -- whether use nerdfont
		-- 	lualine_theme = nil, -- lualine theme name
		-- 	-- tab_name = {
		-- 	-- 	name_fallback = function(tabid)
		-- 	-- 		return tabid
		-- 	-- 	end,
		-- 	-- },
		-- 	buf_name = {
		-- 		mode = "'unique'|'relative'|'tail'|'shorten'",
		-- 	},
		-- })
		require("tabby.tabline").set(function(line)
			return {
				{
					{ "  ", hl = theme.head },
					line.sep("", theme.head, theme.fill),
				},
				line.tabs().foreach(function(tab)
					local hl = tab.is_current() and theme.current_tab or theme.tab
					return {
						line.sep("", hl, theme.fill),
						tab.is_current() and "" or "󰆣",
						tab.number(),
						tab.name(),
						tab.close_btn(""),
						line.sep("", hl, theme.fill),
						hl = hl,
						margin = " ",
					}
				end),
				line.spacer(),
				line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
					return {
						line.sep("", theme.win, theme.fill),
						win.is_current() and "" or "",
						win.buf_name(),
						line.sep("", theme.win, theme.fill),
						hl = theme.win,
						margin = " ",
					}
				end),
				{
					line.sep("", theme.tail, theme.fill),
					{ "  ", hl = theme.tail },
				},
				hl = theme.fill,
			}
		end)
	end,
	opts = {},
}
