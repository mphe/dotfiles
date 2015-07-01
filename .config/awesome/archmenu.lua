 local office = {
     {"Adobe Reader 9", "acroread ", "/usr/share/pixmaps/acroread.png" },
     {"Atril-Dokumentenbetrachter", "atril ", "/usr/share/icons/hicolor/16x16/apps/atril.png" },
     {"Calibre", "calibre --detach ", "/usr/share/pixmaps/calibre-gui.png" },
     {"FoxitReader", "foxitreader ", "/usr/share/pixmaps/foxitreader.png" },
     {"Okular", "okular   -caption Okular", "/usr/share/icons/hicolor/16x16/apps/okular.png" },
     {"E-book Viewer", "ebook-viewer --detach ", "/usr/share/pixmaps/calibre-viewer.png" },
     {"Edit E-book", "ebook-edit --detach ", "/usr/share/pixmaps/calibre-ebook-edit.png" },
     {"LibreOffice", "libreoffice ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-startcenter.png" },
     {"LibreOffice Base", "libreoffice --base ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-base.png" },
     {"LibreOffice Calc", "libreoffice --calc ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-calc.png" },
     {"LibreOffice Draw", "libreoffice --draw ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-draw.png" },
     {"LibreOffice Impress", "libreoffice --impress ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-impress.png" },
     {"LibreOffice Math", "libreoffice --math ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-math.png" },
     {"LibreOffice Writer", "libreoffice --writer ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-writer.png" },
     {"LyX Document Processor", "lyx ", "/usr/share/icons/hicolor/48x48/apps/lyx.png" },
 }

 local developement = {
     {"Vi IMproved", "gvim -f ", "/usr/share/pixmaps/gvim.png" },
     {"Android SDK", "android", "/usr/share/pixmaps/android-sdk.png" },
     {"Android Studio", "android-studio ", "/usr/share/pixmaps/android-studio.png" },
     {"CMake", "cmake-gui ", "/usr/share/icons/hicolor/32x32/apps/CMakeSetup.png" },
     {"Eclipse", "eclipse", "/usr/share/icons/hicolor/16x16/apps/eclipse.png" },
     {"Glade", "glade ", "/usr/share/icons/hicolor/16x16/apps/glade.png" },
     -- {"IPython2 Qt console", "ipython2 qtconsole", "/usr/share/icons/gnome/16x16/status/gnome-netstatus-idle.png" },
     -- {"Java Mission Control", "/usr/lib/jvm/java-8-jdk/bin/jmc", "/usr/share/icons/hicolor/16x16/apps/sun-java-jdk8.png" },
     -- {"Java Monitoring and Management Console", "/usr/lib/jvm/java-8-jdk/bin/jconsole", "/usr/share/icons/hicolor/16x16/apps/sun-java-jdk8.png" },
     -- {"Java VisualVM", "/usr/lib/jvm/java-8-jdk/bin/jvisualvm", "/usr/share/icons/hicolor/16x16/apps/sun-java-jdk8.png" },
     {"PyCharm", "/usr/bin/pycharm", "/usr/share/pixmaps/pycharm.png" },
     -- {"Qt4 Assistant ", "assistant-qt4", "/usr/share/icons/hicolor/32x32/apps/assistant-qt4.png" },
     -- {"Qt4 Designer", "designer-qt4", "/usr/share/icons/hicolor/128x128/apps/designer-qt4.png" },
     -- {"Qt4 Linguist ", "linguist-qt4", "/usr/share/icons/hicolor/16x16/apps/linguist-qt4.png" },
     -- {"Qt4 QDbusViewer ", "qdbusviewer-qt4", "/usr/share/icons/hicolor/32x32/apps/qdbusviewer-qt4.png" },
     {"ipython2", "termite -e ipython2", "/usr/share/icons/gnome/16x16/status/gnome-netstatus-idle.png" },
 }

 local graphic = {
     {"EOM-Bildbetrachter", "eom ", "/usr/share/icons/hicolor/16x16/apps/eom.png" },
     {"FontForge", "fontforge ", "/usr/share/icons/hicolor/16x16/apps/fontforge.png" },
     {"GNU Image Manipulation Program", "gimp-2.8 ", "/usr/share/icons/hicolor/16x16/apps/gimp.png" },
     {"Gpick", "gpick", "/usr/share/icons/hicolor/48x48/apps/gpick.png" },
     {"Inkscape", "inkscape ", "/usr/share/icons/hicolor/16x16/apps/inkscape.png" },
     {"Krita", "krita ", "/usr/share/icons/hicolor/16x16/apps/calligrakrita.png" },
     {"LRF Viewer", "lrfviewer ", "/usr/share/pixmaps/calibre-viewer.png" },
     {"XSane - Scanning", "xsane", "/usr/share/pixmaps/xsane.xpm" },
 }

 local internet = {
     -- {"Avahi SSH Server Browser", "/usr/bin/bssh", "/usr/share/icons/gnome/16x16/devices/network-wired.png" },
     -- {"Avahi VNC-Server-Browser", "/usr/bin/bvnc", "/usr/share/icons/gnome/16x16/devices/network-wired.png" },
     {"Deluge", "deluge-gtk ", "/usr/share/icons/hicolor/16x16/apps/deluge.png" },
     {"Ekiga-Softfon", "ekiga", "/usr/share/icons/hicolor/16x16/apps/ekiga.png" },
     {"Electrum Bitcoin Wallet", "electrum ", "/usr/share/pixmaps/electrum.png" },
     {"FileZilla", "filezilla", "/usr/share/icons/hicolor/16x16/apps/filezilla.png" },
     {"Firefox", "firefox ", "/usr/share/icons/hicolor/16x16/apps/firefox.png" },
     {"JDownloader", "JDownloader", "/usr/share/icons/hicolor/16x16/apps/jdownloader.png" },
     {"Skype", "skype40", "/usr/share/icons/hicolor/16x16/apps/skype.png" },
     {"Skype Bot", "skype40 --dbpath=/home/marvin/.Skype_bot", "/usr/share/icons/hicolor/16x16/apps/skype.png" },
     -- {"Skype", "skype ", "/usr/share/icons/hicolor/16x16/apps/skype.png" },
     {"Steam", "/home/marvin/bin/steamfix.sh ", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     -- {"Steam", "/usr/bin/steam ", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     {"TeamViewer 10", "/opt/teamviewer/tv_bin/script/teamviewer", "/opt/teamviewer/tv_bin/desktop/teamviewer.png" },
     {"Thunderbird", "thunderbird ", "/usr/share/icons/hicolor/16x16/apps/thunderbird.png" },
     {"Zenmap", "zenmap ", "/usr/share/zenmap/pixmaps/zenmap.png" },
     {"Zenmap (as root)", "/usr/share/zenmap/su-to-zenmap.sh ", "/usr/share/zenmap/pixmaps/zenmap.png" },
     {"Wireshark", "wireshark ", "/usr/share/icons/hicolor/16x16/apps/wireshark.png" },
 }

 local games = {
     {"Hotline Miami", "steam steam://rungameid/219150", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     {"M64Py", "m64py ", "/usr/share/pixmaps/m64py.png" },
     {"Mark of the Ninja", "steam steam://rungameid/214560", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     {"Snes9x", "snes9x-gtk ", "/usr/share/icons/hicolor/16x16/apps/snes9x.png" },
     {"Starbound", "steam steam://rungameid/211820", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     {"Steam", "/home/marvin/bin/steamfix.sh ", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     -- {"Steam", "/usr/bin/steam ", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
     {"Team Fortress 2", "steam steam://rungameid/440", "/usr/share/icons/hicolor/16x16/apps/steam.png" },
 }

 local systemtools = {
     {"dconf-Editor", "dconf-editor", "/usr/share/icons/hicolor/16x16/apps/dconf-editor.png" },
     {"Avahi Zeroconf Browser", "/usr/bin/avahi-discover", "/usr/share/icons/gnome/16x16/devices/network-wired.png" },
     {"GParted", "/usr/bin/gparted_polkit ", "/usr/share/icons/hicolor/16x16/apps/gparted.png" },
     {"Htop", "xterm -e htop", "/usr/share/pixmaps/htop.png" },
     {"LSHW", "/usr/sbin/gtk-lshw", "/usr/share/lshw/artwork/logo.svg" },
     {"Oracle VM VirtualBox", "VirtualBox ", "/usr/share/icons/hicolor/16x16/mimetypes/virtualbox.png" },
     {"Wireshark", "wireshark ", "/usr/share/icons/hicolor/16x16/apps/wireshark.png" },
     {"PCManFM Dateimanager", "pcmanfm ", "/usr/share/icons/gnome/16x16/apps/system-file-manager.png" },
     {"MATE-Terminal", "mate-terminal", "/usr/share/icons/gnome/16x16/apps/utilities-terminal.png" },
     {"Terminator", "terminator", "/usr/share/icons/hicolor/16x16/apps/terminator.png" },
     {"Termite", "termite", "/usr/share/icons/gnome/16x16/apps/utilities-terminal.png" },
     {"Tilda", "/usr/bin/tilda", "/usr/share/pixmaps/tilda.png" },
     {"UXTerm", "uxterm", "/usr/share/pixmaps/xterm-color_48x48.xpm" },
     {"XTerm", "xterm", "/usr/share/pixmaps/xterm-color_48x48.xpm" },
 }

 local multimedia = {
     {"Audacity", "env UBUNTU_MENUPROXY=0 audacity ", "/usr/share/icons/hicolor/16x16/apps/audacity.png" },
     {"Brasero", "brasero ", "/usr/share/icons/hicolor/16x16/apps/brasero.png" },
     {"Cheese", "cheese", "/usr/share/icons/hicolor/16x16/apps/cheese.png" },
     {"OpenShot Video Editor", "openshot ", "/usr/share/pixmaps/openshot.svg" },
     {"Qt V4L2 test Utility", "qv4l2", "/usr/share/icons/hicolor/16x16/apps/qv4l2.png" },
     {"VLC Media Player", "/usr/bin/vlc --started-from-file ", "/usr/share/icons/hicolor/16x16/apps/vlc.png" },
     {"Winff", "winff", "/usr/share/icons/hicolor/16x16/apps/winff.png" },
     {"gtk-recordMyDesktop", "gtk-recordMyDesktop", "/usr/share/pixmaps/gtk-recordmydesktop.png" },
     {"harmonySEQ", "/usr/bin/harmonySEQ ", "/usr/share/icons/hicolor/scalable/apps/harmonyseq.svg" },
 }

 local accessories = {
     {"Engrampa-Archivverwaltung", "engrampa ", "/usr/share/icons/hicolor/16x16/apps/engrampa.png" },
     {"Galculator", "galculator", "/usr/share/icons/hicolor/48x48/apps/galculator.png" },
     -- {"IPython2 Qt console", "ipython2 qtconsole", "/usr/share/icons/gnome/16x16/status/gnome-netstatus-idle.png" },
     {"Pluma", "pluma ", "/usr/share/icons/gnome/16x16/apps/accessories-text-editor.png" },
     {"Shutter", "shutter ", "/usr/share/icons/hicolor/16x16/apps/shutter.png" },
 }

xdgmenu = {
    {"Office", office},
    {"Entwicklung", developement},
    {"Grafik", graphic},
    {"Internet", internet},
    {"Multimedia", multimedia},
    {"Spiele", games},
    {"Systemwerkzeuge", systemtools},
    {"Zubehör", accessories},
}

