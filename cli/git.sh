#!/bin/bash
alias V="mvim -c 'cd $CURRENT_PROJECT_DIR'"
export git_username=ShaunJurgemeyer
alias githelp='echo \
"Custom Git functions
--------------------
git-reset-origin branchName - remove the specified branch and checkout from origin
git-reset-upstream branchName - remove the specified branch and checkout from upstream
git-dev-diff - Diff the current branch against upstream develop
git-dev-diff - Show the changes from upstream/develop to the current branch
cleanupBranches - For all branches local and origin, give a Y/n option to delete (will checkout master)
"'

#DOC Update all all projects in $CURRENT_PROJECT_ALL_ROOTS to master
function git-master() {
    checkoutUpdateFromUpstreamAll master
}

#DOC hard reset all all projects in $CURRENT_PROJECT_ALL_ROOTS to the origin version of the branch
function git-reset-origin() {
    resetFromOrigin $1
}

#DOC hard reset all all projects in $CURRENT_PROJECT_ALL_ROOTS to the upstream version of the branch
function git-reset-upstream() {
    resetFromUpstream $1
}

#DOC checkout the provided branch on all projects in $CURRENT_PROJECT_ALL_ROOTS
function checkoutAll() {
    logStartFunction
    for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Updating $project to $1"
        cd $CURRENT_PROJECT_DIR/$project
        git checkout $1
    done
    logEndFunction
}

#DOC hard reset local branch to the upstream version
function resetFromUpstream() {
    logStartFunction
    git fetch upstream $1
    git branch -D $1
    git checkout -b $1 upstream/$1
    logEndFunction
}

#DOC hard reset all local branches to the upstream versions
function resetFromUpstreamAll() {
    # logStartFunction
    for project in $CURRENT_PROJECT_ALL_ROOTS; do
        echom "Resetting $project $1"
        cd $CURRENT_PROJECT_DIR/$project
        resetFromUpstream $1
    done
    # logEndFunction
}

#DOC hard reset all local branches to the origin versions
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

#DOC checkout branch and update from upstream for all projects in $CURRENT_PROJECT_ALL_ROOTS
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


#DOC Get the status of all projects in $CURRENT_PROJECT_ALL_ROOTS
function statusAll() {
    gitAll status
}

#DOC diff all projects in $CURRENT_PROJECT_ALL_ROOTS
function diffAll() {
    gitAll diff
}

#DOC fetch all projects in $CURRENT_PROJECT_ALL_ROOTS
function fetchAll() {
    gitAll fetch --all
}

#DOC do the provided operation on all projects in $CURRENT_PROJECT_ALL_ROOTS
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

#DOC Delete all branches that have been merged to master
function cleanBranches() {
  git branch --merged | grep -v "master|release|\*" | grep -v "\*" | xargs -n 1 git branch -d
  echo "=============="
  git branch -vv
}

#DOC Interactive cleanup of local and remote branches
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

#DOC create and checkout a new branch based off of local master
function gitb() {
	git checkout master
	git checkout -b $1
}


#DOC open target github for the current branch
function thub() {
  h=`git config --get remote.origin.url`
  p=${h%.*}
  open "http://git.target.com/$git_username/${PWD##*/}/tree/`git rev-parse --abbrev-ref HEAD`"
}

#DOC List changes since a revision with author included
function changesSinceAuthor() {
    git fetch upstream
    git log --no-merges --format="%s - %an" $1...upstream/master --
}

#DOC List changes since a revision
function changesSince() {
    git fetch upstream
    git log --no-merges --format="%s" $1...upstream/master
}

#DOC List changes between two provided revisions
function changesBetween() {
    git fetch upstream
    git log --no-merges --format="%s" v$1...v$2
}

#DOC List Contributors to files filtered by provided regex
function gitAuthors() {
    git ls-tree --name-only -r HEAD | grep -E $1 | xargs -n1 git blame --line-porcelain | grep "^author "|sort|uniq -c|sort -nr
}

#DOC delete and recreate an branch
function gitdb() {
    git d $1
    git b $1
}

#DOC Clone a repo with upstream and origin
function cloneRepo() {
    project=`echo "$1" | sed -En 's/.*\/(.*).git$/\1/p'`
    base=`echo "$1" | sed -En 's/(.*):.*.git$/\1/p'`

    if [ ! -d "$newdir" ]; then
        git clone $1
        cd $project
        git remote rename origin upstream
        git remote add origin $base:$git_username/$project.git
        cd -
    fi
}

#DOC reset the current branch, and get the latest master
function gitResetMaster() {
    git reset --hard
    gitUpstreamMaster
}

#DOC reset the current branch, and get the latest master, then pop stashed changes
function gitStashResetMaster() {
    git stash -u
    gitResetMaster
    git pop
}

#DOC Move to main and update to latest from upstream
function gum() {
    if [[ `git status --porcelain` ]]; then
        echo "Changes exist to current branch, exiting"
    else
        git checkout main
        git fetch upstream
        git pull upstream main
    fi
}

#DOC Move to master and update to latest from upstream
function gitUpstreamMaster() {
    if [[ `git status --porcelain` ]]; then
        echo "Changes exist to current branch, exiting"
    else
        git checkout master
        git fetch upstream
        git pull upstream master
    fi
}

#DOC List all branches with the latest commit details, sorted by last updated time
function branches() {
    git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

#DOC Add a remote based on current origin for a different user
function addRemote() {
    if [ -z "$1" ]; then
        echo "Usage addRemote remote_user [fork_name=remote_user]"
        return
    fi
    remote_user=$1
    remote_name=$2
    if [ -z "$remote_name" ]; then
        remote_name=$remote_user
    fi
    new_remote=`git remote -v | grep -m 1 origin | sed -En 's/origin[\s]*(.*\.git).*$/\1/p' | sed -En 's/^[[:space:]]*(.*)'"$git_username"'(.*)/\1'"$1"'\2/p'`
    git remote add $remote_name $new_remote
    echo Added remote $remote_name for $new_remote
}
