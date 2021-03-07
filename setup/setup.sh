#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1
source util.sh

if question "Install packages (requires yay)"; then
    sed -r '/^\s*$/d' packages.txt | xargs yay -Sy --needed
fi

if question "Set alacritty as default terminal for nemo"; then
    gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e
fi

if question "Disable XFCE CSDs"; then
    xfconf-query -c xsettings -p /Gtk/DialogsUseHeader -s false
fi

question "Setup samba" && ./setup-samba.sh
question "Setup ssh" &&./setup-ssh.sh
question "Setup xampp" &&./setup-xampp.sh

return 0
