rm -Rf ~/.ackrc
sudo ln -s ~/projects/dotfiles/.ackrc ~/.ackrc #For Ack 2.0
sudo rm -Rf /usr/local/bin/ffind
sudo ln -s ~/projects/dotfiles/dependencies/friendly-find/ffind /usr/local/bin/ffind
rm /Users/sjurgemeyer/Library/Application\ Support/Karabiner/private.xml
sudo ln -s ~/projects/dotfiles/config/private.xml ~/Library/Application\ Support/Karabiner/private.xml
rm -Rf ~/.slate
sudo ln -s ~/projects/dotfiles/.slate ~/.slate
rm -Rf ~/.ansiweatherrc
sudo ln -s ~/projects/dotfiles/.ansiweatherrc ~/.ansiweatherrc

#Git
rm -Rf ~/.gitconfig
sudo ln -s ~/projects/dotfiles/.gitconfig ~/.gitconfig
rm -Rf ~/.gitignore_global
sudo ln -s ~/projects/dotfiles/.gitignore_global ~/.gitignore_global
rm -Rf ~/.gitFunctions
sudo ln -s ~/projects/dotfiles/.gitFunctions ~/.gitFunctions
rm -Rf ~/.git.scmbrc
sudo ln -s ~/projects/dotfiles/.git.scmbrc ~/.git.scmbrc

#HG
rm -Rf ~/.hgignore
sudo ln -s ~/projects/dotfiles/.hgignore ~/.hgignore
rm -Rf ~/.hgignore_global
sudo ln -s ~/projects/dotfiles/.hgignore_global ~/.hgignore_global
rm -Rf ~/.hgrc
sudo ln -s ~/projects/dotfiles/.hgrc ~/.hgrc

#TODO.txt
sudo rm -Rf /usr/local/bin/todo
sudo ln -s ~/projects/dotfiles/dependencies/todo.txt_cli-2.10/todo.sh /usr/local/bin/todo
rm -Rf ~/.todo.cfg
sudo ln -s ~/projects/dotfiles/.todo.cfg ~/.todo.cfg
rm -Rf ~/.todo.actions.d
sudo ln -s ~/projects/dotfiles/.todo.actions.d ~/.todo.actions.d
rm -Rf ~/.todo.txt.color
sudo ln -s ~/projects/dotfiles/.todo.txt.color ~/.todo.txt.color
rm -Rf ~/.todofilter.py
sudo ln -s ~/projects/dotfiles/config/todofilter.py ~/.todofilter.py 

#Vim
rm -Rf ~/.gvimrc
sudo ln -s ~/projects/dotfiles/.gvimrc ~/.gvimrc
rm -Rf ~/.vim
sudo ln -s ~/projects/dotfiles/.vim ~/.vim
rm -Rf ~/.vimrc
sudo ln -s ~/projects/dotfiles/.vimrc ~/.vimrc
rm -Rf ~/.ctags
sudo ln -s ~/projects/dotfiles/.ctags ~/.ctags
rm -Rf ~/.vim/colors/ororo.vim
sudo ln -s ~/projects/dotfiles/dependencies/vim-ororo/ororo.vim ~/.vim/colors/ororo.vim 

# Used for syntastic
sudo rm -Rf /usr/local/bin/grails-compile-file
sudo ln -s ~/projects/dotfiles/config/grails-compile-file /usr/local/bin/grails-compile-file
rm -Rf ~/.jshintrc
sudo ln -s ~/projects/dotfiles/.jshintrc ~/.jshintrc
rm -Rf /usr/local/bin/codenarc
sudo ln -s ~/.vim/tools/codenarc /usr/local/bin/codenarc

#ZSH
rm -Rf ~/.zshrc
sudo ln -s ~/projects/dotfiles/.zshrc ~/.zshrc
rm -Rf ~/.oh-my-zsh/themes/shaun.zsh-theme
sudo ln -s ~/projects/dotfiles/.oh-my-zsh/themes/shaun.zsh-theme ~/.oh-my-zsh/themes/shaun.zsh-theme
sudo rm -Rf /usr/local/bin/bd
sudo ln -s ~/projects/dotfiles/dependencies/bd /usr/local/bin/bd
sudo rm -Rf /usr/local/bin/jq
sudo ln -s ~/projects/dotfiles/dependencies/jq /usr/local/bin/jq
sudo rm -Rf /usr/local/bin/weather
sudo ln -s ~/projects/dotfiles/dependencies/ansiweather/ansiweather /usr/local/bin/weather

#Vagrant
rm -Rf ~/.vagrant.d/Vagrantfile
sudo ln -s ~/projects/dotfiles/.vagrant.d/VagrantFile ~/.vagrant.d/VagrantFile
rm -Rf ~/.vagrant.d/cookbooks
sudo ln -s ~/projects/dotfiles/.vagrant.d/cookbooks ~/.vagrant.d/cookbooks
rm -Rf ~/.vagrant.d/bash
sudo ln -s ~/projects/dotfiles/.vagrant.d/bash ~/.vagrant.d/bash

#NPM
rm -Rf ~/.npmrc
sudo ln -s ~/projects/dotfiles/.npmrc ~/.npmrc

#NEOVIM
rm -Rf ~/.nvim
sudo ln -s ~/projects/dotfiles/.vim ~/.nvim
rm -Rf ~/.nvimrc
sudo ln -s ~/projects/dotfiles/.vimrc ~/.nvimrc
