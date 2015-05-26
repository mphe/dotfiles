#!/bin/bash

shopt -s extglob

homedir=~
dotdir="$(dirname "$(readlink -f "$0")")" 

# A (blacklist) pattern to match all files that will be automatically linked to $homedir.
files=(!(.|..|.git|.gitignore|README|LICENSE|install.sh|.config))

install() {
    ln -svT "$PWD/$1" "$homedir/$i"
}
uninstall() {
    rm -v "$homedir/$1"
}

cd "$dotdir"

f=install
if [ "$1" = "--uninstall" -o "$1" = "-u" ]; then
    f=uninstall
fi

for i in "${files[@]}"; do
    $f "$i"
done

mkdir -pv "$homedir/.config"
for i in .config/*; do
    $f "$i"
done
