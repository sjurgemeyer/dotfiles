/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle
$(brew --prefix)/opt/fzf/install

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

/usr/bin/python -m pip install pynvim
/usr/bin/python3 -m pip install pynvim

pip3 install neovim

./createAliases.sh
./setupVim.sh

