-- github integration for PRs etc
return

	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		dependencies = {
			"folke/which-key.nvim",
		},
		opts = {
			-- or "fzf-lua" or "snacks" or "default"
			picker = "telescope",
			-- bare Octo command opens picker of commands
			enable_builtin = true,
		},
		init = function()
			wk = require("which-key")
			wk.add({
				{ "<leader>oi", "<CMD>Octo issue list<CR>", desc = "List GitHub Issues", icon="" },
				{ "<leader>op", "<CMD>Octo pr list<CR>", desc = "List GitHub PullRequests",icon="" },
				{ "<leader>od", "<CMD>Octo discussion list<CR>", desc = "List GitHub Discussions", icon="" },
				{ "<leader>on", "<CMD>Octo notification list<CR>", desc = "List GitHub Notifications",icon="" },
				{ "<leader>os", function() require("octo.utils").create_base_search_command { include_current_repo = true } end, desc = "Search GitHub", icon="", },
			})
		end
	}
