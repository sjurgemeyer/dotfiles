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
Bundle 'Shougo/neosnippet.git'
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
set ic
set smartcase
set incsearch 
set hls
set clipboard=unnamed
"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup
set undodir=~/.vim/undo

colorscheme shaun

let mapleader = ","
let g:mapleader = ","

so ~/.vim/config/nerdtree.vim
so ~/.vim/config/ctrlp.vim
so ~/.vim/config/easygrep.vim
so ~/.vim/config/splice.vim
so ~/.vim/config/powerline.vim
so ~/.vim/config/neosnippet.vim
so ~/.vim/config/neocomplcache.vim
so ~/.vim/config/vimclojure.vim
so ~/.vim/config/syntastic.vim
so ~/.vim/config/tagbar.vim
so ~/.vim/config/nerdcommenter.vim
so ~/.vim/config/buffergator.vim
so ~/.vim/config/gundo.vim

"quick switch to last edited file
map <C-tab> <C-^>
"Skip over one
map <A-tab> <Esc>,bjj<CR>

"YankRing
"map <Leader>a :YRShow<CR>
"map <Leader>\ :s/^\(.*\)$/\/\/\1/<CR><Esc>:nohlsearch<CR>
"map <Leader>- :s/^\/\/\(.*\)$/\1/<CR><Esc>:nohlsearch<CR>
"let g:yankring_replace_n_pkey = '<C-x>'

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
command! Ses :mks! ~/session.vim

"Cleanup quickfix
au Filetype qf setl nolist 
au Filetype qf setl nocursorline 
au Filetype qf setl nowrap

