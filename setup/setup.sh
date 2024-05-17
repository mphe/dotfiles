#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1
source util.sh

if question "Install general-use packages (requires yay)"; then
    ./setup-packages.sh
fi

if question "Install python packages"; then
    ./setup-python-packages.sh
fi

if question "Install Awesome WM Desktop Environment packages"; then
    ./setup-awesome-de.sh
fi

if question "Set alacritty as default terminal for nemo"; then
    gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e
fi

if question "Install send-with-telegram action for nemo"; then
    cp ../telegram-desktop-nemo-action/telegram-send.* ~/.local/share/nemo/actions
    chmod u+x ~/.local/share/nemo/actions/telegram-send.sh
fi


if question "Disable XFCE CSDs"; then
    xfconf-query -c xsettings -p /Gtk/DialogsUseHeader -s false
fi

question "Setup samba" && ./setup-samba.sh
question "Setup ssh" &&./setup-ssh.sh
question "Setup xampp" &&./setup-xampp.sh
question "Minimize hibernation image size" && sudo cp ./hibernation_image_size.conf /etc/tmpfiles.d/

if question "Disable sudo timeout"; then
    echo 'Defaults passwd_timeout=0' | sudo tee -a /etc/sudoers
fi

if question "Disable Discord auto-update"; then
    sed -i ~"/.config/discord/settings.json" '0,/{/s/{/{\n  "SKIP_HOST_UPDATE": true,/'
fi

exit 0
