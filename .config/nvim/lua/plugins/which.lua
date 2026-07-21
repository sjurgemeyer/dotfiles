-- Help text for key bindings
return

	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
		opts = {
			preset = "helix",
		},
		init = function()
			local wk = require("which-key")
			wk.add({
				-- Create heading descriptions
				{ "<leader>c", group = "[C]ode", icon = "󰘦" },
				{ "<leader>d", group = "[D]ocument", icon = "󰈙" },
				{ "<leader>e", group = "[E]xecute", icon = "󰜎" },
				{ "<leader>g", group = "[G]it", icon = "", mode="n" },
				{ "<leader><leader>", group = "Search", icon = "󰍉" },
				{ "<leader>o", group = "[O]cto", icon = "" },
				{ "<leader>p", group = "[P]ull Request", icon = "󰓼" },
				{ "<leader>s", group = "[S]QL", icon="" },
				{ "<leader>t", group = "[T]erminal", icon="" },
				{ "<leader>tg", group = "Lazy[G]it", icon = "󰊢" },
				{ "<leader>tt", group = "[T]erminal", icon = "󰆍" },
				{ "g", group = "[G]o", icon = "󰆾" },
				{ "gr", group = "LSP Commands", icon = "󰅩" },
				{ "t", group = "[T]abs", icon = "󰓉" },
				{ "t_", hidden = true },
				{ "tm", group = "[T]ab [M]ove", icon = "󰁮" },
				{ "tm_", hidden = true },
				{ "vv", group = "Expand code block select", icon = "󰔤" },
				{ "vv_", hidden = true },
			})
		end

	}
