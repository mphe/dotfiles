#!/bin/bash
export LANG="de_DE.UTF-8"

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ] && xmodmap "$usermodmap"

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

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

# fix telegram not inputting accents
# export QT_IM_MODULE=xim

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
xfdesktop --disable-wm-check --sm-client-disable &
xfce4-power-manager &
xpad &
~/git/xssstart/xssstart bash ~/git/xssstart/picom.sh &
# ibus-daemon -d

[[ -f ~/.cache/awesome/stdout ]] && mv ~/.cache/awesome/stdout ~/.cache/awesome/stdout.old
[[ -f ~/.cache/awesome/stderr ]] && mv ~/.cache/awesome/stderr ~/.cache/awesome/stderr.old

exec awesome > ~/.cache/awesome/stdout 2> ~/.cache/awesome/stderr
