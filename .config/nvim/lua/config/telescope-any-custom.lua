local function create_default_config()
	local builtin = require("telescope.builtin")
	local frecency = require("telescope").extensions.frecency.frecency
	local git_file_history = require("telescope").extensions.git_file_history.git_file_history
	local undo = require("telescope").extensions.undo.undo
	local lazy_plugins = require("telescope").extensions.lazy_plugins.lazy_plugins
	return {
		pickers = {
			[":"] = { cmd = builtin.current_buffer_fuzzy_find, desc = "Find in Current Buffer" },
			["/"] = { cmd = builtin.live_grep, desc = "Live Grep" },

			["h "] = { cmd = builtin.help_tags, desc = "Help Tags" },
			["m "] = { cmd = builtin.marks, desc = "Marks" },
			["q "] = { cmd = builtin.quickfix, desc = "Quickfix" },
			["l "] = { cmd = builtin.loclist, desc = "Location List" },
			["j "] = { cmd = builtin.jumplist, desc = "Jump List" },

			["man "] = { cmd = builtin.man_pages, desc = "Man pages" },
			["options "] = { cmd = builtin.vim_options, desc = "VIM Options" },
			["keymaps "] = { cmd = builtin.keymaps, desc = "Keymaps" },

			["colorscheme "] = { cmd = builtin.colorscheme, desc = "Color schemes" },
			["colo "] = { cmd = builtin.colorscheme, desc = "Color Schemes" },

			["com "] = { cmd = builtin.commands, desc = "Commaands" },
			["command "] = { cmd = builtin.commands, desc = "Commaands" },

			["au "] = { cmd = builtin.autocommands, desc = "Autocommands" },
			["autocommand "] = { cmd = builtin.autocommands, desc = "Autocommands" },

			["highlight "] = { cmd = builtin.highlights, desc = "Highlight groups" },
			["hi "] = { cmd = builtin.highlights, desc = "Highlight groups" },

			["ctags "] = { cmd = builtin.current_buffer_tags, desc = "Ctags in Current Buffer" },

			["o "] = { cmd = builtin.oldfiles, desc = "Recent Files" },
			["b "] = { cmd = builtin.buffers, desc = "Buffers" },

			["gs "] = { cmd = builtin.git_status, desc = "Git Status" },
			["gb "] = { cmd = builtin.git_branches, desc = "Git Branches" },
			["gc "] = { cmd = builtin.git_commits, desc = "Git Commits" },

			["d "] = { cmd = builtin.diagnostics, desc = "LSP Diagnostics" },
			["@"] = { cmd = builtin.lsp_document_symbols, desc = "LSP Symbols" },

			[""] = { cmd = builtin.find_files, desc = "File names" },

			-- custom stuff

			-- LSP searches
			["def "] = { cmd = builtin.lsp_definitions, desc = "LSP Definition" },

			-- Find references for the word under your cursor.
			["ref"] = { cmd = builtin.lsp_references, desc = "LSP References" },

			-- Jump to the implementation of the word under your cursor.
			--  Useful when your language has ways of declaring types without an actual implementation.
			["impl"] = { cmd = builtin.lsp_implementations, desc = "LSP Implementation" },

			-- Jump to the type of the word under your cursor.
			--  Useful when you're not sure what type a variable is and you want to see
			--  the definition of its *type*, not where it was *defined*.
			["types"] = { cmd = builtin.lsp_type_definitions, desc = "LSP Type Definition" },

			-- Fuzzy find all the symbols in your current document.
			--  Symbols are things like variables, functions, types, etc.
			["symbols"] = { cmd = builtin.lsp_document_symbols, desc = "LSP Document Symbols" },

			-- Fuzzy find all the symbols in your current workspace
			--  Similar to document symbols, except searches over your whole project.
			["wssymbols"] = { cmd = builtin.lsp_dynamic_workspace_symbols, desc = "LSP Workspace Symbols" },

			-- plugin additions
			["f "] = { cmd = frecency, desc = "Frecency" },

			-- TODO Can't get context of current file
			-- ["g "] = { cmd = git_file_history, desc = "git file history" },
			--

			-- TODO Can't get context of current file
			-- ["u "] = { cmd = undo, desc = "Undo Tree" },

			-- TODO This one takes over the prompt and I haven't figure dout how to make it give it back yet
			-- ["p "] = { cmd = lazy_plugins, desc = "Plugin config" },
		},
	}
end

local function split_pickers(pickers)
	local default_picker = pickers[""].cmd
	pickers[""] = nil
	return pickers, default_picker
end

local function parse_input(input, pickers, default_picker)
	for prefix, picker in pairs(pickers) do
		if input:sub(1, #prefix) == prefix then
			return picker.cmd, input:sub(#prefix + 1, #input)
		end
	end
	return default_picker, input
end
local function pad_right(str, len)
	return string.format("%-" .. len .. "s", str)
end

local function create_picker_list_fn(pickers)
	local output_list = {}
	for key, value in pairs(pickers) do
		table.insert(output_list, pad_right(key, 20) .. value.desc)
	end
	table.sort(output_list)
	return output_list
end

local function create_prefix_help_picker(prefixes)
	return function(opts)
		local Picker = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local picker_list = create_picker_list_fn(prefixes)
		Picker:new({
			prompt_title = "Any",
			finder = finders.new_table({ results = picker_list }),
			sorter = conf.generic_sorter(opts),
			on_input_filter_cb = opts.on_input_filter_cb,
			default_text = opts.default_text,
			bufnr = opts.bufnr,
			winnr = opts.winnr,
		}):find()
	end
end

local function create_telescope_any(opts)
	opts.pickers = create_default_config().pickers
	-- if opts == nil or vim.tbl_count(opts) == 0 then
	-- 	opts = create_default_config()
	-- end
	local pickers, default_picker = split_pickers(opts.pickers or {})
	local prefix_help_picker = create_prefix_help_picker(opts.pickers)
	local prev_input = ""
	local prev_picker = prefix_help_picker

	local function apply_picker(picker, opts)
		vim.schedule(function()
			local success, ret = pcall(picker, opts)
			if success then
				prev_picker = picker
			else
				prev_picker = default_picker
				opts.default_text = ""
				opts.prompt_title = ret
				default_picker(opts)
			end
		end)
	end

	local function apply_picker_current(picker, func, text)
		-- opts["winnr"] = vim.api.nvim_get_current_win()
		-- opts["bufnr"] = vim.api.nvim_get_current_buf()
		opts["on_input_filter_cb"] = func
		opts["default_text"] = text

		return apply_picker(picker, opts)
	end

	return function()
		local on_input_filter_cb
		on_input_filter_cb = function(input)
			prev_input = input
			local curr_picker, text
			if #input == 0 then
				curr_picker, text = prefix_help_picker, input
			else
				curr_picker, text = parse_input(input, pickers, default_picker)
			end

			if curr_picker ~= prev_picker then
				apply_picker_current(curr_picker, on_input_filter_cb, input)
			else
				return { prompt = text }
			end
		end

		apply_picker_current(prev_picker, on_input_filter_cb, prev_input)
	end
end

local telescope_any = create_telescope_any({
	winnr = vim.api.nvim_get_current_win(),
	bufnr = vim.api.nvim_get_current_buf(),
})
vim.api.nvim_set_keymap("n", "<leader><leader>", "", {
	noremap = true,
	silent = true,
	callback = telescope_any,
})
