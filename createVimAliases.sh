rm -Rf ~/.gvimrc
ln -s ~/projects/dotfiles/.gvimrc ~/.gvimrc
rm -Rf ~/.vim
ln -s ~/projects/dotfiles/.vim ~/.vim
rm -Rf ~/.vimrc
ln -s ~/projects/dotfiles/.vimrc ~/.vimrc
rm -Rf ~/.ctags
ln -s ~/projects/dotfiles/.ctags ~/.ctags
rm -Rf ~/.vim/colors/ororo.vim
ln -s ~/projects/dotfiles/dependencies/vim-ororo/ororo.vim ~/.vim/colors/ororo.vim
rm -Rf ~/.vim/colors/ororo-light.vim
ln -s ~/projects/dotfiles/dependencies/vim-ororo/ororo_light.vim ~/.vim/colors/ororo_light.vim

#NEOVIM
rm -Rf ~/.nvim
sudo ln -s ~/projects/dotfiles/.vim ~/.nvim
rm -Rf ~/.nvimrc
sudo ln -s ~/projects/dotfiles/.vimrc ~/.nvimrc
