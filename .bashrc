start_time=$(date +%s%N)

# kitty (and possibly other GUI-launched terminals) can inherit a stale
# $SHELL from before `chsh` ran and doesn't correct it to match the actual
# shell being exec'd — self-correct here rather than trust inheritance.
export SHELL=/opt/homebrew/bin/bash

export PROJECT_DIR=$HOME/projects
export DOTFILES_DIR=$PROJECT_DIR/dotfiles
export PATH=$HOME/.rvm/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/usr/local/share/npm/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/usr/local/groovy/bin:/usr/local/mysql/bin:/usr/local/tomcat/bin:/usr/local/scripts:/usr/local/gradle/bin:/usr/local/Cellar/ruby/2.0.0-p247/bin:$HOME/.node/bin:$HOME/app/dasht-2.0.0/bin:/usr/local/Cellar/ctags/5.8_1/bin/:~/Library/Python/3.9/bin:$DOTFILES_DIR/cli/:/usr/local/lib/docker/cli-plugins:/Applications/Docker.app/Contents//Resources/bin/:/Users/sjurgemeyer/nvim_nightly/bin/:$HOME/go/bin:/opt/homebrew/Cellar/dateutils/0.4.11/bin/:$PROJECT_DIR/screenpipe-scripts/:/opt/homebrew/bin:/.local/bin:$HOME/.local/bin:/Users/sjurgemeyer/Library/Python/3.9/bin:/opt/homebrew/opt/rustup/bin:/opt/homebrew/opt/trash-cli/bin/:$PATH
shopt -s autocd

#VI/VIM defaults
export EDITOR=nvim
export XDG_CONFIG_HOME=$HOME/.config/

# use better versions of commands
alias cat=bat
alias ls=lsd
alias ll='lsd -la'
alias rm='/opt/homebrew/opt/trash-cli/bin/trash'
alias trash='/opt/homebrew/opt/trash-cli/bin/trash'

alias ping='prettyping --nolegend'
alias top=htop
alias diff=diff-so-fancy
alias python=python3

# fzf functions
alias preview="fzf --preview 'bat --color \"always\" {}'"
# add support for ctrl+o to open selected file in VS Code
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort' --history=$HOME/.fzf_history"
export FZF_DEFAULT_COMMAND='rg --files'
alias x=exit

fid() {
  local out file key
  IFS=$'\n' out=("$(fzf-tmux --preview="bat {} --color=always" --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}
eval "$(fzf --bash)"
#end fzf functions

export PROJECT_DIR=$HOME/projects
export DOTFILES_DIR=$PROJECT_DIR/dotfiles

source ~/.otherFunctions
source $DOTFILES_DIR/cli/json.sh
source $DOTFILES_DIR/cli/prreview.sh
[ -f $DOTFILES_DIR/cli/wt.sh ] && source $DOTFILES_DIR/cli/wt.sh
[ -f $DOTFILES_DIR/cli/adgroups.sh ] && source $DOTFILES_DIR/cli/adgroups.sh

alias serve='python -m SimpleHTTPServer'

################################ Git ###############################
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
export GITHUB_TOKEN=$(gh auth token)

# bash completion (needed before flyline extends it)
[ -f /opt/homebrew/etc/profile.d/bash_completion.sh ] && source /opt/homebrew/etc/profile.d/bash_completion.sh
[ -f $DOTFILES_DIR/.git-completion.bash ] && source $DOTFILES_DIR/.git-completion.bash

alias dot='cd $DOTFILES_DIR'
alias tozsh='exec zsh'
alias mkdir='mkdir -p' #create intermediate directories
# mkdir and cd
mkcd () { mkdir -p "$@" && cd "$@"; }

# grep for process
function p() {
 ps -el | grep "$@"
}

# Allow for more open files on OSX
ulimit -S -n 10000

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# eval "$(navi widget bash)"
eval "$(starship init bash)"


# bun - typescript
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#  # pyenv - adds ~200ms
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - bash)"


# TODO: bash completion for cortex CLI — investigate (zsh version sourced ~/.zsh/completions/cortex.zsh)
alias afdev='eval "$(aws configure export-credentials --profile dev --format env)" && flowrs run'
alias afqa='eval "$(aws configure export-credentials --profile qa --format env)" && flowrs run'
alias afprod='eval "$(aws configure export-credentials --profile prod --format env)" && flowrs run'

end_time=$(date +%s%N)
elapsed=$(( (end_time - start_time) / 1000000 ))
echo "Startup time: ${elapsed}ms"

eval "$(zoxide init bash)"

# Flyline - enhanced Bash experience
if [[ $- != *i* ]]; then return; fi
# enable -f /Users/sjurgemeyer/.local/lib/libflyline.dylib flyline  # official release build
enable -f /Users/sjurgemeyer/projects/flyline/target/release/libflyline.dylib flyline # local flyline
source $DOTFILES_DIR/cli/flyline-settings.sh


# gpr — open the current branch's PR if it exists, else GitHub's compare view
gpr() {
  gh pr view --web 2>/dev/null && return
  local branch repo
  branch=$(git branch --show-current) || return
  repo=$(gh repo view --json url -q .url) || return
  open "$repo/compare/main...$branch"
}

# Auto-activate .venv/.env if this shell started inside a wtm worktree.
# (Placed last so it runs after every PATH modification above.)
type wt_autoactivate >/dev/null 2>&1 && wt_autoactivate

# Flyline - enhanced Bash experience
enable flyline 2>/dev/null || enable -f "/Users/sjurgemeyer/.local/lib/libflyline.dylib" flyline
