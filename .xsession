#!/bin/sh

xset m 4/3 4 # mouse sensitivity
xset r rate 300 30 # key repeat rate
xset dpms 1800 1800 1800 # set dpms timeout to 30 minutes
xset s off # disable screensaver
setxkbmap de
xmodmap -e 'keysym Menu = Super_L'
[[ -f ~/.Xresources  ]] && xrdb -merge -I$HOME ~/.Xresources
syndaemon -dKi 2
xrandr --output LVDS1 --auto --pos 1920x312 --output VGA1 --pos 0x0
