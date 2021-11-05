export ANDROID_HOME=/opt/android-sdk
export MAIN=/media/extdata/Main
export EDITOR=nvim
export GOPATH=~/golib
export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_AUTO_SCREEN_SCALE_FACTOR=1
# fix telegram not inputting accents
# export QT_IM_MODULE=xim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

source .profile


# force gtk2 for libreoffice
# export SAL_USE_VCLPLUGIN=gtk

if [ "$(tty)" = "/dev/tty1" ]; then
    startx
else
    :
    # neofetch
fi

source .bashrc
