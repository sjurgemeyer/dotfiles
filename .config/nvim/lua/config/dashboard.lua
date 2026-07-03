-- Home screen, built on snacks.nvim's dashboard, which has native support
-- for side-by-side "panes" of content rather than a single vertical stack.

local header_lines = {
	"                                :                                         ",
	"  █.                     ,;     █,                                        ",
	"  ██:         :█       ███    ;███.              █                        ",
	"  ███;        ██     .███    :██:██              ██            ..       : ",
	"  █████      ███    ███,    .██  ,██  █      .██.██,          ,█,     .██ ",
	"  ██████     ███   ███.     ██    ;██ ██:   ,██. ███         ███,    ,███ ",
	"  ███ ███    ███ :██████;  ██.     ██████  ███   ███        ████,   █████ ",
	"  ███  ███.  ███ █████████ :██     ██ ███ ███    ███      .█████,  ██████ ",
	"  ███   ███: ███  .███      ;██   ██. ██████     ███     ;██; ██,:███ ███ ",
	"  ███    ;██,███    ███:     ███ ██:  ████,      ███    ███.  █████,  ███ ",
	"  ███     :█████     ,██;     ████;   ███:       ███  .███    ████:   ███ ",
	"  :██      .████      .██;     ███    ██.        ███ :███     ███.    ███ ",
	"   .█       .███        ██      █     █          ██ ..█       █       .█ ",
	"    :         .█         :      :     :          █.   :                : ",
}

-- Amber-to-indigo gradient, top to bottom.
local header_colors = {
	"#AA7700", "#A86F00", "#A56600", "#A35E00", "#A05500",
	"#9E4D00", "#9B4400", "#993C00", "#973300", "#942B00",
	"#922200", "#8F1A00", "#8D1100", "#8A0900", "#880000",
}
for i, color in ipairs(header_colors) do
	vim.api.nvim_set_hl(0, "DashboardHeaderGrad" .. i, { fg = color })
end

-- snacks has no built-in per-line header coloring. An item's `text` field
-- looks like the way to do it (an array of {line, hl} pairs), but it doesn't
-- actually give each pair its own row -- block() only starts a new row from
-- an embedded "\n" *within* a single text entry, so a list of separate
-- one-line entries all collapse onto one row instead of stacking. Instead,
-- make the header 15 separate items (one per line, via the `header` field)
-- and give `formats.header` a function that reads a custom `grad` field
-- back off the item to choose that line's highlight.
local header_items = {}
for i, line in ipairs(header_lines) do
	header_items[i] = { header = line, grad = i }
end
header_items[#header_items].padding = 2

--- Number of lines "New file" (in pane 1) takes up above row 1, so pane 2's
--- content can be padded down to line up with it: the header, its padding,
--- and the button line itself.
local ROW1_OFFSET = 18

-- setting both `desc` and `file` on an item makes snacks render both
-- (its "center" text block concatenates every field that's present rather
-- than picking one), which would show the desc and the full path together.
-- Since we want a short desc but a real per-filetype icon, look the icon up
-- ourselves and only set `desc` -- the same lookup snacks' own "file" icon
-- marker uses under the hood, via nvim-web-devicons.
local function file_icon(path)
	local ok, icon, hl = pcall(function()
		return require("nvim-web-devicons").get_icon(path, path:match("%.([^.]+)$"), { default = true })
	end)
	return ok and { icon, hl = hl, width = 2 } or nil
end

-- Wrapped in a function so file_icon() runs when the dashboard actually
-- renders, not when this file is first required -- at require-time (while
-- lazy.nvim is still scanning plugin specs) nvim-web-devicons isn't loaded
-- yet, so the lookup would silently fail and every icon would come up blank.
-- snacks runs a ":"-prefixed action via vim.cmd() directly (not as simulated
-- keystrokes), so it must NOT include a trailing "<CR>" -- that would just be
-- literal text appended to the command, e.g. `:e path<CR>` tries to open a
-- file named "...<CR>".
local function bookmarks()
	return {
		{ icon = file_icon("init.lua"), key = "V", desc = "init.lua", action = ":e ~/.config/nvim/init.lua" },
		{ icon = file_icon("init.lua"), key = "P", desc = "plugins/init.lua", action = ":e ~/.config/nvim/lua/plugins/init.lua" },
		{ icon = file_icon(".zshrc"), key = "Z", desc = ".zshrc", action = ":e ~/.zshrc" },
		{ icon = file_icon("kitty.conf"), key = "K", desc = "kitty.conf", action = ":e ~/.config/kitty/kitty.conf" },
	}
end

vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		require("snacks").dashboard.update()
	end,
})

-- nests under the existing "<leader>g" ("[G]it") which-key group in
-- plugins/which.lua. Note this puts a non-git action under the Git group --
-- picked "gd" specifically as requested, over plain "gd" (which is Vim's
-- built-in goto-declaration mapping).
vim.keymap.set("n", "<leader>gd", function()
	require("snacks").dashboard()
end, { desc = "Open Dashboard" })

-- must be >= the header's line width (74 chars): snacks applies a different,
-- per-line centering formula to any rendered line wider than `width`, so a
-- narrower pane here would misalign the header relative to everything else
-- even though the header is internally self-consistent.
local PANE_WIDTH = 74
local PANE_GAP = 4

return {
	width = PANE_WIDTH,
	pane_gap = PANE_GAP,
	formats = {
		header = function(item)
			return { item.header, hl = "DashboardHeaderGrad" .. item.grad }
		end,
	},
	sections = {
		header_items,
		{ icon = " ", desc = "New file", key = "e", action = ":ene", padding = 1 },
		function(self)
			-- so "MRU" (all files) doesn't just repeat what "MRU <cwd>" already
			-- shows, exclude anything in the cwd list -- keeping the same 5-item
			-- limit by filtering rather than slicing the cwd list off the front.
			local cwd_files = {}
			local count = 0
			for file in require("snacks").dashboard.oldfiles({ filter = { [vim.fn.getcwd()] = true } }) do
				cwd_files[file] = true
				count = count + 1
				if count >= 5 then
					break
				end
			end

			-- when the window is too narrow for 2 panes, snacks folds pane 2's
			-- items back into pane 1 (a single stacked column) rather than
			-- erroring or clipping -- but ROW1_OFFSET, which exists purely to
			-- vertically line pane 2 up with row 1 when they're side by side,
			-- would then just be dead space above the second "MRU" section.
			local max_panes = math.max(1, math.floor((self._size.width + PANE_GAP) / (PANE_WIDTH + PANE_GAP)))
			local row1_offset = max_panes > 1 and ROW1_OFFSET or 0

			return {
				{ title = "MRU " .. vim.fn.getcwd(), padding = 1 },
				{ section = "recent_files", cwd = true, limit = 5, padding = 1 },
				{ pane = 2, padding = row1_offset },
				{ pane = 2, title = "MRU", padding = 1 },
				{
					pane = 2,
					section = "recent_files",
					limit = 5,
					filter = function(file)
						return not cwd_files[file]
					end,
					padding = 1,
				},
			}
		end,
		{ title = "Bookmarks", padding = 1 },
		bookmarks,
	},
}
