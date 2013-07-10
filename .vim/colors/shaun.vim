" Maintainer:	Lars H. Nielsen (dengmao@gmail.com)
" Last Change:	January 22 2007

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "wombat"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine guibg=#242424
  hi CursorColumn guibg=#2d2d2d
  hi ColorColumn guibg=#2d2d2d
  hi MatchParen guifg=#f6f3e8 guibg=#457bcf gui=bold
  hi Pmenu 		guifg=#f6f3e8 guibg=#444444
  hi PmenuSel 	guifg=#000000 guibg=#0f4a68 
endif

" General colors
hi Cursor 		guifg=NONE    guibg=#858585 gui=none
hi Normal 		guifg=#f6f3e8 guibg=#000000 gui=none
hi NonText 		guifg=#808080 guibg=#000000 gui=none
hi LineNr 		guifg=#857b6f guibg=#000000 gui=none
hi StatusLine 	guifg=#000000 guibg=#457bcf gui=bold
hi StatusLineNC guifg=#857b6f guibg=#222222 gui=none
hi VertSplit 	guifg=#999999 guibg=#000000 gui=none
hi Folded 		guibg=#121212 guifg=#00FF00 gui=none
hi Title		guifg=#f6f3e8 guibg=NONE	gui=bold
hi Visual		guifg=#f6f3e8 guibg=#444444 gui=none
hi SpecialKey	guifg=#808080 guibg=#343434 gui=none
hi ErrorMsg	    guifg=#ffffff guibg=#a5382d gui=none
hi Directory	guifg=#8ac6f2 gui=none
hi Search       guifg=#000000 guibg=#dfb700 gui=none
hi Error        term=standout guibg=#ff0000

" Syntax highlighting
hi Comment 		guifg=#99968b gui=italic
hi Todo 		guifg=#ffffff guibg=#0f4a68 gui=italic
hi Constant 	guifg=#e5786d gui=none
hi String 		guifg=#95e454 gui=italic
hi Identifier 	guifg=#cae682 gui=none
hi Function 	guifg=#cae682 gui=none
hi Type 		guifg=#cae682 gui=none
hi Statement 	guifg=#8ac6f2 gui=none
hi Keyword		guifg=#8ac6f2 gui=none
hi PreProc 		guifg=#e5786d gui=none
hi Number		guifg=#e5786d gui=none
hi Special		guifg=#b7c6aa gui=none

" Diff colors
hi DiffAdd      guifg=#ffffff guibg=#257404 gui=none
hi DiffDelete   guifg=#ffffff guibg=#a5382d gui=none 
hi DiffChange   guifg=#ffffff guibg=#0f4a68 gui=none 
hi DiffText     guifg=#ffffff guibg=#3a76a2 gui=none 
