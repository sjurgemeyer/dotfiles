return {
    "Juksuu/worktrees.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",         -- required
      "folke/snacks.nvim",
    },
    init = function()
          require("worktrees").setup()
    end,
    config = function()
    end,
}
