-- Including all git related-plugins here for consistency, Snacks.nvim has other functionality too
local function buffer_actions(picker)
  local item = picker:current()
  if not item then
    return
  end
  vim.ui.select({ "Open", "Split", "VSplit", "Tab", "Delete" }, {
    prompt = "Buffer Actions",
    snacks = {
      layout = { preset = "select", layout = { max_width = 50 } },
    },
  }, function(choice)
    local actions = {
      Open = "confirm",
      Split = "edit_split",
      VSplit = "edit_vsplit",
      Tab = "tab",
      Delete = "bufdelete",
    }
    if actions[choice] then
      picker:action(actions[choice])
    end
  end)
end

return {
  { "FabijanZulj/blame.nvim" ,
	lazy = false,
		config = function() 
		      require('blame').setup {}
		      wk = require("which-key")
		      wk.add({
			{"<leader>gb", ":BlameToggle window<CR>", desc = "[G]it [B]lame", mode="n", icon="" },
		      })
		end,
    opts = {
      blame_options = { '-w' },
    },
  },
  {"sindrets/diffview.nvim", 
    dependencies = {
      "folke/which-key.nvim",
    },
    config = function()
      wk = require("which-key")
      wk.add({
        {"<leader>go", ":DiffviewOpen<CR>", desc = "[G]it Diff [O]pen (Side by Side)", mode="n", icon="" },
        {"<leader>gc", ":DiffviewClose<CR>", desc = "[G]it Diff [C]lose", mode="n" , icon="" }
      })
    end
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- diff
    -- For a custom log pager
      "m00qek/baleia.nvim",            -- coloring
      "folke/snacks.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    }
  },
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      bufdelete = { },
      dashboard = require("config.dashboard"),
      explorer = {
        trash = true,
      },
      gh = { },
      gitbrowse = { },
      git = {},
      picker = {
        hidden = true,
        -- include gitignore
        ignored = true,
        exclude = { ".git" },
        sources = {
          buffers = {
            win = {
              input = {
                keys = {
                  ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
                  ["?"] = { buffer_actions, mode = { "n", "i" }, desc = "Buffer Actions" },
                },
              },
              list = {
                keys = {
                  ["<c-d>"] = "bufdelete",
                  ["?"] = buffer_actions,
                },
              },
            },
          },
          gh_pr = { },
          explorer = {
            hidden = true,
            -- include gitignore
            ignored = true,
            exclude = { ".git" },
          },
          command_history = { },
          git_branches = {
            confirm = function(picker, item)
              if not item then
                return
              end
              local ref = item.branch or item.commit
              vim.ui.select({ "Checkout", "Diff Against Current" }, {
                prompt = ("git %s"):format(ref),
                snacks = {
                  layout = { preset = "select", layout = { max_width = 50 } },
                },
              }, function(choice)
                if choice == "Checkout" then
                  Snacks.picker.actions.git_checkout(picker, item)
                elseif choice == "Diff Against Current" then
                  picker:close()
                  vim.cmd(("DiffviewOpen %s"):format(ref))
                end
              end)
            end,
          },
          git_log = {
            confirm = function(picker, item)
              if not item then
                return
              end
              vim.ui.select({ "Checkout", "Diff Against Current", "Diff Commit" }, {
                prompt = ("git %s: %s"):format(item.commit, item.msg),
                snacks = {
                  layout = { preset = "select", layout = { max_width = 50 } },
                },
              }, function(choice)
                if choice == "Checkout" then
                  Snacks.picker.actions.git_checkout(picker, item)
                elseif choice == "Diff Against Current" then
                  picker:close()
                  vim.cmd(("DiffviewOpen %s"):format(item.commit))
                elseif choice == "Diff Commit" then
                  picker:close()
                  vim.cmd(("DiffviewOpen %s^!"):format(item.commit))
                end
              end)
            end,
          },
          git_log_file = {
            confirm = function(picker, item)
              if not item then
                return
              end
              -- picker:close()
              vim.ui.select({ "Checkout", "Diff" }, {
                prompt = ("git %s: %s"):format(item.commit, item.msg),
                snacks = {
                  layout = { preset = "select", layout = { max_width = 50 } },
                },
              }, function(choice)
                if choice == "Checkout" then
                  Snacks.picker.actions.git_checkout(picker, item)
                elseif choice == "Diff" then
                  vim.cmd(("DiffviewOpen %s^! -- %s"):format(item.commit, vim.fn.fnameescape(item.file)))
                end
              end)
            end,
          },
        },
        config = function()

          wk = require("which-key")

          wk.add({
            { "<leader>db", function() Snacks.bufdelete() end, desc = "[D]elete [B]uffer", mode="n", icon=""   },
            { "<Tab>", function() Snacks.explorer() end, desc = "File Explorer", mode="n", icon=""   },
            { "<F12>", function() Snacks.explorer.reveal() end, desc = "Open Current File in Explorer", mode="n", icon=""   },
            { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "[G]it [D]iff", mode = "n", icon = "" },
            { "<leader>gh", function() Snacks.gitbrowse.open() end, desc = "[G]it[h]ub Browse", mode="n", icon=""   },
            { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "[G]itHub [P]ull Requests (open)", mode="n", icon=""  },
            { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "[G]itHub [P]ull Requests (all)", mode="n", icon=""   },
            { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "[G]it [F]ile Commits", mode = "n", icon = "" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "[G]it [L]og", mode = "n", icon = "" },
            { "<leader>gr", function() Snacks.picker.git_branches() end, desc = "[G]it B[r]anches", mode = "n", icon = "" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "[G]it [S]tatus", mode = "n", icon = "" },
            { "<leader><leader>.", function() Snacks.picker.recent() end, desc = 'Recent Files ("." for repeat)', mode = "n", icon = "" },
            { "<leader><leader>b", function() Snacks.picker.buffers() end, desc = "Find Open buffers", mode = "n", icon = "󰈙" },
            { "<leader><leader>d", function() Snacks.picker.diagnostics() end, desc = "Search [D]iagnostics", mode = "n", icon = "󰒡" },
            { "<leader><leader>f", function() Snacks.picker.files() end, desc = "Find [F]iles", mode = "n", icon = "󰱼" },
            { "<leader><leader>g", function() Snacks.picker.grep()  end, desc = "Search by [G]rep", mode = "n", icon = "󰍉" },
            { "<leader><leader>h", function() Snacks.picker.help() end, desc = "Find [H]elp topics", mode = "n", icon = "󰘥" },
            { "<leader><leader>k", function() Snacks.picker.keymaps() end, desc = "Search [K]eymaps", mode = "n", icon = "󰌌" },
            { "<leader><leader>n", function() Snacks.picker.notifications() end, desc = "Search [N]otifications", mode = "n", icon = "󰂚" },
            { "<leader><leader>p", function() Snacks.picker.lazy() end, desc = "Find [P]lugin Config", mode = "n", icon = "󰏓" },
            { "<leader><leader>q", function() Snacks.picker.qflist() end, desc = "Search [Q]uickfix", mode = "n", icon = "󰏓" },
            { "<leader><leader>r", function() Snacks.picker.resume() end, desc = "Search [R]esume", mode = "n", icon = "󰑓" },
            { "<leader><leader>s", function() Snacks.picker.search_history() end, desc = "Search Search History", mode = "n", icon = "󰑓" },
            { "<leader><leader>u", function() Snacks.picker.undo() end, desc = "Search [U]ndo tree", mode = "n", icon = "󰕍" },
            { "<leader><leader>v", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search [N]eovim config", mode = "n", icon = "" },
            { "<leader><leader>*", function() Snacks.picker.grep_word() end, desc = "Search current Word", mode = "n", icon = "󰬶" },
            { "<leader><leader>w", function() Snacks.picker.worktrees() end, desc = "Search [W]orktrees", mode = "n", icon = "󰬶" },
            { "<leader><leader>y", function() Snacks.picker.registers() end, desc = "Search Registers", mode = "n", icon = "󰑓" },
            { "<leader><leader>;", function() Snacks.picker.command_history() end, desc = "Search Command History", mode = "n", icon = "󰑓" },

            -- { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
            -- find
            -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
            -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
            -- gh
            -- Grep
            -- search
            -- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
            -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
            -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
            -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
            -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
            -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
            -- -- LSP
            -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
            -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
            -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
            -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
          })
        end
      },
      image = {
        enabled = true,
        backend = "kitty",
      },
    },

  },
}
