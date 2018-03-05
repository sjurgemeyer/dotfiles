ZSH=$HOME/.oh-my-zsh

#ohymyzsh theme
ZSH_THEME="shaun"

#ohymyzsh plugins
plugins=(lein redis-cli kubectl)
source $ZSH/oh-my-zsh.sh
setopt NO_BEEP

export CASSANDRA_BIN=~/app/apache-cassandra-2.0.12/bin
export PATH=$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$HOME/.node/bin:$PATH:$HOME/app/dsc-cassandra-2.1.0/bin:/usr/local/Cellar/kafka/0.10.2.0/bin:$HOME/app/dasht-2.0.0/bin

#VI/VIM defaults
export EDITOR=nvim
export SVN_EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config/

#launch neovim with customized tab color
function n() {
	tabcolor green
	nvim $@
	resettab
	tabtitle "sh"
}

#launch vim with customized tab color
function v() {
	tabcolor green
	vim $@
	resettab
	tabtitle "sh"
}

#VI Mode
bindkey -v
bindkey -M main '\C-r' history-incremental-search-backward
source $HOME/projects/dotfiles/dependencies/opp.zsh/opp.zsh
source $HOME/projects/dotfiles/dependencies/opp.zsh/opp/*.zsh

export JAVA_OPTS="-server -Djava.awt.headless=true -Xms2G -Xmx3G "
export JAVA_HOME=`/usr/libexec/java_home`


# Searching
#alias ag='ag --path-to-agignore ~/.agignore'
#Project setup
PROJECT_DIR=$HOME/projects
source ~/.otherFunctions
source ~/.gitFunctions
alias N="tabcolor green;n -c 'call CreateTabspaces(g:initial_tabspaces_event, 1)';resettab"

#Start web server
alias serve='python -m SimpleHTTPServer'

###############################  Gradle ##############################
function testResults() {
    openWithBaseDir /build/reports/tests/test/index.html $1
}

alias results=testResults

function codenarcMain() {
    openWithBaseDir /build/reports/codenarc/test.html $1
}

function codenarcTest() {
    openWithBaseDir /build/reports/codenarc/main.html $1
}

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

############################### Mysql ###############################
alias mysqlstart='mysql.server.start'
alias mysqlstop='mysql.server.stop'
alias myr='mysql -u root'

################################ Redis ###############################
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'

################################ Rabbit ###############################
alias rabbit='sudo /usr/local/Cellar/rabbitmq/3.3.5/sbin/rabbitmq-server -detached'

################################ Git ###############################
#Using scm_breeze shortcuts

# open all changed files in vim
alias git-changed='mvim -p `git diff --name-only --relative`'
alias bc='git difftool --tool=bc3 -d HEAD~1'

# diff each file in vimdiff using the specified commit
function git-diffall() {
    git diff $1 --name-only --relative | git difftool $1
}
function git-difflistdev() {
    git diff upstream/develop...$1 --name-only
}
function git-diffalldev() {
    git diff upstream/develop...$1 --name-only --relative | git difftool upstream/develop...$1
}

function git-diffpr() {
    git diff upstream/develop...upstream/pr/$1 --name-only --relative | git difftool upstream/develop...upstream/pr/$1
}

#Add pull request branches to upstream fetch
function git-pullify() {
    git config --add remote.upstream.fetch '+refs/pull/*/head:refs/remotes/upstream/pr/*'
}


###################### Generic Shell stuff ###########################
export DISABLE_AUTO_TITLE="true"
# Move up directories more easily
alias bd='. bd -s'

alias dot='cd $PROJECT_DIR/dotfiles'

alias mkdir='mkdir -p' #create intermediate directories
# mkdir and cd
mkcd () { mkdir -p "$@" && cd "$@"; }
alias lla='ll -a' # ll is created by scm breeze


## Friendly find alias
alias ff=ffind
infiles() {
    egrep -ir "$@" .
}

# grep for process
p() {
    ps -el | grep "$@"
}

vman() {
	nvim -c "SuperMan $*"

	if [ "$?" != "0" ]; then
		echo "No manual entry for $*"
	fi
}

# A bash function to display a growl notification using iTerm's magic
# escape sequence. This version will work under screen.

growl() {
      local msg="\\e]9;\n\n${*}\\007"
      case $TERM in
        screen*)
          echo -ne '\eP'${msg}'\e\\' ;;
        *)
          echo -ne ${msg} ;;
      esac
      return
}

# iTerm tabs
function  resettab() {
	echo -ne "\033]6;1;bg;*;default\a"
}

function tabcolor() {
	resettab
	echo -ne "\033]6;1;bg;$1;brightness;255\a"
}

function tabtitle() {
	echo -ne "\e]1;$1\a"
}

#Easier ZSH history
source $HOME/projects/dotfiles/dependencies/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/projects/dotfiles/dependencies/zsh-history-substring-search/zsh-history-substring-search.zsh
zmodload zsh/terminfo

# bind UP and DOWN arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

alias python=/usr/local/opt/python@2/bin/python2
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM
export NVM_DIR="/Users/sjurgemeyer/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# ITerm shell integration
#source /Users/sjurgemeyer/.iterm2_shell_integration.zsh

# SDKMan
source "${HOME}/.sdkman/bin/sdkman-init.sh"

#SCM Breeze
[ -s "${HOME}/.scm_breeze/scm_breeze.sh" ] && source "${HOME}/.scm_breeze/scm_breeze.sh"

[ -s "${HOME}/projects/secrets/scripts/k8s/k8sLoadAndSetContext.sh" ] && . "${HOME}/projects/secrets/scripts/k8s/k8sLoadAndSetContext.sh"

export USERNAME=z002pfx
