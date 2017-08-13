ZSH=$HOME/.oh-my-zsh

#ohymyzsh theme
ZSH_THEME="shaun"

#ohymyzsh plugins
plugins=(lein redis-cli kubectl)
source $ZSH/oh-my-zsh.sh
setopt NO_BEEP

export GOROOT=/usr/local/go

export CASSANDRA_BIN=~/app/apache-cassandra-2.0.12/bin
export PATH=$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$HOME/.node/bin:$PATH:$HOME/app/dsc-cassandra-2.1.0/bin:/usr/local/Cellar/kafka/0.10.2.0/bin:$HOME/app/dasht-2.0.0/bin
export PATH=$PATH:$GOROOT/bin
export DISABLE_DYNAMO_TESTS=true
export ST_ENV=local

#VI/VIM defaults
export EDITOR=vim
export SVN_EDITOR=vim

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
alias vi="v"

#VI Mode
bindkey -v
bindkey -M main '\C-r' history-incremental-search-backward
source $HOME/projects/dotfiles/dependencies/opp.zsh/opp.zsh
source $HOME/projects/dotfiles/dependencies/opp.zsh/opp/*.zsh

#Golang
function gopath() {
	export GOPATH=`pwd`
}
export GO15VENDOREXPERIMENT=1

#Java/JVM stuff
#alias jdk6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)'
#alias jdk7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)'
#alias jdk8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'

export JAVA_OPTS="-server -Djava.awt.headless=true -Xms2G -Xmx3G "
export GROOVY_CONSOLE_JAVA_OPTS="-server -Xms2G -Xmx3G -XX:PermSize=256M -XX:MaxPermSize=1G -noverify"
export GRAILS_OPTS="-Xms2G -Xmx3G -XX:PermSize=256m -XX:MaxPermSize=1G -Dfile.encoding=UTF-8"
export JAVA_HOME=`/usr/libexec/java_home`
#jdk8


# Searching
#alias ag='ag --path-to-agignore ~/.agignore'
#Project setup
PROJECT_DIR=$HOME/projects
source ~/.otherFunctions
source ~/.gitFunctions
alias N="tabcolor green;n -c 'call CreateTabspaces(g:initial_tabspaces_event, 1)';resettab"

#Start web server
alias serve='python -m SimpleHTTPServer'

###############################  Groovy/Grails  ##############################
function testResults() {
    if [ -e "./application.properties" ]
    then
        open target/test-reports/html/index.html
    else
        open build/reports/tests/index.html
    fi
}

alias results=testResults
alias cn="open build/reports/codenarc/main.html"

function printClassesInJar() {
    jar tf $1 | grep .class | grep -v '\$' | grep -v 'package-info' | sed s,/,.,g | sed s/.class//g
}
function grailsTestOrder() {
    grep testsuite $1 | grep -v testsuites | cut -d\  -f8-9 | sed -E 's/name="(.*)" package="(.*)"/\2.\1/' | grep .
}

alias testorder=grailsTestOrder

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

#SCM Breeze
[ -s "/Users/sjurgemeyer/.scm_breeze/scm_breeze.sh" ] && source "/Users/sjurgemeyer/.scm_breeze/scm_breeze.sh"

################################ Mercurial ###############################
alias hs="hg status -S"
alias hb="hg branch"
alias hgdr=hgdiffrevs

alias hgl="hg sglog -l"
alias hglv="hg sglog -v -l"

alias hgi='hg identify -nibt'
alias hga='hg annotate -un'

hgdiffrevs() {
	diff <(hg slog --rev $1:0 --follow) <(hg slog --rev $2:0 --follow)
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

#RVM
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# make 'workon' available
#source virtualenvwrapper.sh

# Karabiner Elements
function defaultKeyboard {
	rm -Rf ~/.config/karabiner/karabiner.json
	ln -s ~/karabiner/karabiner-default.json ~/.config/karabiner/karabiner.json
}
function externalKeyboard {
	rm -Rf ~/.config/karabiner/karabiner.json
	ln -s ~/karabiner/karabiner-external.json ~/.config/karabiner/karabiner.json
}

# Android
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM
export NVM_DIR="/Users/sjurgemeyer/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# ITerm shell integration
#source /Users/sjurgemeyer/.iterm2_shell_integration.zsh

# SDKMan
source "${HOME}/.sdkman/bin/sdkman-init.sh"

[ -s "${HOME}/projects/dotfiles/dependencies/scm_breeze/scm_breeze.sh" ] && source "${HOME}/projects/dotfiles/dependencies/scm_breeze/scm_breeze.sh"

[ -s "${HOME}/projects/secrets/scripts/k8s/k8sLoadAndSetContext.sh" ] && . "${HOME}/projects/secrets/scripts/k8s/k8sLoadAndSetContext.sh"
