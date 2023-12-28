/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/sjurgemeye/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle
$(brew --prefix)/opt/fzf/install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
navi repo add https://github.com/denisidoro/cheats
navi repo add https://github.com/sjurgemeyer/cheats

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

/usr/bin/python -m pip install pynvim
/usr/bin/python3 -m pip install pynvim

pip3 install neovim

./createAliases.sh
./setupVim.sh

