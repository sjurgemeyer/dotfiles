start_time=$(date +%s%N)
# self-correct $SHELL — see .bashrc for why this is needed
export SHELL=/bin/zsh
setopt NO_BEEP
source <(echo "$(navi widget zsh)")
export PROJECT_DIR=$HOME/projects
export DOTFILES_DIR=$PROJECT_DIR/dotfiles
export PATH=$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$HOME/.node/bin:$HOME/app/dasht-2.0.0/bin:/usr/local/Cellar/ctags/5.8_1/bin/:~/Library/Python/3.9/bin:$DOTFILES_DIR/cli/:/usr/local/lib/docker/cli-plugins:/Applications/Docker.app/Contents//Resources/bin/:/Users/sjurgemeyer/nvim_nightly/bin/:$HOME/go/bin:/opt/homebrew/Cellar/dateutils/0.4.11/bin/:$PROJECT_DIR/screenpipe-scripts/:/opt/homebrew/bin:/.local/bin:$HOME/.local/bin:/Users/sjurgemeyer/Library/Python/3.9/bin:$PATH
setopt auto_cd
#VI/VIM defaults
export EDITOR=nvim

export SVN_EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config/

# use better versions of commands
alias n=nvr
alias cat=bat
alias ls=lsd
alias ll='lsd -la'

alias ping='prettyping --nolegend'
alias top=htop
alias diff=diff-so-fancy

# fzf functions
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort' --history=$HOME/.fzf_history"
export FZF_DEFAULT_COMMAND='rg --files'
alias xx=exit

 fid() {
   local out file key
   IFS=$'\n' out=("$(fzf-tmux --preview="bat {} --color=always" --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
   key=$(head -1 <<< "$out")
   file=$(head -2 <<< "$out" | tail -1)
   if [ -n "$file" ]; then
     [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
   fi
 }
 source $DOTFILES_DIR/cli/fzf-shell.sh
 #end fzf functions
 
 export PROJECT_DIR=$HOME/projects
 export DOTFILES_DIR=$PROJECT_DIR/dotfiles
 
 #VI Mode
 bindkey -v
 
 source ~/.otherFunctions
 source $DOTFILES_DIR/cli/json.sh
# source $DOTFILES_DIR/cli/naviscripts.sh
# 
# #Start web server
 alias serve='python -m SimpleHTTPServer'
 
 ################################ Git ###############################
 # open all changed files in vim
 # TODO, probably don't need this anymore
 alias git-changed='mvim -p `git diff --name-only --relative`'
 alias bc='git difftool --tool=bc3 -d HEAD~1'
 alias gs='git status'
 alias ga='git add'
 alias gaa='git add --all'
 
autoload -Uz compinit
compinit
 
 ###################### Generic Shell stuff ###########################
 alias dot='cd $DOTFILES_DIR'
 alias tobash='exec bash'
 alias mkdir='mkdir -p' #create intermediate directories
 # mkdir and cd
 mkcd () { mkdir -p "$@" && cd "$@"; }
 
 # grep for process
 function p() {
     ps -el | grep "$@"
 }


  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  
  # Allow for more open files on OSX
  ulimit -S -n 10000
  
  # NVM
   export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
  
eval "$(zoxide init zsh)"
eval "$(navi widget zsh)"
# SDKMan
#  source "${HOME}/.sdkman/bin/sdkman-init.sh"

 eval "$(starship init zsh)"
#  
#  
# rustup - keg-only brew formula, cargo/rustc don't resolve without this
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

# bun - typescript
# bun completions adds ~ 25ms
#  [ -s "/Users/sjurgemeyer/.bun/_bun" ] && source "/Users/sjurgemeyer/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
#  
#  # pyenv - adds ~200ms
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"
#  
#  
#  # Added by dbt Fusion extension
alias dbtf=/Users/sjurgemeyer/.local/bin/dbt
#  
  # Change cursor shape for vi modes
  function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      echo -ne '\e[2 q'  # block cursor for normal mode
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ $1 = 'beam' ]]; then
      echo -ne '\e[6 q'  # beam cursor for insert mode
    fi
  }
  zle -N zle-keymap-select
  
  # Start with beam cursor
  function zle-line-init {
    echo -ne '\e[6 q'
  }
  zle -N zle-line-init
#  
#
#

source $DOTFILES_DIR/cli/prreview.sh
export GITHUB_TOKEN=$(gh auth token)

eval "$(atuin init zsh)"

end_time=$(date +%s%N)
elapsed=$(( (end_time - start_time) / 1000000 ))
echo "Startup time: ${elapsed}ms"

# Cortex CLI completion (disable via /settings in cortex)
[[ -s ~/.zsh/completions/cortex.zsh ]] && source ~/.zsh/completions/cortex.zsh
