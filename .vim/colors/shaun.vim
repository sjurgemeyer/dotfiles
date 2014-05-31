" Maintainer:	Lars H. Nielsen (dengmao@gmail.com)
" Last Change:	January 22 2007

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "shaun"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine   guibg=#242424 guifg=NONE    gui=NONE ctermfg=NONE  ctermbg=darkgray cterm=NONE
  hi CursorColumn guibg=#2d2d2d guifg=NONE    gui=NONE ctermfg=black ctermbg=darkgray cterm=NONE
  hi ColorColumn  guibg=#2d2d2d guifg=NONE    gui=NONE ctermfg=NONE  ctermbg=darkgray cterm=NONE
  hi MatchParen   guifg=#f6f3e8 guibg=#457bcf gui=bold ctermfg=white ctermbg=blue     cterm=bold
  hi Pmenu        guifg=#f6f3e8 guibg=#444444 gui=NONE ctermfg=white ctermbg=darkgray cterm=NONE
  hi PmenuSel     guifg=#000000 guibg=#0f4a68 gui=NONE ctermfg=black ctermbg=darkblue cterm=NONE
endif

" General color
hi Cursor       guifg=NONE    guibg=#858585 gui=NONE ctermfg=black      ctermbg=white    cterm=reverse
hi Normal       guifg=#f6f3e8 guibg=#000000 gui=NONE ctermfg=white      ctermbg=black    cterm=NONE
hi NonText      guifg=#808080 guibg=#000000 gui=NONE ctermfg=NONE      ctermbg=black    cterm=NONE
hi LineNr       guifg=#857b6f guibg=#000000 gui=NONE ctermfg=lightgray ctermbg=black    cterm=NONE
hi StatusLine   guifg=#000000 guibg=#457bcf gui=bold ctermfg=NONE      ctermbg=blue    cterm=bold
hi StatusLineNC guifg=#857b6f guibg=#222222 gui=NONE ctermfg=lightgray ctermbg=NONE    cterm=NONE
hi VertSplit    guifg=#999999 guibg=#000000 gui=NONE ctermfg=lightgray ctermbg=NONE    cterm=NONE
hi Folded       guibg=#121212 guifg=#00FF00 gui=NONE ctermfg=lightgray ctermbg=NONE    cterm=NONE
hi Title        guifg=#f6f3e8 guibg=NONE    gui=bold ctermfg=white      ctermbg=NONE    cterm=bold
hi Visual       guifg=#f6f3e8 guibg=#444444 gui=NONE ctermfg=NONE      ctermbg=darkgray    cterm=NONE
hi SpecialKey   guifg=#808080 guibg=#343434 gui=NONE ctermfg=NONE      ctermbg=NONE    cterm=NONE
hi ErrorMsg     guifg=#ffffff guibg=#a5382d gui=NONE ctermfg=NONE      ctermbg=darkred cterm=NONE
hi Directory    guifg=#8ac6f2 guibg=NONE    gui=NONE ctermfg=lightblue ctermbg=NONE    cterm=NONE
hi Search       guifg=#000000 guibg=#dfb700 gui=NONE ctermfg=black      ctermbg=yellow cterm=NONE
hi Error        guifg=NONE    guibg=#ff0000 gui=NONE ctermfg=NONE      ctermbg=red     cterm=NONE term=standout

" Syntax highlighting
hi Comment    guifg=#99968b guibg=NONE    gui=italic ctermfg=gray       ctermbg=black    cterm=NONE
hi Todo       guifg=#ffffff guibg=#0f4a68 gui=italic ctermfg=NONE       ctermbg=darkblue cterm=NONE
hi Constant   guifg=#e5786d guibg=NONE    gui=NONE   ctermfg=red        ctermbg=NONE     cterm=NONE
hi String     guifg=#95e454 guibg=NONE    gui=italic ctermfg=green      ctermbg=NONE     cterm=NONE
hi Identifier guifg=#cae682 guibg=NONE    gui=NONE   ctermfg=green      ctermbg=NONE     cterm=NONE
hi Function   guifg=#cae682 guibg=NONE    gui=NONE   ctermfg=lightgreen ctermbg=NONE     cterm=NONE
hi Type       guifg=#cae682 guibg=NONE    gui=NONE   ctermfg=lightgreen ctermbg=NONE     cterm=NONE
hi Statement  guifg=#8ac6f2 guibg=NONE    gui=NONE   ctermfg=lightblue  ctermbg=NONE     cterm=NONE
hi Keyword    guifg=#8ac6f2 guibg=NONE    gui=NONE   ctermfg=lightblue  ctermbg=NONE     cterm=NONE
hi PreProc    guifg=#e5786d guibg=NONE    gui=NONE   ctermfg=red        ctermbg=NONE     cterm=NONE
hi Number     guifg=#e5786d guibg=NONE    gui=NONE   ctermfg=red        ctermbg=NONE     cterm=NONE
hi Special    guifg=#b7c6aa guibg=NONE    gui=NONE   ctermfg=lightgreen ctermbg=NONE     cterm=NONE

" Diff colors
hi DiffAdd    guifg=#ffffff guibg=#257404 gui=NONE ctermfg=NONE ctermbg=darkgreen cterm=NONE
hi DiffDelete guifg=#ffffff guibg=#a5382d gui=NONE ctermfg=NONE ctermbg=darkred   cterm=NONE
hi DiffChange guifg=#ffffff guibg=#0f4a68 gui=NONE ctermfg=NONE ctermbg=darkblue  cterm=NONE
hi DiffText   guifg=#ffffff guibg=#3a76a2 gui=NONE ctermfg=NONE ctermbg=blue      cterm=NONE
