colorscheme ororo

set guioptions-=r
set guioptions-=R
set guioptions-=L
set guioptions-=l
:nnoremap <D-CR> :set invfu<CR>

if has("mac")
  set macmeta "use Mac option key as a meta key
  macm File.New\ Tab key=<nop>
  macm File.Close\ Window key=<nop>
  macm Tools.List\ Errors key=<nop>
  macm File.Save key=<nop>
  macm File.Print key=<nop>
endif
