#!/bin/sh

xset m 4/3 4 # mouse sensitivity
xset r rate 300 30 # key repeat rate
# xset dpms 0 0 0 # turn off dpms
setxkbmap de
xmodmap -e 'keysym Menu = Super_L'
syndaemon -dKi 2
