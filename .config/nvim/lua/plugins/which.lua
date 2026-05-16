-- Help text for key bindings
return

	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Sets the loading event to 'VeryLazy'
		spec= {
			-- Create heading descriptions
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>e", group = "[E]xecute" },
			{ "<leader>g", group = "[G]o" },
			{ "<leader><leader>", group = "Search" },
			{ "<leader>o", group = "[O]cto"},
			{ "<leader>p", group = "[P]ull Request"},
			{ "<leader>t", group = "[T]erminal" },
			{ "<leader>tg", group = "Lazy[G]it" },
			{ "<leader>tt", group = "[T]erminal" },
			{ "t", group = "[T]abs" },
			{ "t_", hidden = true },
			{ "tm", group = "[T]ab [M]ove" },
			{ "tm_", hidden = true },
			{ "vv", group = "Expand code block select" },
			{ "vv_", hidden = true },
		},
		opts = {
			preset = "helix",
		},
		init = function()
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
