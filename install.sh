#!/bin/bash

DOTDIR="$(dirname "$(readlink -f "$0")")"

shopt -s extglob
GLOBIGNORE=".:.."

# arg1: dest dir
# argN: either absolute paths or relative to dotfiles dir
install_files() {
    mkdir -p "$1"
    cd "$1" || exit 1
    shift

    for i in "$@"; do
        # If path is relative, make it absolute using $DOTDIR
        if ! [[ "$i" = /* ]]; then
            i="$DOTDIR/$i"
        fi

        local filename="${i##*/}"
        if [[ -L "$filename" ]] && [[ "$(readlink "$filename")" == "$i" ]]; then
            echo "Link already exists for $i -> Skipped"
        else
            ln -svi -t . "$i"
        fi
    done

    cd - || exit 1
}

# arg1: relative source dir
# arg2: dest dir
install_dir() {
    install_files "$2" "$DOTDIR/$1/"*
}

cd "$DOTDIR" || exit 1
install_dir homedir "$HOME"
install_dir configdir "$HOME/.config"
install_dir ipython/profile_default "$HOME/.ipython/profile_default"
install_dir ipython/startup "$HOME/.ipython/profile_default/startup"
install_files "$HOME/.config/gtk-3.0/" gtk-3.0/gtk.css

read -r -p "Firefox profile name (leave empty to skip): " ffprofile
if [[ -n "$ffprofile" ]]; then
    install_files "$HOME/.mozilla/firefox/$ffprofile/chrome/" "firefox/userChrome.css"
fi
