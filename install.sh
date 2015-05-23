#!/bin/bash

homedir=~


install() {
    echo "Linking $PWD/$1 to $homedir/$1"
    ln -s "$PWD/$1" "$homedir/$1"
}

uninstall() {
    echo "Removing $homedir/$1"
    rm "$homedir/$1"
}


f=install
if [ "$1" = "--uninstall" -o "$1" = "-u" ]; then
    f=uninstall
fi

cd "$(dirname "$(readlink -f "$0")")" 
shopt -s extglob

for i in !(.|..|.git|.gitignore|install.sh|README|LICENSE); do
    $f "$i"
done

