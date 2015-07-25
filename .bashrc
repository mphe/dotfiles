#
# ~/.bashrc
#

# 256 colors
export TERM=xterm-256color

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Auto start tmux
[[ -z "$TMUX"  ]] && exec tmux


alias ls='ls --color=always'
alias less='less -r'
alias pacaur='pacaur --noedit'
alias android-studio='JAVA_HOME=/usr/lib/jvm/java-8-jdk android-studio'
alias idea.sh='JAVA_HOME=/usr/lib/jvm/java-8-jdk idea.sh'
alias ranger='python3 $(which ranger)'

# Set git language to English
alias git='LC_ALL=en_GB.UTF-8 git'


# colors
BASE0="$(tput setaf 244)"
BASE1="$(tput setaf 245)"
BASE2="$(tput setaf 254)"
BASE3="$(tput setaf 230)"
YELLOW="$(tput setaf 136)"
ORANGE="$(tput setaf 166)"
RED="$(tput setaf 160)"
MAGENTA="$(tput setaf 125)"
VIOLET="$(tput setaf 61)"
BLUE="$(tput setaf 33)"
CYAN="$(tput setaf 37)"
GREEN="$(tput setaf 64)"
BOLD="$(tput bold)"
RESET="$(tput sgr0)"


# Git prompt stuff
parse_git_dirty () {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}
parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
git_prompt() {
    git branch &> /dev/null && echo " ($(parse_git_branch))"
}

export PROMPT_COMMAND=prompt_command

# [user@host path (branch)] [$?]$ 
prompt_command() {
    local err=$?
    local reset="\[$RESET\]"
    local bold="\[$BOLD\]"
    local blue="\[$BLUE\]"
    local yellow="\[$YELLOW\]"
    local red="\[$RED\]"
    PS1="$reset[$bold\u@\h $blue\w$yellow\$(git_prompt)$reset]"
    
    if [ $err -ne 0 ]; then
        PS1+="$bold$red[$err]$reset"
    fi

    PS1+="$bold\$ $reset"
}


# solarized dircolor (ls, usw)
eval $(dircolors /usr/share/dircolors/dircolors.ansi-dark)


# env vars
export PATH="$PATH:~/bin"
export PYTHONPATH="$PYTHONPATH:/mnt/iomega/Python/lib"

export MAIN=/mnt/iomega/Main
export CPPLIB=/mnt/iomega/C++/lib
export SHARED=~/Shared

# disable flow control when using vim
vim () {
    local STTYOPTS="$(stty --save)"
    stty stop "" -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

