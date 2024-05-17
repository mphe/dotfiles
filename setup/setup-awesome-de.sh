#!/usr/bin/env bash

sudo yay -Sy --neded \
    celluloid \
    albert-git \
    awesome \
    picom \
    udiskie \
    gnome-keyring \
    parcellite \
    redshift-gtk-git \
    network-manager-applet \
    i3lock \
    light \
    maim \
    psensor \
    nemo \
    evince \
    xorg-xprop \
    xorg-xset \
    xorg-setxkbmap \
    xorg-xrdb \
    xorg-xmodmap \
    xfce4-settings \
    xfce4-dev-tools \
    xfdesktop \
    tumbler \
    xiccd

pip install --user notify_send_py --break-system-packages
