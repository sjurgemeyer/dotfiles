mkdir ~/.vimbackup
mkdir ~/.vimundo

#Hammerspoon
rm -Rf ~/.hammerspoon/init.lua
sudo ln -s ~/projects/dotfiles/init.lua ~/.hammerspoon/init.lua

rm -Rf ~/.hammerspoon/hammerspoon
sudo ln -s ~/projects/dotfiles/hammerspoon ~/.hammerspoon/hammerspoon

rm -Rf ~/.ackrc
sudo ln -s ~/projects/dotfiles/.ackrc ~/.ackrc #For Ack 2.0

rm -Rf ~/.agignore
sudo ln -s ~/projects/dotfiles/.agignore ~/.agignore

sudo rm -Rf /usr/local/bin/ffind
sudo ln -s ~/projects/dotfiles/dependencies/friendly-find/ffind /usr/local/bin/ffind

# Remapping keys
sudo rm -Rf ~/.config/karabiner/karabiner.json
sudo ln -s ~/projects/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json


# Slate for window management
rm -Rf ~/.slate
sudo ln -s ~/projects/dotfiles/.slate ~/.slate

#Git
rm -Rf ~/.gitconfig
sudo ln -s ~/projects/dotfiles/.gitconfig ~/.gitconfig
rm -Rf ~/.gitignore_global
sudo ln -s ~/projects/dotfiles/.gitignore_global ~/.gitignore_global
rm -Rf ~/.gitFunctions
sudo ln -s ~/projects/dotfiles/.gitFunctions ~/.gitFunctions
rm -Rf ~/.git.scmbrc
sudo ln -s ~/projects/dotfiles/.git.scmbrc ~/.git.scmbrc

#Vim
~/projects/dotfiles/createVimAliases.sh

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

#SCM_BREEZE
rm -Rf ~/.scm_breeze
cp -r ~/projects/dotfiles/dependencies/scm_breeze ~/.scm_breeze
~/.scm_breeze/install.sh

#iTermocil
rm -Rf ~/.teamocil
sudo ln -s ~/projects/dotfiles/.teamocil ~/.teamocil
