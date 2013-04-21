# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="shaun"

#ZSH_THEME="gnzh"
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx gradle lein redis-cli vi-mode)
source $ZSH/oh-my-zsh.sh
setopt NO_BEEP

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:$HOME/.rvm/bin
export JAVA_OPTS="-Xms2G -Xmx2G -XX:MaxPermSize=512m -XX:PermSize=512m -XX:NewSize=256m -server -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
export JAVA_HOME=`/usr/libexec/java_home`
#For the love of god make sure everything acts like vim
export EDITOR=vim
export SVN_EDITOR=vim
alias v='mvim'

#VI Mode
bindkey -v
bindkey -M main '\C-r' history-incremental-search-backward

PROJECT_DIR=$HOME/projects

source ~/.otherFunctions
# source ~/projects/bloom/dev_scripts/bash/git-branch-cleanup.sh

#open all changed files in vim
alias git-changed='mvim -p `git diff --name-only --relative`'

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
#Start web server
alias http='python -m SimpleHTTPServer'

###############################  Grails  ##############################
function testResults() {
    if [ -e "./application.properties" ]
    then
        open target/test-reports/html/index.html
    else
        open build/reports/tests/index.html
    fi
}

alias gr='grails run-app'
alias gd='grails-debug run-app'
alias gtr='grails test run-app'
alias gdta='grails-debug -Duser.timezone=UTC test run-app'
alias gf='grails run-fitnesse'
alias gt='grails -Duser.timezone=UTC test-app'
alias gtu='grails -Duser.timezone=UTC test-app unit:'
alias gti='grails -Duser.timezone=UTC test-app integration:'
alias results=testResults

############################### Mysql ###############################
alias mysqlstart='sudo /Library/StartupItems/MySQLCOM/MySQLCOM start'
alias mysqlstop='sudo /Library/StartupItems/MySQLCOM/MySQLCOM stop'

################################Redis ###############################
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'

################################ Rabbit ###############################
alias rabbit='sudo /usr/local/Cellar/rabbitmq/2.8.7/sbin/rabbitmq-server'

################################ Git ###############################
#Using scm_breeze shortcuts

################################ Mercurial ###############################
alias hs="hg status -S"
alias hb="hg branch"
alias hgdr=hgdiffrevs

alias ic="hg incoming -v | lf"
alias og="hg outgoing -v | lf"

alias hgl="hg sglog -l"
alias hglv="hg sglog -v -l"

alias hgi='hg identify -nibt'
alias hga='hg annotate -un'

alias icdiff="hg diff --reverse http://hg/direct \$(ic)"
alias ogdiff="hg diff --reverse http://hg/direct \$(og)"

hgdiffrevs() {
	diff <(hg slog --rev $1:0 --follow) <(hg slog --rev $2:0 --follow)
}

###################### Generic Shell stuff ###########################

alias dot='cd $PROJECT_DIR/dotfiles'

alias mkdir='mkdir -p' #create intermediate directories
alias lla='ll -a' # ll is created by scm breeze

# mkdir and cd
mkcd () { mkdir -p "$@" && cd "$@"; }

#Easier ZSH history
source $HOME/projects/dotfiles/dependencies/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/projects/dotfiles/dependencies/zsh-history-substring-search/zsh-history-substring-search.zsh

## Friendly find alias
alias ff=ffind
infiles() {
    egrep -ir "$@" .
}

export VIMCLOJURE_SERVER_JAR="$HOME/projects/dotfiles/dependencies/lib/nailgun/server-2.3.6.jar"

# grep for process
p() {
    ps -el | grep "$@"
}

#RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

#SCM Breeze
[ -s "/Users/sjurgemeyer/.scm_breeze/scm_breeze.sh" ] && source "/Users/sjurgemeyer/.scm_breeze/scm_breeze.sh"

#TODO.txt
source $HOME/projects/dotfiles/dependencies/todo.txt_cli-2.9/todo_completion

alias t=todo
alias tls='t ls'
alias ta='t add'
alias td='t do'
alias tvp='t view project'
alias tvd='t view date'
alias tvc='t view context'
alias ts='t schedule'
# complete -F _todo t

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/sjurgemeyer/.gvm/bin/gvm-init.sh" ]] && source "/Users/sjurgemeyer/.gvm/bin/gvm-init.sh"
