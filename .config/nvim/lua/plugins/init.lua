return {
  "mikesmithgh/kitty-scrollback.nvim", {},
  "knubie/vim-kitty-navigator", {}, 
  "navarasu/onedark.nvim", {},
  -- better completion windows
  "onsails/lspkind.nvim",
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- window resize mode with C-e
  "simeji/winresizer",
  -- rainbow brances
  "HiPhish/rainbow-delimiters.nvim",
  -- switch between cases
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
  --     -- Giving shortcuts better labels
      local wk = require("which-key")
      wk.add({
        -- Create heading descriptions
        { "ga", group = "Case Manipulation", icon = "" },
        { "gac", name = "camelCase", icon = "" },
        { "gaC", group = "camelCase (LSP)", icon = "" },
        { "gad", group = "dash-case", icon = "" },
        { "gaD", group = "dash-case (LSP)", icon = "" },
        { "gal", group = "lower case", icon = "󰬵" },
        { "gaL", group = "lower case (LSP)", icon = "󰬵" },
        { "gan", group = "CONSTANT_CASE", icon = "" },
        { "gaN", group = "CONSTANT_CASE (LSP)", icon = "" },
        { "gap", group = "PascalCase", icon = "" },
        { "gaP", group = "PascalCase (LSP)", icon = "" },
        { "gas", group = "snake_case", icon = "" },
        { "gaS", group = "snake_case (LSP)", icon = "" },
        { "gau", group = "UPPER CASE", icon = "" },
        { "gaU", group = "UPPER CASE (LSP)", icon = "" },
      })
    end,
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
  },
  -- Autoformat
  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        sqlfluff = {
          -- dbt's templater can't read from stdin, so write the
          -- buffer to disk and format the real file instead.
          stdin = false,
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use sqlfluff when the project enforces it (dbt projects with a
        -- .sqlfluff config), otherwise fall back to sqlfmt, which is
        -- Jinja-safe but doesn't understand a dbt project's own rules.
        sql = function(bufnr)
          if vim.fs.root(bufnr, { ".sqlfluff" }) then
            return { "sqlfluff" }
          end
          return { "sqlfmt" }
        end,
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  -- Highlight todo, notes, etc in comments
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
  -- Collection of various small independent plugins/modules
  {
    "nvim-mini/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]parenthen
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.misc").setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()
    end,
  },
  -- Highlight, edit, and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",

    init = function()
      -- Enable highlighting and indentation via built-in treesitter
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Incremental selection keymaps (using Neovim 0.12 built-in)
      vim.keymap.set("v", "v", "an", { remap = true, desc = "Expand treesitter selection" })
      vim.keymap.set("v", "V", "in", { remap = true, desc = "Shrink treesitter selection" })
    end,
  },
  -- fancy UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
}
