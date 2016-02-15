ZSH=$HOME/.oh-my-zsh

#ohymyzsh theme
ZSH_THEME="shaun"

#ohymyzsh plugins
plugins=(git osx gradle lein redis-cli vi-mode)
source $ZSH/oh-my-zsh.sh
setopt NO_BEEP

export GOROOT=/usr/local/go
#export GOPATH=~/gopath

export CASSANDRA_BIN=~/app/apache-cassandra-2.0.12/bin
export PATH=$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/share/npm/bin/:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$HOME/.node/bin:$PATH:$HOME/app/dsc-cassandra-2.1.0/bin:/usr/local/Cellar/kafka/0.8.1.1/bin
export PATH=$PATH:$GOROOT/bin
export DISABLE_DYNAMO_TESTS=true
export ST_ENV=local

#VI/VIM defaults
#export VIMRUNTIME=/Applications/MacVim.app/Contents/Resources/vim/runtime/
export EDITOR=vim
export SVN_EDITOR=vim
alias v='mvim'
alias n='tabcolor green;nvim'

#VI Mode
bindkey -v
bindkey -M main '\C-r' history-incremental-search-backward
source $HOME/projects/dotfiles/dependencies/opp.zsh/opp.zsh
source $HOME/projects/dotfiles/dependencies/opp.zsh/opp/*.zsh

#Java/JVM stuff
alias jdk6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)'
alias jdk7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)'
alias jdk8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)'
export JAVA_OPTS="-server -Djava.awt.headless=true -Xms2G -Xmx3G -XX:PermSize=256M -XX:MaxPermSize=1G -noverify" 
export GROOVY_CONSOLE_JAVA_OPTS="-server -Xms2G -Xmx3G -XX:PermSize=256M -XX:MaxPermSize=1G -noverify" 
# -XX:NewSize=64m -Dfile.encoding=UTF-8 -noverify"
export GRAILS_OPTS="-Xms2G -Xmx3G -XX:PermSize=256m -XX:MaxPermSize=1G -Dfile.encoding=UTF-8"
# -Xms2G -Xmx2G -XX:MaxPermSize=512m -XX:PermSize=512m -XX:NewSize=256m -server -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
export JAVA_HOME=`/usr/libexec/java_home`
jdk7


#Project setup
PROJECT_DIR=$HOME/projects
source ~/.otherFunctions
source ~/.gitFunctions
alias V="mvim -c 'cd $CURRENT_PROJECT_DIR'"
alias N="tabcolor green;nvim -c 'cd $CURRENT_PROJECT_DIR'"

#Start web server
alias serve='python -m SimpleHTTPServer'

###############################  Groovy/Grails  ##############################
alias gd='gradle'
function testResults() {
    if [ -e "./application.properties" ]
    then
        open target/test-reports/html/index.html
    else
        open build/reports/tests/index.html
    fi
}

alias gr='grails run-app'
alias gtr='grails --refresh-dependencies test run-app'
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

# source ~/projects/bloom/dev_scripts/bash/git-branch-cleanup.sh
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

# alias ic="hg incoming -v | lf"
# alias og="hg outgoing -v | lf"

alias hgl="hg sglog -l"
alias hglv="hg sglog -v -l"

alias hgi='hg identify -nibt'
alias hga='hg annotate -un'

# alias icdiff="hg diff --reverse http://hg/direct \$(ic)"
# alias ogdiff="hg diff --reverse http://hg/direct \$(og)"

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

#TODO.txt
source $HOME/projects/dotfiles/dependencies/todo.txt_cli-2.10/todo_completion

alias t='workon topydo; topydo'
alias tls='t ls'
alias ta='t add'
alias td='t do'
alias tvp='t view project'
alias tvd='t view date'
alias tvc='t view context'
alias ts='t schedule'
alias te='n /Users/sjurgemeyer/Dropbox/todo/todo.txt'
alias trec 'v /Users/sjurgemeyer/Dropbox/todo/recur.txt'
alias todohelp='echo \
"TODO.txt shortcuts
------------------
tls: List all tasks
ta:  Add a task
td:  Complete a task
tvp: View tasks by project
tvd: View tasks by date
tvc: View tasks by context
ts:  View tasks with specific dates
te:  Edit todo.txt
trec:  Edit recur.txt
"'

function numberOfCurrentTasks() {
    today=`date "+%Y-%m-%d"`
    z=`tls $today | wc -l | sed -e 's/^ *//g' -e 's/ *$//g'`
    echo `expr $z - 2`
}

vman() {
	nvim -c "SuperMan $*"

	if [ "$?" != "0" ]; then
		echo "No manual entry for $*"
	fi
}

# complete -F _todo t

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
alias resettab='echo -e "\033]6;1;bg;*;default\a"'
function tabcolor() {
	resettab
	echo -e "\033]6;1;bg;$1;brightness;255\a" 
}

function tabtitle() {
	echo -ne "\e]1;$1\a"
}

export CHEATCOLORS=true
export VIMCLOJURE_SERVER_JAR="$HOME/projects/dotfiles/dependencies/lib/nailgun/server-2.3.6.jar"

#Easier ZSH history
# 
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
source virtualenvwrapper.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="/Users/sjurgemeyer/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

source /Users/sjurgemeyer/.iterm2_shell_integration.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "/Users/sjurgemeyer/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/sjurgemeyer/.sdkman/bin/sdkman-init.sh"
