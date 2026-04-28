-- Help text for key bindings
return 

	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
		spec= {
			-- Create heading descriptions
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>e", group = "[E]xecute" },
			{ "<leader>g", group = "[G]o" },
			{ "<leader><leader>", group = "Search" },
			{ "<leader>t", group = "[T]erminal" },
			{ "<leader>tg", group = "Lazy[G]it" },
			{ "<leader>tt", group = "[T]erminal" },
			{ "t", group = "[T]abs" },
			{ "t_", hidden = true },
			{ "tm", group = "[T]ab [M]ove" },
			{ "tm_", hidden = true },
			{ "vv", group = "Expand code block select" },
			{ "vv_", hidden = true },
		},
		opts = {
			preset = "helix",
		},
	}
