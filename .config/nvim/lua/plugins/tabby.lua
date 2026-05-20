-- vim tab management
return {
	"nanozuki/tabby.nvim",
	event = "VimEnter",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()

		local wk = require("which-key")
		wk.add({
			{ "<leader>t", group = "[T]abs", icon = "󰓩" },
			{ "<leader>ta", ":$tabnew<CR>", desc = "New Tab", mode = "n", icon = "󰓊" },
			{ "<leader>tc", ":tabclose<CR>", desc = "Close Tab", mode = "n", icon = "󰓋" },
			{ "<leader>to", ":tabonly<CR>", desc = "Close all other tabs", mode = "n", icon = "󰅖" },
			{ "<Right>", ":tabn<CR>", desc = "Next Tab", mode = "n", icon = "󰜴" },
			{ "<leader>tn", ":tabn<CR>", desc = "Next Tab", mode = "n", icon = "󰜴" },
			{ "<Left>", ":tabp<CR>", desc = "Previous Tab", mode = "n", icon = "󰜱" },
			{ "<leader>tp", ":tabp<CR>", desc = "Previous Tab", mode = "n", icon = "󰜱" },
			{ "<leader>tm", group = "[T]ab [M]ove", icon = "󰓩" },
			{ "<leader>tmp", ":-tabmove<CR>", desc = "Move current tab to previous position", mode = "n", icon = "󰁍" },
			{ "<leader>tmn", ":+tabmove<CR>", desc = "Move current tab to next position", mode = "n", icon = "󰁔" },
		})
		--
		local theme = {

			fill = { fg = "#AEA79F", bg = "#000000", style = "bold" }, -- tabline background
			head = { fg = "#FFFFFF", bg = "#000000", style = "bold" }, -- head element highlight
			current_tab = { fg = "#DFDFDF", bg = "#4D6F3E", style = "bold" }, -- current tab label highlight
			tab = { fg = "#AEA79F", bg = "#2E4225", style = "bold" }, -- other tab label highlight
			win = { fg = "#DFDFDF", bg = "#5A2E2E", style = "bold" }, -- window highlight
			current_win = { fg = "#DFDFDF", bg = "#9C4F4F", style = "bold" }, -- current window highlight
			tail = { fg = "#000000", bg = "#000000", style = "bold" }, -- tail element highlight
		}
		local api = require("tabby.module.api")
		local buf_name = require("tabby.feature.buf_name")

		-- Display name of buffer if there is only one window in the tab
		require("tabby.tab").set_option({
			name_fallback = function(tabid)
				local wins = api.get_tab_wins(tabid)
				local cur_win = api.get_tab_current_win(tabid)
				local name = ""
				if api.is_float_win(cur_win) then
					name = "[Floating]"
				elseif #wins == 1 then
					name = buf_name.get(cur_win)
				elseif #wins > 1 and api.get_current_tab() ~= tabid then
					name = string.format("[%s wins]", #wins)
				end
				return name
			end,
		})
		require("tabby.tabline").set(function(line)
			local tbl = {}
			table.insert(tbl, {
				{ "  ", hl = theme.head },
				line.sep("", theme.head, theme.fill),
			})

			line.tabs().foreach(function(tab)
				local wins = require("tabby.module.api").get_tab_wins(tab.id)
				local tab_theme = tab.is_current() and theme.current_tab or theme.tab
				local tab_name = " " .. tab.name()

				table.insert(tbl, {
					line.sep("", tab_theme, theme.fill),
					-- tab.is_current() and "" or "",
					tab_name,
					line.sep("", tab_theme, theme.fill),
					hl = tab_theme,
					margin = " ",
				})

				-- Create tab-like views for windows if there is more than one window in the tab
				if tab.is_current() and (#wins > 1) then
					line.wins_in_tab(tab.id).foreach(function(win)
						local win_name = " " .. win.buf_name()

						if string.find(win_name, "toggleterm#") then
							win_name = ""
						elseif string.find(win_name, "tree filesystem") then
							win_name = ""
						elseif string.find(win_name, "Trouble") then
							win_name = " "
						end
						local win_theme = win.is_current() and theme.current_win or theme.win
						table.insert(tbl, {
							line.sep("", win_theme, theme.fill),
							win_name,
							line.sep("", win_theme, theme.fill),
							hl = win_theme,
							margin = " ",
						})
					end)
				end
			end)

			table.insert(tbl, line.sep(",", theme.tail, theme.fill))
			table.insert(tbl, { "  ", hl = theme.tail })
			return tbl
		end)
	end,
	opts = {},
}
