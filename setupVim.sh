#bash -c "$(curl -fsSkL raw.github.com/sjurgemeyer/dotfiles/master/setupVim.sh)"
mkdir -p ~/projects
mkdir -p ~/.vimundo
mkdir -p ~/.vimbackup
cd ~/projects
git clone https://github.com/sjurgemeyer/dotfiles
cd dotfiles
git submodule update --init
cd ..
mkdir -p ~/projects/dotfiles/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/projects/dotfiles/.vim/bundle/Vundle.vim
git clone https://github.com/sjurgemeyer/vundleconfig.git ~/projects/dotfiles/.vim/bundle/vundleconfig
~/projects/dotfiles/createVimAliases.sh
vi +PluginInstall +qall

