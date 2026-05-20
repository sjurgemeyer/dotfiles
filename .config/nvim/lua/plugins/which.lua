-- Help text for key bindings
return

	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
		opts = {
			preset = "helix",
		},
		init = function()
			local wk = require("which-key")
			wk.add({
				-- Create heading descriptions
				{ "<leader>c", group = "[C]ode", icon = "󰘦" },
				{ "<leader>d", group = "[D]ocument", icon = "󰈙" },
				{ "<leader>e", group = "[E]xecute", icon = "󰜎" },
				{ "<leader>g", group = "[G]it", icon = "", mode="n" },
				{ "<leader><leader>", group = "Search", icon = "󰍉" },
				{ "<leader>o", group = "[O]cto", icon = "" },
				{ "<leader>p", group = "[P]ull Request", icon = "󰓼" },
				{ "<leader>s", group = "[S]QL", icon="" },
				{ "<leader>t", group = "[T]erminal", icon="" },
				{ "<leader>tg", group = "Lazy[G]it", icon = "󰊢" },
				{ "<leader>tt", group = "[T]erminal", icon = "󰆍" },
				{ "g", group = "[G]o", icon = "󰆾" },
				{ "gr", group = "LSP Commands", icon = "󰅩" },
				{ "t", group = "[T]abs", icon = "󰓉" },
				{ "t_", hidden = true },
				{ "tm", group = "[T]ab [M]ove", icon = "󰁮" },
				{ "tm_", hidden = true },
				{ "vv", group = "Expand code block select", icon = "󰔤" },
				{ "vv_", hidden = true },
			})



			-- Friendly group names for the prefixes octo uses on its
			-- buffer-local mappings. Octo sets `desc` on every leaf keymap, so
			-- which-key auto-discovers those — these entries just give the
			-- intermediate prefixes a label and ensure the popup triggers.
			local octo_groups = {
				a   = "[A]ssignee",
				c   = "[C]omment",
				d   = "[D]iscussion",
				g   = "[G]oto",
				i   = "[I]ssue",
				l   = "[L]abel",
				n   = "[N]otification",
				p   = "[P]ull Request",
				pr  = "Rebase + Merge",
				ps  = "Squash + Merge",
				r   = "[R]eaction / Reference",
				s   = "[S]uggestion",
				v   = "Re[v]iew",
			}

			-- Octo writes buffers with these filetypes. Each maps to one or
			-- more "kinds" in octo.config.values.mappings.
			local kinds_by_filetype = {
				octo = {
					"issue", "pull_request", "discussion",
					"repo", "release", "notification", "review_thread",
				},
				octo_panel = { "file_panel" },
			}

			local function localleader_prefix()
				local ll = vim.g.maplocalleader
				if ll == nil or ll == "" then return "\\" end
				if ll == " " then return "<space>" end
				return ll
			end

			local function register_octo_groups(bufnr)
				local ok, octo_config = pcall(require, "octo.config")
				if not ok then return end
				local kinds = kinds_by_filetype[vim.bo[bufnr].filetype]
				if not kinds then return end

				local mappings = octo_config.values and octo_config.values.mappings
				if not mappings then return end

				local seen = {}
				for _, kind in ipairs(kinds) do
					for _, m in pairs(mappings[kind] or {}) do
						local lhs = m.lhs
						if type(lhs) == "string" then
							local rest = lhs:match("^<localleader>(.+)$")
								or lhs:match("^<LocalLeader>(.+)$")
							if rest then
								for i = 1, math.min(2, #rest) do
									local p = rest:sub(1, i)
									if octo_groups[p] then seen[p] = true end
								end
							end
						end
					end
				end

				local ll = localleader_prefix()
				local entries = {}
				for p in pairs(seen) do
					table.insert(entries, {
						ll .. p,
						group = octo_groups[p],
						buffer = bufnr,
					})
				end
				if #entries > 0 then
					require("which-key").add(entries)
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("which_key_octo", { clear = true }),
				pattern = { "octo", "octo_panel" },
				callback = function(args)
					-- Defer so octo finishes applying its buffer-local
					-- mappings before we register prefix groups against them.
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(args.buf) then
							register_octo_groups(args.buf)
						end
					end)
				end,
			})
		end,
	}
