" set shell=/bin/zsh\ -i
filetype off
set nocompatible
call pathogen#infect()
filetype off
syntax on
filetype plugin indent on
set shell=/bin/bash\ -li
" set modelines=0
set number
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set path+=**
set encoding=utf-8
set scrolloff=20
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
" set relativenumber
set undofile
"set winwidth=120
set wildignore+=*.class,.git,.hg,.svn,test-integration/**,test-unit/**,**/target/**

set tags=./.tags
let mapleader = ","
let g:mapleader = ","
let g:vim_terminal="/dev/ttys000"
let g:run_script = "!osascript ~/.vim/tools/run_command.applescript" 

set ic
set hls
set clipboard=unnamed

" open vertical window and switch to it
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <D-d> <C-w>v<C-w>l
nnoremap <leader>s <C-w>s<C-w>j
nnoremap <D-D> <C-w>s<C-w>j

"switch windows
map <D-l> <Esc><C-w><C-w>

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set undodir=~/.vim/undo

colorscheme shaun

"supertab
set completeopt=menu,longest
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'
let g:SuperTabLongestEnhanced = 1

"quick switch to last edited file (Using buffergator)
map <C-tab> <C-^>
"Skip over one
map <A-tab> <Esc>,bjj<CR>

"NERDTree
map <F2> <Esc>:NERDTreeToggle<CR>
map <F4> <Esc>:TlistToggle<CR>
nmap <F3> :TagbarToggle<CR>
map <A-F1> <Esc>:NERDTreeFind<CR>

"EasyGrep
let g:EasyGrepMode=2
let g:EasyGrepCommand=0
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=1

"CtrlP
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'rtscript']
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*|.*/target/.*' 

"YankRing
map <Leader>a :YRShow<CR>
map <Leader>\ :s/^\(.*\)$/\/\/\1/<CR><Esc>:nohlsearch<CR>
map <Leader>- :s/^\/\/\(.*\)$/\1/<CR><Esc>:nohlsearch<CR>

"Manipulate a comma seperated list"
vmap <D-[> :s/,\s*/,\r/g<CR>
vmap <D-]> :s/,\n/, /g<CR>

"clear current highlighting
map <C-c> :nohlsearch<CR>

"Toggle case (UPPER, lower, Mixed) for visual selection
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction

vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv

"Hex mode
" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

"Resize windows
map <C-S-Left> 8<C-w>>
map <C-S-Up> 4<C-w>+
map <C-S-Down> 4<C-w>-
map <C-S-Right> 8<C-w><
" Full screen
map <D-CR> <C-w>o

"Vimdiff 3 way merge in hg
" map <D-1> :diffget orig<CR>
" map <D-2> :diffget other<CR>
" map <D-3> :diffget base<CR>

map <D-k> [c
map <D-j> ]c

"Clojure
let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1
" this should only be necessary if you don't have the ng client in your PATH
let vimclojure#NailgunClient = "/Users/sjurgemeyer/Dropbox/bin/ng"
let vimclojure#WantNailgun = 1

function! RunInVim(command)
    silent execute ":Clam " . a:command
endfunction

"Fitnesse
command! Fit :call Fit()
function! Fit()
    :set syntax=fitnesse
endfunction

"visual mode find selection
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

vmap ,w :Align \|<CR>

" command line shortcuts use Clam plugin
nnoremap ! :Clam<space>
vnoremap ! :ClamVisual<space>

map <D-0> :GundoToggle

let g:syntastic_mode_map = { 'mode': 'passive',
                               \ 'active_filetypes': [],
                               \ 'passive_filetypes': ['groovy'] }

let g:splice_initial_diff_grid=1

function! RemoveSwapFile()
    let backupdir = &backupdir
    let file = expand("%:t:r")
    :execute "!rm " . backupdir . "/" . file . ".sw*"
endfunction
command! RemoveSwapFile :call RemoveSwapFile()

function! LookupJavadoc()
    let word = expand("<cword>")
    :execute "!open https://www.google.com/search?q=" . word . "+javadoc"
endfunction 
command! LookupJavadoc :call LookupJavadoc()
map <A-j> <Esc>:LookupJavadoc<CR>

let g:buffergator_sort_regime="mru"
let g:tagbar_type_groovy= {
    \ 'ctagstype' : 'groovy',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 'f:function',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }

"NerdCOmmenter
let NERDCreateDefaultMappings=0
map <leader>/ <plug>NERDCommenterToggle

"Shortcuts to change background color
command! Green :colorscheme shaun-green
command! Red :colorscheme shaun-red
command! Blue :colorscheme shaun-blue
command! Black :colorscheme shaun
command! Ses :mks! ~/session.vim

"Powerline
let g:Powerline_symbols='unicode'
let g:Powerline_stl_path_style='full'
