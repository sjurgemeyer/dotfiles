mkdir -p ~/.vimbackup
mkdir -p ~/.vimundo

#Hammerspoon
mkdir -p ~/.hammerspoon
rm -Rf ~/.hammerspoon/init.lua
sudo ln -s ~/projects/dotfiles/init.lua ~/.hammerspoon/init.lua
rm -Rf ~/.hammerspoon/Spoons
sudo ln -s ~/projects/dotfiles/hammerspoon/Spoons ~/.hammerspoon/Spoons
rm -Rf ~/.hammerspoon/hammerspoon
sudo ln -s ~/projects/dotfiles/hammerspoon ~/.hammerspoon/hammerspoon

rm -Rf ~/.ackrc
sudo ln -s ~/projects/dotfiles/.ackrc ~/.ackrc #For Ack 2.0

rm -Rf ~/.agignore
sudo ln -s ~/projects/dotfiles/.agignore ~/.agignore

#Git
rm -Rf ~/.gitconfig
sudo ln -s ~/projects/dotfiles/.gitconfig ~/.gitconfig
rm -Rf ~/.gitignore_global
sudo ln -s ~/projects/dotfiles/.gitignore_global ~/.gitignore_global
rm -Rf ~/.git.scmbrc
sudo ln -s ~/projects/dotfiles/.git.scmbrc ~/.git.scmbrc

#Vim
~/projects/dotfiles/createVimAliases.sh

# Used for syntastic
rm -Rf ~/.jshintrc
sudo ln -s ~/projects/dotfiles/.jshintrc ~/.jshintrc

#ZSH
rm -Rf ~/.zshrc
sudo ln -s ~/projects/dotfiles/.zshrc ~/.zshrc
rm -Rf ~/.oh-my-zsh/themes/shaun.zsh-theme
sudo ln -s ~/projects/dotfiles/.oh-my-zsh/themes/shaun.zsh-theme ~/.oh-my-zsh/themes/shaun.zsh-theme

#Bash / Flyline
rm -Rf ~/.bashrc
sudo ln -s ~/projects/dotfiles/.bashrc ~/.bashrc
rm -Rf ~/.bash_profile
sudo ln -s ~/projects/dotfiles/.bash_profile ~/.bash_profile

#NPM
rm -Rf ~/.npmrc
sudo ln -s ~/projects/dotfiles/.npmrc ~/.npmrc

# prompt
sudo rm -Rf ~/.config/starship.toml
sudo ln -s ~/projects/dotfiles/starship.toml ~/.config/starship.toml

# karabiner
sudo rm -Rf ~/.config/karabiner/karabiner.json
sudo ln -s ~/projects/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json

# claude
sudo rm -Rf ~/.claude/settings.json
sudo ln -s ~/projects/dotfiles/claude/settings.json ~/.claude/settings.json
sudo rm -Rf ~/.claude/CLAUDE.md
sudo ln -s ~/projects/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md

# lsd
sudo rm -Rf ~/.config/lsd
sudo ln -s ~/projects/dotfiles/.config/lsd ~/.config/lsd
