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
export JAVA_OPTS="-XX:PermSize=128m -XX:MaxPermSize=384m -XX:NewSize=256m -Xmx1024m -server -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled"
export EDITOR=vim

#Start web server
alias http='python -m SimpleHTTPServer'

###############################  Grails  ##############################
source ~/.ted_grails_complete
export GRAILS_HOME='/usr/local/grails'
export GROOVY_HOME='/usr/local/groovy'
export SVN_EDITOR=vim

alias gr='grails run-app'
alias gd='grails-debug'
alias gu='grails test-app unit:'
alias gi='grails test-app integration:'

# aliases where you can optionally pass in a set of tests to run (or no argument to run all tests in that group)
alias gta=grailsTestApp
alias gtad=grailsTestAppDebug
alias gtau=grailsTestAppUnit
alias gtaud=grailsTestAppUnitDebug
alias gtai=grailsTestAppIntegration
alias gtaid=grailsTestAppIntegrationDebug

# aliases that will rerun any failed tests (or all tests if there aren't any failed tests)
alias gtaf=grailsTestAppFailed
alias gtadf=grailsTestAppDebugFailed
alias gtauf=grailsTestAppUnitFailed
alias gtaudf=grailsTestAppUnitDebugFailed
alias gtaif=grailsTestAppIntegrationFailed
alias gtaidf=grailsTestAppIntegrationDebugFailed
alias results='open target/test-reports/html/index.html'

#aiases for artifactory
alias mi='grails maven-install'

############################### Mysql ###############################
alias mysqlstart='sudo /Library/StartupItems/MySQLCOM/MySQLCOM start'
alias mysqlstop='sudo /Library/StartupItems/MySQLCOM/MySQLCOM stop'

################################Redis ###############################
alias redisstart='sudo launchctl start io.redis.redis-server'
alias redisstop='sudo launchctl stop io.redis.redis-server'

################################ Rabbit ###############################
alias rabbit='sudo /usr/local/Cellar/rabbitmq/2.8.4/sbin/rabbitmq-server'

################################ Mercurial ###############################
alias hs="hg status -S"
alias hb="hg branch"
alias ha="hg add -S"
alias ho="hg outgoing -S"
alias hi="hg incoming -S"
alias hd="hg diff -S"
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

alias v='mvim'
alias b="mvim -c 'cd ~/projects/bloom'"

#export HISTIGNORE="&:ls:exit:ll:v:hs:cdb:history"
alias mkdir='mkdir -p' #create intermediate directories
alias ll='ls -la'


export VIMCLOJURE_SERVER_JAR="$HOME/Dropbox/lib/server-2.3.0.jar"

source ~/.otherFunctions

#VI Mode
bindkey -v
bindkey -M main '\C-r' history-incremental-search-backward

# kill a process that matches a regex
killit() {
    # Kills any process that matches a regexp passed to it
    ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill
}

p() {
    ps -el | grep "$@"
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
source $HOME/projects/dotfiles/dependencies/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/projects/dotfiles/dependencies/zsh-history-substring-search/zsh-history-substring-search.zsh

#let XIKI_DIR=/Library/Ruby/Gems/1.8/gems/xiki-0.6.3
#source $XIKI_DIR/etc/vim/xiki.vim
# mkdir and cd
mkcd () { mkdir -p "$@" && cd "$@"; }

=======
let XIKI_DIR=/Library/Ruby/Gems/1.8/gems/xiki-0.6.3
source $XIKI_DIR/etc/vim/xiki.vim
>>>>>>> 5bc8745750a5d6c93688b6950d75c43ef7dfe800
