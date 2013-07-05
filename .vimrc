source ~/.vimrc-core
" Fugitive doesn't play nice with Splice, so I seperate fugitive I have a
" shortcut for splice that calls vimrc-core.
Bundle 'tpope/vim-fugitive.git'
so ~/.vim/config/fugitive.vim
