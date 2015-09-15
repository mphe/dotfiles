export ANDROID_HOME="/opt/android-sdk"

export MAIN=/mnt/iomega/Main
export CPPLIB=/mnt/iomega/C++/lib
export SHARED=~/Shared

if [ $(tty) == "/dev/tty1" ]; then
    startx
else
    screenfetch
fi

source .bashrc
