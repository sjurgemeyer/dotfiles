alias V="mvim -c 'cd $CURRENT_PROJECT_DIR'"

alias githelp='echo \
"Custom Git functions
--------------------
git-reset-origin branchName - remove the specified branch and checkout from origin
git-reset-upstream branchName - remove the specified branch and checkout from upstream
git-dev-diff - Diff the current branch against upstream develop
git-dev-diff - Show the changes from upstream/develop to the current branch
cleanupBranches - For all branches local and origin, give a Y/n option to delete (will checkout master)
"'

function git-update() {
	git checkout master
	git pull upstream master
	git checkout release
	git pull upstream release
}

function git-dev() {
    checkoutUpdateFromUpstreamAll develop
}

function git-master() {
    checkoutUpdateFromUpstreamAll master
}

function git-reset-origin() {
    resetFromOrigin $1
}

function git-dev-diff() {
    git fetch upstream
    git diff upstream/develop..$1
}

function git-dev-log() {
    git fetch upstream
    git log upstream/develop..$1
}

function git-reset-upstream() {
    resetFromUpstream $1
}

function checkoutAll() {
    logStartFunction
    for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Updating $project to $1"
        cd $CURRENT_PROJECT_DIR/$project
        git checkout $1
    done
    logEndFunction
}

function resetFromUpstream() {
    logStartFunction
    git fetch upstream $1
    git branch -D $1
    git checkout -b $1 upstream/$1
    logEndFunction
}

function resetFromUpstreamAll() {
    # logStartFunction
    for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Resetting $project $1"
        cd $CURRENT_PROJECT_DIR/$project
        resetFromUpstream $1
    done
    # logEndFunction
}

function resetFromOrigin() {
    logStartFunction
    git fetch origin $1
    git branch -D $1
    git checkout -b $1 origin/$1
    logEndFunction
}


function resetFromOriginAll() {
    logStartFunction
    checkoutAll devleop
    for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Updating $project to $1"
        cd $CURRENT_PROJECT_DIR/$project
        git branch -D $1
        git fetch --all
        git checkout -b $1 origin/$1
    done
    logEndFunction
}

function checkoutUpdateFromUpstreamAll() {
    logStartFunction
    for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Updating $project to $1"
        cd $CURRENT_PROJECT_DIR/$project
        git checkout $1
        echom "Pulling $project from upstream"
        git fetch upstream
        git pull upstream $1
    done
    logEndFunction
}


function statusAll() {
    gitAll status
}

function diffAll() {
    gitAll diff
}
function fetchAll() {
    gitAll fetch --all
}

function gitAll {
     logStartFunction
     for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Calling $1 for $project"
        cd $CURRENT_PROJECT_DIR/$project
        git $1
        if [ $? -ne 0 ]
        then
            if [[ -n "$2" ]]
            then
                echoe "Error calling $1 for $project"
                break
            fi
        fi
    done
    logEndFunction
}


function echoe() {
    echo
    echo "$fg[red]***** "$1" ***** $reset_color"
}

function echom() {
    echo
    echo "$fg[blue]***** "$1" ***** $reset_color"
}

function logStartFunction() {
    TEMP_CURRENT_DIR=`pwd`
    T="$(($(date +%s)))"
}

function logEndFunction() {
    cd $TEMP_CURRENT_DIR
    TEMP_CURRENT_DIR=
    T="$(($(date +%s)-T))"
    T=`printf "%02d:%02d:%02d\n" "$((T/3600%24))" "$((T/60%60))" "$((T%60))"`
    echom "Total Time: ${T}"
}

function cleanBranches() {
  git branch --merged | grep -v "master|release|\*" | grep -v "\*" | xargs -n 1 git branch -d
  echo "=============="
  git branch -vv
}

function cleanupBranches() {
    git remote prune origin
    git remote prune upstream
    git checkout master
	git branch --merged | grep -v "master|release|\*" | grep -v "\*" | xargs -n 1 git branch -d
    for i in `git -c color.status=false branch -a | sed 's/.* //' | egrep -v ".*HEAD.*|.*upstream/.*"`; do
        echo -e "\nDelete branch $i? (Y)es/(n)o/(c)ancel"
        read foo
        if [ "$foo" = "Y" ]; then
            echo -e "\n"
            if [[ "$i" =~ remotes/origin.* ]]; then
                export BRANCHNAME=`echo "$i" | sed 's/remotes\/origin\/\(.*$\)/\1/'`
                # Delete branch on origin
                git push origin :$BRANCHNAME
            else
                # Delete local branch
                git branch -D $i
            fi
        else
            if [ "$confirm" = "c" ]; then
                echo -e "\nCancelling delete branch script"
                exit 0
            fi
        fi
    done
    echo -e "\n"
    echo "Cleanup complete"
    git branch -a
}

function gitb() {
	git checkout master
	git checkout -b $1
}

function lab() {
  h=`git config --get remote.origin.url`
  p=${h%.*}
  open "$p/tree/`git rev-parse --abbrev-ref HEAD`"
}

function thub() {
  h=`git config --get remote.origin.url`
  p=${h%.*}
  open "http://git.target.com/ShaunJurgemeyer/${PWD##*/}/tree/`git rev-parse --abbrev-ref HEAD`"
}


function changesSinceAuthor() {
    git fetch upstream
    git log --no-merges --format="%s - %an" v$1...upstream/master
}
function changesSince() {
    git fetch upstream
    git log --no-merges --format="%s" v$1...upstream/master
}

function changesBetween() {
    git fetch upstream
    git log --no-merges --format="%s" v$1...v$2
}
function gitAuthors() {
    git ls-tree --name-only -r HEAD | grep -E $1 | xargs -n1 git blame --line-porcelain | grep "^author "|sort|uniq -c|sort -nr
}

function gitdb() {
    git d $1
    git b $1
}

function cloneRepo() {
    project=`echo "$1" | sed -En 's/.*\/(.*).git$/\1/p'`
    base=`echo "$1" | sed -En 's/(.*):.*.git$/\1/p'`

    if [ ! -d "$newdir" ]; then
        git clone $1
        cd $project
        git remote rename origin upstream
        git remote add origin $base:ShaunJurgemeyer/$project.git
        cd -
    fi
}
