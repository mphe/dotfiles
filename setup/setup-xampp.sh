#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1
source util.sh

echo Download and install from here: https://www.apachefriends.org/de/index.html

question "Continue"

read -rp "Symlink to PATH directory (optional): " binpath
if [[ -n "$binpath" ]]; then
    ln -sv /opt/lampp/xampp "$(realpath "$binpath")"
    ln -sv /opt/lampp/manager-linux-x64.run "$(realpath "$binpath/xampp-control-panel")"
fi

echo "Installing .desktop file"
ln -sv "$PWD/xampp.desktop" ~/.local/share/applications/


