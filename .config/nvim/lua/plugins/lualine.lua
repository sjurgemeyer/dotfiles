return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_theme = {
			normal = {
				a = { fg = "#FFFFFF", bg = "#608B4E", gui = "bold" },
				b = { fg = "#FFFFFF", bg = "#4D6F3E" },
				c = { fg = "#FFFFFF", bg = "#415D34" },
			},
			visual = {
				a = { fg = "#FFFFFF", bg = "#D16969", gui = "bold" },
				b = { fg = "#FFFFFF", bg = "#9C4F4F" },
				c = { fg = "#FFFFFF", bg = "#7C3F3F" },
			},
			inactive = {
				a = { fg = "#FFFFFF", bg = "#3C3C3C", gui = "bold" },
				b = { fg = "#FFFFFF", bg = "#3C3C3C" },
				c = { fg = "#FFFFFF", bg = "#3C3C3C" },
			},
			replace = {
				a = { fg = "#000000", bg = "#D4D4D4", gui = "bold" },
				b = { fg = "#000000", bg = "#BBBBBB" },
				c = { fg = "#000000", bg = "#999999" },
			},
			insert = {
				a = { fg = "#FFFFFF", bg = "#569CD6", gui = "bold" },
				b = { fg = "#FFFFFF", bg = "#4278A5" },
				c = { fg = "#FFFFFF", bg = "#356085" },
			},
			terminal = {
				a = { fg = "#FFFFFF", bg = "#C586C0" },
				b = { fg = "#FFFFFF", bg = "#7A5377" },
				c = { fg = "#FFFFFF", bg = "#61425E" },
			},
		}
		local function toggleterm_statusline()
			return vim.b.display_name
		end
		local my_extension = {
			sections = { lualine_a = { "mode" }, lualine_b = { toggleterm_statusline } },
			filetypes = { "toggleterm" },
		}
		require("lualine").setup({ options = { theme = custom_theme }, extensions = { "neo-tree", my_extension } })
	end,
}
