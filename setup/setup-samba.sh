#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")" || exit 1
source util.sh

# TODO: setup smb.conf

if question "Setup samba usershares"; then
    sudo mkdir /var/lib/samba/usershares
    sudo groupadd -r sambashare
    sudo chown root:sambashare /var/lib/samba/usershares/
    sudo chmod 1770 /var/lib/samba/usershares/
    sudo gpasswd sambashare -a "$USER"

    echo "Add this to /etc/samba/smb.conf:"
    echo "[global]"
    echo "  usershare path = /var/lib/samba/usershares"
    echo "  usershare max shares = 100"
    echo "  usershare allow guests = yes"
    echo "  usershare owner only = yes"

    echo "Press enter to open file..."
    read -r
    sudo -e /etc/samba/smb.conf

    echo "Restarting samba daemon..."
    sudo systemctl restart smb nmb
fi

if question "Setup wsdd for samba"; then
    sudo yay -S wsdd
    sudo systemctl enable wsdd
    sudo systemctl start wsdd
    echo "See here for firewall config: https://github.com/christgau/wsdd"
fi
