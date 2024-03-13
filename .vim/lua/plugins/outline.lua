-- symbols in file
return {
	"simrat39/symbols-outline.nvim",
	config = function()
		vim.keymap.set("n", "<F6>", ":Outline<CR>", { noremap = true, desc = "Code Outline" })
	end,
}
