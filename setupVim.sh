#bash -c "$(curl -fsSkL raw.github.com/sjurgemeyer/dotfiles/master/setupVim.sh)"
mkdir ~/projects
cd ~/projects
git clone https://github.com/sjurgemeyer/dotfiles
cd dotfiles
git submodule update --init
cd ..
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
~/projects/dotfiles/createVimAliases.sh
vi +BundleInstall +qall

