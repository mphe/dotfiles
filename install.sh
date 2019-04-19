#!/bin/bash

dotdir="$(dirname "$(readlink -f "$0")")"
cd "$dotdir"

shopt -s extglob
GLOBIGNORE=".:.."

userhome=~


# arg1: relative source dir
# arg2: dest dir
install_dir() {
    mkdir -p "$2"
    cd "$2"
    ln -svi -t . "$dotdir/$1/"*
    cd -
}

install_dir homedir "$userhome"
install_dir configdir "$userhome/.config"
install_dir ipython/profile_default "$userhome/.ipython/profile_default"
