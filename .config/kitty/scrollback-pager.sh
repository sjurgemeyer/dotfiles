#!/usr/bin/env bash
LOG=/tmp/kitty-scrollback-debug.log
export SCROLLBACK='1' 
SCROLLBACK=1 exec /opt/homebrew/bin/nvim --cmd 'set eventignore=FileType' \
--cmd "lua vim.g.scrollback='1';" \
+'nnoremap q ZQ' \
+'call nvim_open_term(0, {})' \
+'set nomodified nolist' \
+'$' - 2>> "$LOG"
