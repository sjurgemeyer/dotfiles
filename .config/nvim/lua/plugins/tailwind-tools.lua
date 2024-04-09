return {
	"luckasRanarison/tailwind-tools.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		document_color = {
			enabled = true, -- can be toggled by commands
			kind = "inline", -- "inline" | "foreground" | "background"
			inline_symbol = "󰝤 ", -- only used in inline mode
			debounce = 200, -- in milliseconds, only applied in insert mode
		},
		conceal = {
			enabled = true, -- can be toggled by commands
			symbol = "󱏿", -- only a single character is allowed
			highlight = { -- extmark highlight options, see :h 'highlight'
				fg = "#38BDF8",
			},
		},
		custom_filetypes = {}, -- see the extension section to learn how it works
	},
}
