set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'vcscommand.vim'
Bundle 'Lokaltog/vim-powerline.git'
Bundle 'kien/ctrlp.vim.git'
" Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'sjl/clam.vim.git'
Bundle 'sjl/gundo.vim.git'
Bundle 'sjl/splice.vim'
Bundle 'tpope/vim-abolish.git'
Bundle 'vim-scripts/VimClojure.git'
Bundle 'jeetsukumaran/vim-buffergator.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'AndrewRadev/linediff.vim'
Bundle 'Shougo/neocomplcache.git'
Bundle 'Align'
Bundle 'EasyGrep'
" Bundle 'YankRing.vim'
Bundle 'ZoomWin'
Bundle 'hgrev'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'slimv.vim'

syntax on
filetype plugin indent on
" set shell=/bin/bash\ -li

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
set autoread 
set shiftround
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
set macmeta "use Mac option key as a meta key
" set relativenumber
set undofile
"set winwidth=119
set wildignore+=*.class,.git,.hg,.svn,test-integration/**,test-unit/**,**/target/**
set guifont=Source\ Code\ Pro\ Semibold:h13
set diffopt=filler,vertical

set tags=./.tags
let mapleader = ","
let g:mapleader = ","
let g:vim_terminal="/dev/ttys000"
let g:run_script = "!osascript ~/.vim/tools/run_command.applescript" 

set ic
set smartcase
set incsearch 
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
" set completeopt=menu,longest
" let g:SuperTabMappingForward = '<c-space>'
" let g:SuperTabMappingBackward = '<s-c-space>'
" let g:SuperTabLongestEnhanced = 1

"quick switch to last edited file (Using buffergator)
map <C-tab> <C-^>
"Skip over one
map <A-tab> <Esc>,bjj<CR>

"NERDTree
map <F2> <Esc>:NERDTreeToggle<CR>
map <F4> <Esc>:TlistToggle<CR>
nmap <F3> :TagbarToggle<CR>
map <A-F1> <Esc>:NERDTreeFind<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1

"Close all navigation windows
map <F13> :call CloseNavigation()<CR>
function! CloseNavigation()
    :BuffergatorClose
    :NERDTreeClose
    :ccl
endfunction

"EasyGrep
let g:EasyGrepMode=2
let g:EasyGrepCommand=0
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=1

"CtrlP
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'rtscript']
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*|.*/target/.*' 
let g:ctrlp_max_files = 20000
let g:ctrlp_max_depth = 40

"YankRing
map <Leader>a :YRShow<CR>
map <Leader>\ :s/^\(.*\)$/\/\/\1/<CR><Esc>:nohlsearch<CR>
map <Leader>- :s/^\/\/\(.*\)$/\1/<CR><Esc>:nohlsearch<CR>
let g:yankring_replace_n_pkey = '<C-x>'

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

"Syntastic
let g:syntastic_mode_map = { 'mode': 'passive',
                               \ 'active_filetypes': [],
                               \ 'passive_filetypes': ['groovy'] }
map <Leader>c :SyntasticCheck<CR>

let g:splice_initial_diff_grid=1
map <S-CR> <Esc>i<CR><Esc>k$
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

"Cleanup quickfix
au Filetype qf setl nolist 
au Filetype qf setl nocursorline 
au Filetype qf setl nowrap

"NeoComplCache
"" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    " return neocomplcache#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
"if !exists('g:neocomplcache_omni_patterns')
"    let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
""autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"Non default
"let g:neocomplcache_enable_insert_char_pre = 1

