#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1

source ../setup/util.sh

if question "Install 'klassy'"; then
    cd ./klassy || exit 1
    git checkout 6.1.breeze6.0.3
    ./install.sh
    cd - || exit 1
fi

if question "Load config (konsave)"; then
    konsave -i kde.knsv
    konsave -a kde
fi

if question "Disable Meta key opening the application menu"; then
    kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""
fi

CUSTOM_THEME_PATH=~"/.local/share/plasma/desktoptheme/custom_breeze"

if question "Install custom breeze theme"; then
    if [ -d "$CUSTOM_THEME_PATH" ]; then
        if question "Theme folder exists. Remove and replace with symlink"; then
            rm -rv "$CUSTOM_THEME_PATH"
            ln -s "$PWD/desktoptheme/custom_breeze" "$CUSTOM_THEME_PATH"
        fi
    fi
fi

