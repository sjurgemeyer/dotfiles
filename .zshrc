
setopt NO_BEEP
source <(echo "$(navi widget zsh)")
export PATH=$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$HOME/.node/bin:$PATH:$HOME/app/dasht-2.0.0/bin:/usr/local/Cellar/ctags/5.8_1/bin/

#VI/VIM defaults
export EDITOR=nvim
export SVN_EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config/

# use better versions of commands
alias n=nvim
alias v=vim
alias cat=bat
alias ls=lsd
alias ll=ls -la

alias ping='prettyping --nolegend'
alias top=htop
alias diff=diff-so-fancy
alias v='f -e vim' # quick opening files with vim
alias e=exa

alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort' --history=$HOME/.fzf_history"
#export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_COMMAND='rg --files'

fid() {
  local out file key
  IFS=$'\n' out=("$(fzf-tmux --preview="bat {} --color=always" --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}
#end fzf functions

export DOTFILES_DIR=$HOME/projects/dotfiles
#VI Mode
bindkey -v
#bindkey -M main '\C-r' history-incremental-search-backward

source ~/.otherFunctions
source $DOTFILES_DIR/cli/json.sh
source $DOTFILES_DIR/cli/naviscripts.sh
export PATH=$PATH:$DOTFILES_DIR/cli/

export JAVA_OPTS="-server -Djava.awt.headless=true -Xms2G -Xmx3G "

#Project setup
PROJECT_DIR=$HOME/projects
alias N="tabcolor green;n -c 'call CreateTabspaces(g:initial_tabspaces_event, 1)';resettab"

#Start web server
alias serve='python -m SimpleHTTPServer'

###############################  Gradle ##############################
function testResults() {
    openWithBaseDir /build/reports/tests/test/index.html $1
}

alias results=testResults

function openWithBaseDir() {
    FILEPATH=$1
    BASEDIR=$2
    if [ -z "$BASEDIR" ]; then
        BASEDIR=.
    fi
    open $BASEDIR/$FILEPATH
}

function printClassesInJar() {
    jar tf $1 | grep .class | grep -v '\$' | grep -v 'package-info' | sed s,/,.,g | sed s/.class//g
}

################################ Git ###############################
#Using scm_breeze shortcuts

# open all changed files in vim
alias git-changed='mvim -p `git diff --name-only --relative`'
alias bc='git difftool --tool=bc3 -d HEAD~1'


#Add pull request branches to upstream fetch
function git-pullify() {
    git config --add remote.upstream.fetch '+refs/pull/*/head:refs/remotes/upstream/pr/*'
}


###################### Generic Shell stuff ###########################
export DISABLE_AUTO_TITLE="true"

alias dot='cd $PROJECT_DIR/dotfiles'

alias mkdir='mkdir -p' #create intermediate directories
# mkdir and cd
mkcd () { mkdir -p "$@" && cd "$@"; }
alias lla='ll -a' # ll is created by scm breeze


# grep for process
function p() {
    ps -el | grep "$@"
}


#Easier ZSH history
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
#source /usr/local/var/homebrew/linked/zsh-history-substring-search/share/zsh-history-substring-search/zsh-history-substring-search.zsh
zmodload zsh/terminfo

alias python=/usr/local/opt/python@2/bin/python2
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
source "${HOME}/.sdkman/bin/sdkman-init.sh"

#SCM Breeze
[ -s "${HOME}/.scm_breeze/scm_breeze.sh" ] && source "${HOME}/.scm_breeze/scm_breeze.sh"

[ -s "${HOME}/projects/secrets/scripts/k8s/k8sLoadAndSetContext.sh" ] && . "${HOME}/projects/secrets/scripts/k8s/k8sLoadAndSetContext.sh"

eval "$(starship init zsh)"

# AWS Confiig TODO make some dynamic scripts for this
export AWS_PROFILE=staging-nebula
export AWS_REGION=us-east-1

[ -s "${HOME}/.scm_breeze/scm_breeze.sh" ] && source "${HOME}/.scm_breeze/scm_breeze.sh"
