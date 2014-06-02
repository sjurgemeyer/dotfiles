set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
set rtp+=~/.vim/bundle/vundleconfig/
call vundleconfig#init()

let mapleader = ","
let g:mapleader = ","

"Plugins management
Bundle 'sjurgemeyer/vundleconfig.git'
Bundle 'gmarik/vundle'

"Code completion
Bundle 'Shougo/neocomplcache.git'
Bundle 'Shougo/neosnippet.git'

"Buffer management
Bundle 'jeetsukumaran/vim-buffergator.git'
Bundle 'BufOnly.vim'
Bundle 'ZoomWin'

"Navigation
Bundle 'kien/ctrlp.vim.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'jayflo/vim-skip'
Bundle 'sjl/gundo.vim.git'
Bundle 'tpope/vim-unimpaired.git'

"Searching
Bundle 'mileszs/ack.vim'
Bundle 'tpope/vim-abolish.git'

"terminal clipboard
Bundle 'kana/vim-fakeclip'

"Writing stuff
Bundle 'mattn/calendar-vim'
Bundle 'jmcantrell/vim-journal'

"Dash
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'

"Editing
Bundle 'scrooloose/syntastic.git'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'sjurgemeyer/vim-grails-import'

"Formatting
Bundle 'vim-scripts/Align.git'
Bundle 'tpope/vim-sleuth'
Bundle 'vim-scripts/SyntaxRange'

"Filetype
Bundle 'tpope/vim-markdown'
Bundle 'csv.vim'

"Javascript stuff
Bundle 'jelera/vim-javascript-syntax'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'JavaScript-Indent'

"TODO.txt
Bundle 'freitass/todo.txt-vim'
Bundle 'sjurgemeyer/vim-todo.txt-plugin'

"Git
Bundle 'sjl/splice.vim'
Bundle 'tpope/vim-fugitive.git'
Bundle 'gregsexton/gitv.git'

"github PR review
Bundle 'junkblocker/patchreview-vim'
Bundle 'codegram/vim-codereview'

"Utils
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-dispatch'

"Pretty
Bundle 'bling/vim-airline'

syntax on
filetype plugin indent on

set nostartofline
set nowrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set path+=**
set encoding=utf-8
set termencoding=utf-8
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

command! Big :set guifont=Source\ Code\ Pro\ Semibold\ for\ Powerline:h40
command! Small :set guifont=Source\ Code\ Pro\ Semibold\ for\ Powerline:h13

"Cleanup quickfix
au Filetype qf setl nolist 
au Filetype qf setl nocursorline 
au Filetype qf setl nowrap

"change underscore variables to camel case
:nnoremap + /\$\w\+_<CR>
:nnoremap _ f_x~

"Remove spaces at the end of lines
command! RemoveEndSpaces :silent %s/ \+$//g

"JSON
command! FormatJSON :%!python -m json.tool

:nnoremap <A-c> /\v<[A-Z][a-zA-Z]+><CR>

" select previously pasted text
nnoremap gp `[v`] 

"Move lines up and down
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
  set guifont=Source\ Code\ Pro\ Semibold\ for\ Powerline:h15
endfu 
command! WordProcessorMode :call WordProcessorMode()

"Undo wordprocessormode
func! CodeMode() 
  colorscheme ororo
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

"Cursor in terminal mode
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode"
endif

if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif
