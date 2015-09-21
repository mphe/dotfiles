#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -z "$TMUX" ]]; then
    # 256 colors
    export TERM=xterm-256color

    # Auto start tmux
    # exec tmux
fi

alias ls='ls --color=always'
alias less='less -r'
alias pacaur='pacaur --noedit'
alias android-studio='JAVA_HOME=/usr/lib/jvm/java-8-jdk android-studio'
alias idea.sh='JAVA_HOME=/usr/lib/jvm/java-8-jdk idea.sh'
alias ranger='python3 $(which ranger)'
alias youtube-dl='youtube-dl -o "%(title)s.%(ext)s"'
alias cmake-debug='cmake -DCMAKE_BUILD_TYPE=Debug'
alias cmake-release='cmake -DCMAKE_BUILD_TYPE=Release'

# Set git language to English
alias git='LANG=en_US.UTF-8 git'

# Enable checkwinsize so that bash will check the terminal size when
# it regains control. (http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11))
shopt -s checkwinsize


# colors
BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
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
    PS1="$reset[$bold\u@\h$reset $blue\w$yellow\$(git_prompt)$reset]"
    # PS1="$reset[$bold\u@\h $blue\w$yellow\$(git_prompt)$reset]"
    
    if [ $err -ne 0 ]; then
        PS1+="$bold$red[$err]$reset"
    fi

    PS1+="$bold\$ $reset"
}


# solarized dircolor (ls, usw)
eval $(dircolors ~/.dir_colors/dircolors.ansi-dark)
# eval $(dircolors ~/.dir_colors/dircolors_alt)


# env vars
export PATH="$PATH:~/bin"
export PYTHONPATH="$PYTHONPATH:/mnt/iomega/Python/lib"

# disable flow control when using vim
vim () {
    local STTYOPTS="$(stty --save)"
    stty stop "" -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}


# Set window title to current command and to $PWD when finished
set_title() {
    [[ -z "$TMUX" ]] && echo -ne "\e]0;$*\007" || echo -ne "\033]2;$*\033\\"
}

preexec() {
    [[ "$BASH_COMMAND" == "prompt_command" ]] && set_title $PWD || set_title $BASH_COMMAND
}

trap preexec DEBUG
