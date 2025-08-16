#!/usr/bin/env bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# if [[ -z "$TMUX" ]]; then
#     # Auto start tmux
#     exec tmux
# fi

alias ls='ls -h --color=always --group-directories-first'
alias ll='ls -l'
alias less='less -ri'
alias pacaur='yay'  # aliases work recursively
alias yay='yay --sudoloop --devel'
alias ranger='python3 $(which ranger)'
alias youtube-dl='youtube-dl -o "%(title)s.%(ext)s"'
alias cmake-debug='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug'
alias cmake-release='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release'
alias xclip='xclip -selection c'
alias g++='g++ -fdiagnostics-color=auto -Wall -Wno-switch -Wno-parentheses'
alias gcc='gcc -fdiagnostics-color=auto -Wall -Wno-switch'
alias gdbrun='gdb -ex run'
alias mkdir='mkdir -p'
alias cdir='switchdir'
alias make='make -j 6'
alias hibernate='sudo systemctl hibernate'
alias fmark='fpaste.sh mark'
alias fmove='fpaste.sh move'
alias fcopy='fpaste.sh copy'
alias flink='fpaste.sh link'
alias flist='fpaste.sh list'
# alias virtualenv='virtualenv --system-site-packages'
alias dd='dd status=progress bs=4M'
alias vimdiff='nvim -d'
alias gst='git status'
alias gcheckout='git checkout'
alias ssh='TERM=xterm ssh'
alias objdump='objdump -M intel'
alias httrack='httrack --disable-security-limits --max-rate=0'
alias grep='grep --exclude-dir=.git --exclude-dir=.mypy_cache --exclude-dir=.vs --color'
alias open='xdg-open'
alias audacity='env PULSE_LATENCY_MSEC=60 audacity'
# alias audacity='pasuspender -- audacity'
alias awconfig='vim ~/.config/awesome/rc.lua'
alias awrules='vim ~/.config/awesome/rules.lua'
alias awtheme='vim ~/.config/awesome/themes/custom/theme.lua'
alias r=ranger-cd
alias pylint='pylint --output-format colorized'
alias thesaur='aiksaurus'


# Automatically run ls after cd
cd() {
    command cd "$@" || return $?
    ls
}

mkcd() {
    # shellcheck disable=SC2164
    mkdir -p "$@" && cd "$1"
}

function wtfis() {
    curl "https://cheat.sh/$1"
}

# thefuck (slow as fuck startup)
# eval "$(thefuck --alias)"
alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1)) && eval $TF_CMD && history -s $TF_CMD'

# Enable checkwinsize so that bash will check the terminal size when
# it regains control. (http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11))
shopt -s checkwinsize

# Expand variables on tab complete
shopt -s direxpand

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
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] && echo "*"
}
parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
git_prompt() {
    git branch &> /dev/null && echo " ($(parse_git_branch))"
}

# fzf
set -o vi
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
elif [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi

if [ -f /usr/share/fzf/completion.bash ]; then
    source /usr/share/fzf/completion.bash
elif [ -f /usr/share/bash-completion/completions/fzf ]; then
    source /usr/share/bash-completion/completions/fzf
fi
export FZF_COMPLETION_TRIGGER=',,'
export FZF_DEFAULT_OPTS='--color=16'
_fzf_compgen_path() {
    bfs -L "$1" -path "*.ccache" -prune -o -path "*.git" -prune -o -path "*.config/teamviewer*" -prune -o -name "*" 2> /dev/null
    # ag --silent --hidden --ignore .git --ignore "*teamviewer10/dosdevices" -f -g "" "$1"
}
_fzf_compgen_dir() {
    bfs -L "$1" -path "*.ccache" -prune -o -path "*.git" -prune -o -path "*.config/teamviewer*" -prune -o -type d 2> /dev/null
}

# nvm (slow startup)
# source /usr/share/nvm/init-nvm.sh

# Retain cwd when opening new terminals
# http://unix.stackexchange.com/questions/93476/gnome-terminal-keep-track-of-directory-in-new-tab
if [ -f /etc/profile.d/vte.sh ]; then
    source /etc/profile.d/vte.sh
fi

export PROMPT_COMMAND=prompt_command

# [user@host path (branch)] [$?]$ 
prompt_command() {
    local err=$?

    # Must be called to retain working directory when opening new terminals
    # Only works in terminal emulators.
    [ "$(type -t __vte_osc7)" = "function" ] && __vte_osc7

    local reset="\[$RESET\]"
    local bold="\[$BOLD\]"
    local blue="\[$BLUE\]"
    local yellow="\[$YELLOW\]"
    local green="\[$GREEN\]"
    local red="\[$RED\]"
    local white="\[$WHITE\]"

    # Use short path if the full path is longer than half the terminal size
    local hw=$(($(tput cols) / 2))
    local path="\w"
    [ ${#PWD} -gt $hw ] && path="...${PWD:$((-$hw + 20))}"

    PS1=""
    PS1+="${reset}[$white$bold\u$reset@$white$bold\h $reset$blue$path$yellow\$(git_prompt)$reset]"
    # PS1="$reset[$bold\u@\h $blue\w$yellow\$(git_prompt)$reset]"

    # Fix virtualenv prompt when using PROMPT_COMMAND
    # https://stackoverflow.com/questions/14987013/why-is-virtualenv-not-setting-my-terminal-prompt
    if [ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ] ; then
        if [ "$(basename "$VIRTUAL_ENV")" = "__" ] ; then
            # special case for Aspen magic directories
            # see http://www.zetadev.com/software/aspen/
            PS1+=" ${green}[$(basename "$(dirname "$VIRTUAL_ENV")")]$reset"
        elif [ "$VIRTUAL_ENV" != "" ]; then
            PS1+=" $green($(basename "$VIRTUAL_ENV"))$reset"
        fi
    fi

    if [ $err -ne 0 ]; then
        PS1+="${red}[$err]$reset"
    fi

    PS1+="$bold\$ $reset"
}


# solarized dircolor (ls, usw)
eval "$(dircolors ~/.dir_colors/dircolors.ansi-dark)"
# eval $(dircolors ~/.dir_colors/dircolors_alt)

# This must come after setting dircolors, otherwise colors will be wrong.
# .inputrc is apparently executed before .bashrc, so this needs to be here.
bind 'set colored-stats On'
bind 'set colored-completion-prefix On'
bind 'set menu-complete-display-prefix On'

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
    # eval "$(pyenv virtualenv-init -)"
fi

# pipenv
# Takes ages to load
# eval "$(_PIPENV_COMPLETE=bash_source pipenv)"

# env vars
export LANG='en_US.UTF-8'
export PATH="/home/marvin/bin:/home/marvin/git/scripts/scripts:$PATH"
export PATH="/home/marvin/.gem/ruby/2.7.0/bin:$PATH"
export PATH="/home/marvin/.local/bin:$PATH"
export PATH="/home/marvin/golib/bin:$PATH"
export PATH="$PATH:/home/marvin/.cargo/bin"
export PATH="$PATH:/usr/lib/emscripten"
export EDITOR=nvim
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Scripted dotnet install to support maui.
# See https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install.
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"

# Needed for Unity development with vim using coc-omnisharp
# / at the end seems to be important
export FrameworkPathOverride=/lib/mono/4.7.1-api/


# disable flow control when using vim
vim () {
    local STTYOPTS="$(stty --save)"
    stty stop "" -ixoff
    command nvim "$@"
    stty "$STTYOPTS"
}


# Switch between src and include directory in a C++ project.
# If the destination path doesn't exist, it will be created.
switchdir() {
    if [[ -z $1 ]]; then
        if [[ "$PWD" =~ .*src.* ]]; then
            local src=crs
            local dest=edulcni
        elif [[ "$PWD" =~ .*include* ]]; then
            local src=edulcni
            local dest=crs
        else
            echo "Not inside include or src directory"
            return
        fi
    fi
    local dir="$(pwd | rev | sed -e "s/$src\//$dest\//" | rev)"
    mkdir -p "$dir"
    cd "$dir" || return 1
}


# Set window title to current command and to $PWD when finished
set_title() {
    [[ -z "$TMUX" ]] && echo -ne "\e]0;$*\007" || echo -ne "\033]2;$*\033\\"
}

preexec() {
    if [[ "$BASH_COMMAND" == "prompt_command" ]]; then
        set_title "$PWD"
    else
        set_title "$BASH_COMMAND"
    fi
}

trap preexec DEBUG

# activate virtualenv
# arg1: virtuelenv dir
activate() {
    local dir="$1"
    if [[ -z "$dir" ]]; then
        if [[ -d "venv" ]]; then
            dir="venv"
        elif [[ -d "virtualenv" ]]; then
            dir="virtualenv"
        fi
    fi
    source "$dir/bin/activate"
}

# https://unix.stackexchange.com/questions/342064/ranger-cd-into-a-folder-and-invoke-shell
function ranger-cd {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    "${ranger_cmd[@]}" "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}
