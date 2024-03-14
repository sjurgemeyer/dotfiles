local alpha = require("alpha")
local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable
local divider_line =
	"══════════════════════════════════════════════════════════════════════════════════════════"

local default_header = {
	type = "text",
	val = {
		[[                                                                       ]],
		[[                                                                     ]],
		[[       ████ ██████           █████      ██                     ]],
		[[      ███████████             █████                             ]],
		[[      █████████ ███████████████████ ███   ███████████   ]],
		[[     █████████  ███    █████████████ █████ ██████████████   ]],
		[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
		[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
		[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
		[[                                                                       ]],
	},
	opts = {
		hl = "Directory",
		shrink_margin = false,
		-- wrap = "overflow";
	},
}

local leader = "SPC"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "left",
		shortcut = "[" .. sc .. "] ",
		cursor = 1,
		-- width = 50,
		align_shortcut = "left",
		hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
		shrink_margin = false,
	}
	if keybind then
		keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

local nvim_web_devicons = {
	enabled = true,
	highlight = true,
}

local function get_extension(fn)
	local match = fn:match("^.+(%..+)$")
	local ext = ""
	if match ~= nil then
		ext = match:sub(2)
	end
	return ext
end

local function icon(fn)
	local nwd = require("nvim-web-devicons")
	local ext = get_extension(fn)
	return nwd.get_icon(fn, ext, { default = true })
end

local function file_button(fn, sc, short_fn, autocd)
	short_fn = if_nil(short_fn, fn)
	local ico_txt
	local fb_hl = {}
	if nvim_web_devicons.enabled then
		local ico, hl = icon(fn)
		local hl_option_type = type(nvim_web_devicons.highlight)
		if hl_option_type == "boolean" then
			if hl and nvim_web_devicons.highlight then
				table.insert(fb_hl, { hl, 0, #ico })
			end
		end
		if hl_option_type == "string" then
			table.insert(fb_hl, { nvim_web_devicons.highlight, 0, #ico })
		end
		ico_txt = ico .. "  "
	else
		ico_txt = ""
	end
	local cd_cmd = (autocd and " | cd %:p:h" or "")
	local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
	local fn_start = short_fn:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
	end
	file_button_el.opts.hl = fb_hl
	return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
	ignore = function(path, ext)
		return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
	end,
	autocd = false,
}

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
	opts = opts or mru_opts
	items_number = if_nil(items_number, 10)
	local oldfiles = {}
	for _, v in pairs(vim.v.oldfiles) do
		if #oldfiles == items_number then
			break
		end
		local cwd_cond
		if not cwd then
			cwd_cond = true
		else
			cwd_cond = vim.startswith(v, cwd)
		end
		local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
		if (filereadable(v) == 1) and cwd_cond and not ignore then
			oldfiles[#oldfiles + 1] = v
		end
	end

	local tbl = {}
	for i, fn in ipairs(oldfiles) do
		local short_fn
		if cwd then
			short_fn = fnamemodify(fn, ":.")
		else
			short_fn = fnamemodify(fn, ":~")
		end
		local file_button_el = file_button(fn, tostring(i + start - 1), short_fn, opts.autocd)
		tbl[i] = file_button_el
	end
	return {
		type = "group",
		val = tbl,
		opts = {},
	}
end

local function mru_title()
	return "MRU " .. vim.fn.getcwd()
end

local function create_bookmark(fn, shortcut)
	local short_fn = fnamemodify(fn, ":~")
	return file_button(fn, shortcut, short_fn, false)
end

local function bookmarks_fn()
	local tbl = {
		create_bookmark("~/.config/nvim/init.lua", "I"),
		create_bookmark("~/.config/nvim/lua/plugins/init.lua", "P"),
		create_bookmark("~/.zshrc", "Z"),
		create_bookmark("~/.config/nvim/colors/slater.vim", "C"),
	}
	return {
		type = "group",
		val = tbl,
		opts = {},
	}
end

local section = {
	header = default_header,
	top_buttons = {
		type = "group",
		val = {
			button("e", "New file", "<cmd>ene <CR>"),
		},
	},
	mru = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = "MRU", opts = { hl = "String" } },
			{ type = "text", val = divider_line, opts = { hl = "Directory" } },
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { mru(10) }
				end,
			},
		},
	},
	mru_cwd = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = mru_title, opts = { hl = "String", shrink_margin = false } },
			{ type = "text", val = divider_line, opts = { hl = "Directory" } },
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { mru(0, vim.fn.getcwd()) }
				end,
				opts = { shrink_margin = false },
			},
		},
	},
	bookmarks = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = "Bookmarks", opts = { hl = "String" } },
			{ type = "text", val = divider_line, opts = { hl = "Directory" } },
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { bookmarks_fn() }
				end,
				opts = { shrink_margin = false },
			},
		},
	},
	bottom_buttons = {
		type = "group",
		val = {
			button("q", "Quit", "<cmd>q <CR>"),
		},
	},
	footer = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = divider_line, opts = { hl = "Directory" } },
			{
				type = "text",
				val = require("alpha.fortune")({
					max_width = 100,
					shrink_margin = false,
					fortune_list = require("config/fortune_list"),
				}),
			},
			{ type = "padding", val = 1 },
			{ type = "text", val = divider_line, opts = { hl = "Directory" } },
		},
	},
}

local config = {
	section = section,
	layout = {
		{ type = "padding", val = 1 },
		section.header,
		{ type = "padding", val = 2 },
		section.top_buttons,
		section.mru_cwd,
		section.mru,
		section.bookmarks,
		{ type = "padding", val = 1 },
		section.bottom_buttons,
		section.footer,
	},
	opts = {
		margin = 3,
		redraw_on_resize = false,
		setup = function()
			vim.api.nvim_create_autocmd("DirChanged", {
				pattern = "*",
				group = "alpha_temp",
				callback = function()
					require("alpha").redraw()
					vim.cmd("AlphaRemap")
				end,
			})
		end,
	},
}

alpha.setup(config)
