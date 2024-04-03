return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		vim.keymap.set("n", "<F9>", "<cmd>TroubleToggle<CR>", { desc = "Show Errors" })
	end,
	opts = {},
}
