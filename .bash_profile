export ANDROID_HOME=/opt/android-sdk
export MAIN=/mnt/iomega/Main
export IOMEGA=/mnt/iomega
export CPPLIB=/mnt/iomega/C++/lib
export SHARED=~/Shared
export EDITOR=vim
export GOPATH=~/golib

# force gtk2 for libreoffice
export SAL_USE_VCLPLUGIN=gtk

if [ $(tty) == "/dev/tty1" ]; then
    startx
else
    screenfetch
fi

source .bashrc
