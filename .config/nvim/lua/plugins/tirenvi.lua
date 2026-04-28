return {
  "kibi2/tirenvi.nvim",
  dependencies = {
    "tpope/vim-repeat", -- optional: enables '.' repeat for column width operations
  },
  config = function()
    require("tirenvi").setup {}
  end,
}
