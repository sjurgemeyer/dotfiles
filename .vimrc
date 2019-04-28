set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
set rtp+=~/.vim/bundle/vundleconfig/
call vundleconfig#init()

let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
"Plugins management
Plugin 'sjurgemeyer/vundleconfig.git'
Plugin 'VundleVim/Vundle.vim'

"Code completion
if has('nvim')
   Plugin 'Shougo/deoplete.nvim'
   set inccommand=nosplit
   tnoremap <Esc> <C-\><C-n>
else
   "Plugin 'Shougo/neocomplete.vim'
   Plugin 'haya14busa/incsearch.vim'
endif
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'gravle'

"Buffer management
Plugin 'jlanzarotta/bufexplorer'
Plugin 'BufOnly.vim'
Plugin 'szw/vim-maximizer'

"Navigation
Plugin 'scrooloose/nerdtree.git'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'mbbill/undotree'
Plugin 'tpope/vim-unimpaired.git'

"Searching
set rtp+=/usr/local/opt/fzf
Plugin 'junegunn/fzf.vim'
Plugin 'wincent/ferret'
Plugin 'vim-scripts/keepcase.vim'
Plugin 'RRethy/vim-illuminate'
Plugin 'prakashdanish/vim-githubinator'

Plugin 'tpope/vim-abolish.git'
Plugin 'terryma/vim-expand-region'

"terminal clipboard
Plugin 'kana/vim-fakeclip'

"Dash
Plugin 'rizzatti/funcoo.vim'
Plugin 'rizzatti/dash.vim'

"Editing
Plugin 'scrooloose/syntastic.git'
Plugin 'benekastah/neomake'
Plugin 'tpope/vim-surround'
Plugin 'wellle/targets.vim'
Plugin 'scrooloose/nerdcommenter.git'
Plugin 'sjurgemeyer/vimport'
Plugin 'sjurgemeyer/vim-open'
Plugin 'sjurgemeyer/vim-gradle'
Plugin 'sjurgemeyer/vim-tabspace'
Plugin 'sjurgemeyer/vim-uuid'

"Formatting
Plugin 'vim-scripts/Align.git'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'junegunn/vim-easy-align'
Plugin 'navicore/vissort.vim'
"Plugin 'ciaranm/detectindent'

" Required for other plugins?
Plugin 'vim-scripts/SyntaxRange'

""Filetype
Plugin 'tpope/vim-markdown'
Plugin 'csv.vim'

" plantuml
Plugin 'sjurgemeyer/vim-plantuml'
Plugin 'aklt/plantuml-syntax'

"CSS
"Plugin 'https://github.com/gorodinskiy/vim-coloresque.git'
Plugin 'groenewege/vim-less'

"Javascript stuff
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/javascript-libraries-syntax.vim'

"Kotlin
Plugin 'udalov/kotlin-vim'

"Scala
Plugin 'derekwyatt/vim-scala'

" Terraform
Plugin 'markcornick/vim-terraform'

"Golang
"Plugin 'fatih/vim-go'

"Rust
Plugin 'rust-lang/rust.vim'

"Git
Plugin 'sjl/splice.vim'
if !exists('g:nofugitive')
    Plugin 'tpope/vim-fugitive.git'
endif
Plugin 'gregsexton/gitv.git'
Plugin 'idanarye/vim-merginal'
Plugin 'airblade/vim-gitgutter'
Plugin 'tyru/open-browser.vim'
Plugin 'tyru/open-browser-github.vim'

"Utils
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-eunuch'

"Pretty
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'luochen1990/rainbow'

" REST / HTTP
Plugin 'sjurgemeyer/vim-http-client'

"Random
Plugin 'nixon/vim-vmath'

" Drawing
"Plugin 'gyim/vim-boxdraw'

" NeoVim terminal
if has('nvim')
    Plugin 'kassio/neoterm'
endif

syntax on
if filereadable("~/.vimrc-private")
    source ~/.vimrc-private
endif
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

set tags=.tags;/
set ic
set smartcase
set incsearch
set hls
set clipboard=unnamed "Setting the default clipboard to the system clipboard

"Directories for swp files
set backupdir=~/.vimbackup
set directory=~/.vimbackup
set undodir=~/.vimundo

" ` goes to the line and column by default, where ' only goes to the row.  Switch ' to be the more useful one
nnoremap ' `
nnoremap ` '

autocmd BufWritePre *.groovy OrganizeImports
"autocmd BufWritePre *.java RemoveUnneededImports
"autocmd BufWritePre *.java OrganizeImports

autocmd BufWritePre * StripWhitespace

"Manipulate a comma seperated list"
vmap <D-[> :s/,\s*/,\r/g<CR>
vmap <D-]> :s/,\n/, /g<CR>

"Map g to move to end of search term
vnoremap <silent> g //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap g :normal vg<CR>

"Insert line
map <S-CR> <Esc>o<Esc>

" Jump to the end of copied text
vnoremap <silent> y y`]
" Jump to the end of pasted text
vnoremap <silent> p p`]
nnoremap <silent> p p`]

function! RemoveSwapFile()
    let backupdir = &backupdir
    let file = expand("%:t:r")
    :execute "!rm " . backupdir . "/" . file . ".sw*"
endfunction
command! RemoveSwapFile :call RemoveSwapFile()

command! Big :set guifont=Source\ Code\ Pro\ for\ Powerline\ Semibold:h40
command! Small :set guifont=Source\ Code\ Pro\ for\ Powerline\ Semibold:h13

"Cleanup quickfix
au Filetype qf setl nolist
au Filetype qf setl nocursorline
au Filetype qf setl nowrap

"change underscore variables to camel case
:nnoremap + /\$\w\+_<CR>
:nnoremap _ f_x~

"change camelcase to underscore
":s#\(\<\u\l\+\|\l\+\)\(\u\)#\l\1_\l\2#g
"
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

nmap <Leader>2 :call TabWidth(2)<CR>:set expandtab<CR>
nmap <Leader>4 :call TabWidth(4)<CR>:set expandtab<CR>
nmap <Leader><Tab> :call TabWidth(4)<CR>:set noexpandtab<CR>

autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
autocmd FileType groovy setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
autocmd FileType java setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab





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
  set guifont=Source\ Code\ Pro\ for\ Powerline\ Semibold:h15
endfu
command! WordProcessorMode :call WordProcessorMode()

func! Light()
    colorscheme morning
    let g:airline_theme='cool'
endfu
command Light :call Light()

func! Dark()
    colorscheme ororo
    let g:airline_theme='dark'
endfu
command Dark :call Dark()

"Undo wordprocessormode
func! CodeMode()
  colorscheme ororo
  set expandtab
  "map j gj
  "map k gk
  set colorcolumn=121
  set laststatus=2 " don't show status line
  set guifont=Source\ Code\ Pro\ for\ Powerline\ Semibold:h13
  set number
endfu
command! CodeMode :call CodeMode()

"Neovim terminal
if has('nvim')
    "let g:loaded_python_provider = 0
    let g:python_host_skip_check = 1
    let g:python_host_prog = 'python'

    "let g:loaded_python3_provider = 0
    let g:python3_host_skip_check = 1
    let g:python3_host_prog = 'python3'

  set termguicolors
    tnoremap <C-q> <C-\><C-n>

    function! Term()
        :e term://zsh
    endfunction
    command! Term :call Term()
endif

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

"dragVisuals shortcuts
vmap <expr> <LEFT> DVB_Drag('left')
vmap <expr> <RIGHT> DVB_Drag('right')
vmap <expr> <UP> DVB_Drag('up')
vmap <expr> <DOWN> DVB_Drag('down')
vmap <expr> D DVB_Duplicate()

"Code mode by default
:CodeMode

"Cursor in terminal mode
"if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode"
"endif

if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif


function! PasteTime()
    let t = strftime("%FT%T%z")
    execute 'normal i' . t
endfunction


" Need to move these functions elsewhere
function! SmallTerm()
    :bel Topen
endfunction
command! SmallTerm :call SmallTerm()

let g:neoterm_size = 10
let g:neoterm_open_in_all_tabs = 1
"let g:neoterm_autojump = 1
let g:neoterm_fixedsize = 1


function! RunTest()
    let file = expand('%:t:r')
    let root = GradleRootDir()
    let project = GradleSubprojectName()
    let package = GetCurrentPackage()
    call SmallTerm()
    execute ':T cd ' . root
    execute ':T ./gradlew -p ' . project . ' test --tests ' . package . '.' . file
endfunction
