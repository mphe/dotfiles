#!/usr/bin/env bash

export LANG="de_DE.UTF-8"

[[ -f ~/.xprofile  ]] && source ~/.xprofile

# Launch DBus if needed
if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    if which dbus-launch >/dev/null; then
        eval "$(dbus-launch --sh-syntax --exit-with-session)"
    fi
else
    if which dbus-update-activation-environment >/dev/null; then
        dbus-update-activation-environment --systemd --all
    fi
fi

export XDG_CURRENT_DESKTOP="XFCE"

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

picom -b
parcellite &
redshift-gtk &
albert &
nm-applet &
udiskie &
lxpolkit &
xfsettingsd --sm-client-disable &
# xfdesktop --disable-wm-check --sm-client-disable &
xfdesktop --disable-wm-check &
xfce4-power-manager &
~/Dokumente/picom-flicker-workaround/run.sh &
xiccd &
# xpad &
# ibus-daemon -d
