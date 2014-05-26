set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
set rtp+=~/.vim/bundle/vundleconfig/
call vundleconfig#init()

let mapleader = ","
let g:mapleader = ","

Bundle 'sjurgemeyer/vundleconfig.git'
Bundle 'Shougo/neocomplcache.git'
Bundle 'Shougo/neosnippet.git'
"Bundle 'Shougo/unite.vim.git'
"Bundle 'Shougo/neomru.vim.git'
"Bundle 'Shougo/vimproc.vim.git'
Bundle 'ZoomWin'
Bundle 'bling/vim-airline'
Bundle 'freitass/todo.txt-vim'
Bundle 'gmarik/vundle'
Bundle 'jeetsukumaran/vim-buffergator.git'
Bundle 'BufOnly.vim'
Bundle 'kien/ctrlp.vim.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'mhinz/vim-startify'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'sjl/gundo.vim.git'
Bundle 'sjl/splice.vim'
Bundle 'sjurgemeyer/vim-grails-import'
Bundle 'sjurgemeyer/vim-todo.txt-plugin'
Bundle 'tpope/vim-abolish.git'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired.git'
Bundle 'vim-scripts/Align.git'
Bundle 'plasticboy/vim-markdown'
"Javascript stuff
Bundle 'jelera/vim-javascript-syntax'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'JavaScript-Indent'

"Bundle 'slimv.vim'
"Bundle 'vim-scripts/VimClojure.git'
"Bundle 'DrawIt'
Bundle 'mattn/calendar-vim'
Bundle 'jmcantrell/vim-journal'

"Dash
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'

Bundle 'tpope/vim-fugitive.git'
Bundle 'gregsexton/gitv.git'

"github PR review
Bundle 'junkblocker/patchreview-vim'
Bundle 'codegram/vim-codereview'

so ~/.vim/config/fugitive.vim
so ~/.vim/config/gitv.vim

syntax on
filetype plugin indent on
" set shell=/bin/bash\ -li

" set modelines=0
set nostartofline
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set path+=**
set encoding=utf-8
set scrolloff=5
set autoindent
set autoread 
set history=1000
set shiftround
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set title titlestring=  " Sets the title of the window to the filename
set ruler
set backspace=indent,eol,start
" set relativenumber
set undofile
"set winwidth=119
set wildignore+=*.class,.git,.hg,.svn,test-integration/**,test-unit/**,**/target/**,**/build/**
set diffopt=filler,vertical

set tags=tags;/
set ic
set smartcase
set incsearch 
set hls
set clipboard=unnamed
"Directories for swp files
set backupdir=~/.vimbackup
set directory=~/.vimbackup
set undodir=~/.vimundo


" ` goes to the line and column by default, where ' only goes to the row.  Switch ' to be the more useful one
nnoremap ' `
nnoremap ` '

let g:grails_import_list_file='/Users/sjurgemeyer/.vim/config/grailsImportList.txt'

"quick switch to last edited file
map <C-tab> <C-^>

"Manipulate a comma seperated list"
vmap <D-[> :s/,\s*/,\r/g<CR>
vmap <D-]> :s/,\n/, /g<CR>

"clear current highlighting
map <C-c> :nohlsearch<CR>

"Next/Previous difference in vimdiff
map <D-k> [c
map <D-j> ]c

"Insert line
map <S-CR> <Esc>o<Esc>
"Paste newline
map <D-p> <S-CR>p

function! RemoveSwapFile()
    let backupdir = &backupdir
    let file = expand("%:t:r")
    :execute "!rm " . backupdir . "/" . file . ".sw*"
endfunction
command! RemoveSwapFile :call RemoveSwapFile()

"Shortcuts to change background color
command! Green :colorscheme shaun-green
command! Red :colorscheme shaun-red
command! Blue :colorscheme shaun-blue
command! Black :colorscheme shaun
command! White :colorscheme delek
command! Ses :mks! ~/session.vim

command! Big :set guifont=Source\ Code\ Pro\ Semibold:h40
command! Small :set guifont=Source\ Code\ Pro\ Semibold:h13

"Cleanup quickfix
au Filetype qf setl nolist 
au Filetype qf setl nocursorline 
au Filetype qf setl nowrap

"shortcut for rerunning macro
map <A-;> @@n
"Set 'very magic' search by default.
" :nnoremap / /\v
" :cnoremap %s/ %s/\v
" :cnoremap s/ s/\v
"
"change underscore variables to camel case
:nnoremap + /\$\w\+_<CR>
:nnoremap _ f_x~

"Remove spaces at the end of lines
command! RemoveEndSpaces :silent %s/ \+$//g

"JSON
command! FormatJSON :%!python -m json.tool

:nnoremap <A-c> /\v<[A-Z][a-zA-Z]+><CR>

:nmap <C-Down> ddp
:nmap <C-Up> ddkP
           
"Set tab options
function! TabWidth(width)
    let &tabstop=a:width
    let &shiftwidth=a:width
    let &softtabstop=a:width
endfunction

"Make vim work as a word processor
func! WordProcessorMode() 
  colorscheme iawriter
  setlocal formatoptions=1 
  setlocal noexpandtab 
  "map j gj 
  "map k gk
  setlocal spell spelllang=en_us 
  set thesaurus+=/Users/sjurgemeyer/.vim/thesaurus/mthesaur.txt
  set complete+=s
  setlocal formatprg=par
  setlocal wrap 
  setlocal linebreak 
  set colorcolumn=
  set laststatus=0 " don't show status line
  set gfn=Cousine:h14                " font to use
  set nonumber
  "set guifont=Source\ Code\ Pro\ Semibold\ for\ Powerline:h15
endfu 
command! WordProcessorMode :call WordProcessorMode()

"Undo wordprocessormode
func! CodeMode() 
  colorscheme shaun
  set expandtab 
  "map j gj 
  "map k gk
  set colorcolumn=121
  set laststatus=2 " don't show status line
  set guifont=Source\ Code\ Pro\ Semibold\ for\ Powerline:h13
  set number
endfu 
command! CodeMode :call CodeMode()


"dragVisuals shortcuts
vmap <expr> <LEFT> DVB_Drag('left')
vmap <expr> <RIGHT> DVB_Drag('right')
vmap <expr> <UP> DVB_Drag('up')
vmap <expr> <DOWN> DVB_Drag('down')
vmap <expr> D DVB_Duplicate()

"Code mode by default
:CodeMode
