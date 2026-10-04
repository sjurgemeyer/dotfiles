-- Settings for nvim running inside an SSH session (e.g. on the Synology NAS),
-- where the local kitty instance is on the other end of the connection.
-- Loaded from init.lua only when $SSH_TTY is set.

-- Clipboard: copy to the local machine's clipboard via OSC 52. Paste comes
-- from nvim's own unnamed register instead of an OSC 52 read, because kitty
-- prompts for permission on every clipboard read, which would fire on every
-- `p` with clipboard=unnamedplus.
local osc52 = require("vim.ui.clipboard.osc52")
local function paste_unnamed()
	return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
end
vim.g.clipboard = {
	name = "OSC 52 (copy only)",
	copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
	paste = { ["+"] = paste_unnamed, ["*"] = paste_unnamed },
}

-- kitty.conf passes ctrl+h/j/k/l through to the program only when the window
-- has the user var IS_VIM=true. vim-kitty-navigator sets it with `kitten @`,
-- which can't reach the local kitty over SSH, so set it with the OSC 1337
-- SetUserVar escape instead, which travels over the tty. Values are base64.
local function set_is_vim(b64)
	io.stdout:write("\027]1337;SetUserVar=IS_VIM=" .. b64 .. "\007")
end
local group = vim.api.nvim_create_augroup("remote-kitty-user-var", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
	group = group,
	callback = function()
		set_is_vim("dHJ1ZQ==") -- "true"
	end,
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
	group = group,
	callback = function()
		set_is_vim("ZmFsc2U=") -- "false"
	end,
})
