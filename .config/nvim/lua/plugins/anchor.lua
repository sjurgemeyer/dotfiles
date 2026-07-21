return {
  'zachyarbrough/anchor.nvim',
  opts = {

    picker = 'snacks',        -- 'fzf-lua', 'telescope', 'default' (netrw), 'oil', 'mini', 'snack' or 'auto'
    relative_paths = true, -- Display relative paths in the anchor list
    show_branches = true, -- Show branch names when viewing git worktrees
  },
  config = function()

		      wk = require("which-key")
		      wk.add({
			{"<leader><leader>w", function() require("anchor").toggle_worktrees() end, desc = "Search [W]orktrees", mode="n", icon="" },
		      })
  end
}
