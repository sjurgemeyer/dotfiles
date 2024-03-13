return {
	"numToStr/Comment.nvim",
	opts = {},

	config = function() -- This is the function that runs, AFTER loading
		require("Comment").setup({
			toggler = {
				---Line-comment toggle keymap
				line = "ccc",
				---Block-comment toggle keymap
				block = "cbc",
			},
			---LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				---Line-comment keymap
				line = "cc",
				---Block-comment keymap
				block = "cb",
			},
			---LHS of extra mappings
			extra = {
				---Add comment on the line above
				above = "ccO",
				---Add comment on the line below
				below = "cco",
				---Add comment at the end of line
				eol = "ccA",
			},
		})
	end,
}
