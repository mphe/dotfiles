#!/bin/bash
$HOME/.monicarc   #monitor calibration

export LANG="de_DE.UTF-8"

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

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
anamnesis --start
redshift &
albert &
nm-applet &
udiskie &
# dxreminders &
lxpolkit &
/home/marvin/bin/xfsettingsd --sm-client-disable
xfdesktop --disable-wm-check --sm-client-disable &
# ibus-daemon -d

[[ -f ~/.xprofile  ]] && source ~/.xprofile

exec awesome
