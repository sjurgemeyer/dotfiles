-- Ensure Homebrew binaries are available (for rg, etc.)
vim.env.PATH = "/opt/homebrew/bin:" .. "/Users/sjurgemeyer/Library/Python/3.9/bin:" .. vim.env.PATH

-- Register a named server socket so external tools (e.g. the Raycast nvim-file-search
-- extension) can open files here via: nvim --server /tmp/nvim.sock --remote-tab <file>
--vim.fn.serverstart("/tmp/nvim.sock")

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.wo.wrap = false
-- Make line numbers default
vim.opt.number = true
vim.o.confirm = true

-- Override :bd to use Snacks.bufdelete()
vim.api.nvim_create_user_command("SnacksBd", function(opts)
  require("snacks").bufdelete()
end, { nargs = "*" })
-- Wark around since user commands can't directly override lowercase names. This expands bd to a different command
vim.cmd([[cnoreabbrev <expr> bd (getcmdtype() == ':' && getcmdline() == 'bd') ? 'SnacksBd' : 'bd']])

-- Global indentation defaults
vim.opt.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true
-- vim.opt.guicursor = "a:ver25"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>ce", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
vim.api.nvim_set_keymap("n", ":", ";", { noremap = true })
vim.api.nvim_set_keymap("v", ";", ":", { noremap = true })
vim.api.nvim_set_keymap("v", ":", ";", { noremap = true })
vim.api.nvim_set_keymap("v", "<F5>", ":SnipRun<CR>", { noremap = true, silent = false, desc = "Execute code" })
vim.api.nvim_set_keymap("n", "<F5>", ":%SnipRun<CR>", { noremap = true, silent = false, desc = "Execute code" })
vim.api.nvim_set_keymap(
	"n",
	"<F7>",
	":SnipClose<CR>",
	{ noremap = true, silent = false, desc = "Close code execution window" }
)
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--
-- vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])

vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
-- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]])
vim.keymap.set("t", "<C-e>", [[<Cmd>WinResizerStartResize<CR>]])

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.wo.wrap = true
		vim.wo.linebreak = true
	end,
})
-- j and k work for wrapped lines
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
vim.cmd("colorscheme oasis-starlight")
-- require('onedark').setup {
--     style = 'darker'
-- }
-- require('onedark').load()
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
	print('scrollback is:', vim.g.scrollback)
	print('SCROLLBACK is:', vim.env.SCROLLBACK)
	if vim.g.scrollback == "1" then
	    vim.cmd("colorscheme oasis-canyon")
	end
    end,
})
--
vim.opt.termguicolors = true
-- Open current markdown file in Obsidian
vim.keymap.set("n", "<leader>oo", function()
    local path = vim.fn.expand("%:p")
    if vim.bo.filetype ~= "markdown" then
        vim.notify("Not a markdown file", vim.log.levels.WARN)
        return
    end
    local encoded_path = path:gsub(" ", "%%20")
    vim.fn.system({ "open", "obsidian://open?path=" .. encoded_path })
end, { desc = "Open in [O]bsidian" })

-- LSP keymaps, set globally (not scoped to LspAttach). Neovim ships several
-- of these as built-in defaults (gd is not one of them, but gD/gri/grt/grr/
-- gO/grn/gra/grx are) and registers them globally, not per-buffer, with a
-- `desc` that's just the Lua call itself (e.g. "vim.lsp.buf.references()").
-- Since those globals exist in every buffer regardless of whether an LSP
-- client is attached, a buffer-local override only wins in buffers that
-- have actually seen an LspAttach — everywhere else the ugly built-in text
-- still shows in which-key. Mapping globally overrides the
-- built-ins everywhere; the underlying vim.lsp.buf functions already no-op
-- gracefully when no client is attached.
local function lsp_map(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, { desc = "LSP: " .. desc })
end

-- Go-to navigation
lsp_map("n", "gd", vim.lsp.buf.definition, "Go to definition")
lsp_map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
lsp_map("n", "gri", vim.lsp.buf.implementation, "Go to implementation")
lsp_map("n", "grt", vim.lsp.buf.type_definition, "Go to type definition")
lsp_map("n", "grr", vim.lsp.buf.references, "Go to references")
lsp_map("n", "gO", vim.lsp.buf.document_symbol, "Document symbols")
lsp_map("n", "grw", vim.lsp.buf.workspace_symbol, "Workspace symbols")
lsp_map("n", "grx", vim.lsp.codelens.run, "Run code lens")

-- Actions
lsp_map("n", "grn", vim.lsp.buf.rename, "Rename")
lsp_map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
lsp_map({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action")
lsp_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
lsp_map("n", "<leader>cf", vim.lsp.buf.format, "Format buffer")
lsp_map("n", "<leader>ci", vim.lsp.buf.incoming_calls, "Incoming calls")
lsp_map("n", "<leader>co", vim.lsp.buf.outgoing_calls, "Outgoing calls")

-- Docs / signatures
lsp_map("n", "K", vim.lsp.buf.hover, "Hover documentation")
lsp_map("n", "<leader>ck", vim.lsp.buf.signature_help, "Signature help")
lsp_map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")

-- Diagnostics
lsp_map("n", "<leader>de", vim.diagnostic.open_float, "Line diagnostics")

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- If using nvim-cmp, extend capabilities (optional)
-- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use the function call form to MERGE (not replace) the config
vim.lsp.config('markdown_oxide', {
    -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
    -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
    capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        }
    ),
})
vim.lsp.enable('markdown_oxide')
vim.lsp.enable('pyright')

-- dbt Language Server: https://github.com/j-clemons/dbt-language-server
-- No built-in nvim config for this one, so cmd/filetypes/root_markers are
-- defined here in full rather than just enabled.
vim.lsp.config('dbt', {
    cmd = { 'dbt-language-server' },
    filetypes = { 'sql', 'yaml' },
    root_markers = { 'dbt_project.yml' },
})
vim.lsp.enable('dbt')
