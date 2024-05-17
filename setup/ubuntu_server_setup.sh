#!/bin/bash

# shellcheck disable=SC2155

WWW_DIR=/var/www
SSH_CONFIG=/etc/ssh/sshd_config
SSH_PORT=22

EDITOR="${EDITOR:-vim}"
APT_UPDATE=false

OPTIONS=(
    upgrade_system
    setup_software
    set_timezone
    setup_locale
    setup_users
    setup_groups
    setup_smtp
    setup_auto_updates
    setup_apache
    setup_ssh
    setup_firewall
    setup_swap
    setup_steam
    setup_gitlab
    run_reboot
    restart_sshd
)

OPTION_NAMES=(
    "Upgrade system"
    "Install basic software (sudo, python, pip, vim, tmux, ...)"
    "Set timezone"
    "Add german locale"
    "Add/Edit user(s)"
    "Add group(s)"
    "Setup E-Mail sending (using msmtp)"
    "Setup automatic stable updates"
    "Setup LAMP Stack (Apache, PHP, MySQL)"
    "Configure SSH"
    "Configure firewall"
    "Create swapfile"
    "Setup steam"
    "Setup GitLab"
    "Reboot"
    "Restart SSH daemon"
)

main() {
    if [ "$USER" != "root" ]; then
        echo "Error: Needs root"
        exit 1
    fi

    while true; do
        echo
        echo "Options"
        echo "======="

        for i in "${!OPTION_NAMES[@]}"; do
            echo "$i) ${OPTION_NAMES[$i]}"
        done
        echo

        local selection=""

        while [ -z "$selection" ] || [ "$selection" -lt 0 ] || [ "$selection" -ge "${#OPTIONS[@]}" ]; do
            selection="$(prompt "Selection")"
        done

        echo
        ${OPTIONS[$selection]}
    done
}


upgrade_system() {
    apt_update && apt upgrade && apt dist-upgrade
}

set_timezone() {
    dpkg-reconfigure tzdata
}

setup_swap() {
    create_swapfile "$(prompt "Size in GB" 1)"
}

run_reboot() {
    systemctl reboot
}

restart_sshd() {
    systemctl restart sshd
}


apt_update() {
    $APT_UPDATE || apt update
    APT_UPDATE=true
}

# Prompt user for text
# arg1: Prompt text
# arg2: Default value
# argN: Additional flags for read command
prompt() {
    local text="$1"
    shift
    local default="$1"  # shift 2 afterwards does not seem to work when no second argument is given
    shift

    local INPUT
    if [ -z "$default" ]; then
        read "$@" -p "$text: " -r INPUT
    else
        read "$@" -p "$text (Default: $default): " -r INPUT
    fi

    if [ -z "$INPUT" ]; then
        INPUT="$default"
    fi
    echo -n "$INPUT"
}

# arg1: text
# arg2..N: option 1-N
# Returns the number of choice (NOT on stdout)
choice() {
    echo
    echo -e "$1"
    shift

    local counter=1
    while [ -n "$1" ]; do
        echo "$counter) $1"
        ((counter += 1))
        shift
    done

    while true; do
        local ans="$(prompt "Your choice")"
        if [ "$ans" -gt 0 ] && [ "$ans" -lt "$counter" ]; then
            return "$ans"
        fi
    done
}

# Ask the user a question
question() {
    echo
    local ANS
    until [[ $ANS =~ ^[YyNn]$ ]]; do
        read -p "$1?  [y/N] " -n 1 -r ANS
        echo
    done
    [[ $ANS =~ ^[Yy]$ ]] && return 0 || return 1
}

setup_locale() {
    # locale-gen de_DE
    locale-gen de_DE.UTF-8
    update-locale
}

setup_smtp() {
    if question "Install msmtp"; then
        apt_update
        apt install msmtp msmtp-mta gpg ca-certificates
    fi

    local localuser="$(logname)"
    local localhome="/home/$localuser"

    while question "Add new profile"; do
        if [ "$localuser" == "root" ]; then
            question "You are logged in as root, are you sure, you want to create a msmtp profile for root" || return
        fi

        local MSMTP_CONFIG="$localhome/.msmtprc"

        if ! [ -f "$MSMTP_CONFIG" ]; then
            echo "# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log
" > "$MSMTP_CONFIG"
            chmod 600 "$MSMTP_CONFIG"
            chown "$localuser:$localuser" "$MSMTP_CONFIG"
        fi

        # NOTE: msmtp has a --configure option for auto configuration, however it seems to set not the best defaults, e.g. use starttls.
        # if ! config="$(msmtp --configure="$email" | sed '/^#/d')"; then
        local email="$(prompt "Email Address")"
        # local profilename="$(prompt "Profile Name (without spaces!)")"
        local profilename="$email"
        local host="$(prompt "Host (e.g. smtp.gmail.com)")"
        local starttls="off"
        local port=465

        if question "Use STARTTLS (if unsure, don't use)"; then
            starttls="on"
            port=587
        fi

        local port="$(prompt "Port" "$port")"
        local user="$(prompt "Login User")"

        echo "
# $profilename
account        $profilename
host           $host
tls_starttls   $starttls
port           $port
from           $email
user           $user" >> "$MSMTP_CONFIG"

        choice "Select a password storage method" \
            "Prompt (Useful for manually started scripts)" \
            "Plain text (Stores the password in plain text in $MSMTP_CONFIG)" \
            "GPG encrypted (Security through obscurity, since the corresponding private key lies right next to the config file)"
        local ans=$?

        if [ "$ans" -eq 2 ]; then
            echo "password   $(prompt "Login Password" "" -s)" >> "$MSMTP_CONFIG"
        elif [ "$ans" -eq 3 ]; then
            PW_GPG="$localhome/.msmtp-$profilename.gpg"
            echo "passwordeval   \"gpg --quiet --for-your-eyes-only --no-tty --decrypt $PW_GPG\"" >> "$MSMTP_CONFIG"
            sudo -u "$localuser" gpg --batch --passphrase "" --quick-gen-key "msmtp-$profilename" default default
            prompt "Login Password" "" -s | \
                sudo -u "$localuser" gpg --encrypt -o "$PW_GPG" -r "msmtp-$profilename" -
        fi

        echo  >> "$MSMTP_CONFIG"

        if question "Use this profile as default"; then
            echo "
# Set default account
account default : $profilename" >> "$MSMTP_CONFIG"
        fi

        if question "Edit config"; then
            # shellcheck disable=SC2086
            sudo -u "$localuser" $EDITOR "$MSMTP_CONFIG"
        fi

        if question "Send test mail"; then
            echo test | sendmail "$(prompt "Target email address")"
        fi
    done
}

setup_ssh() {
    if question "Change SSH port"; then
        local port="$(prompt Port 22)"
        [ -z "$port" ] && return 1
        SSH_PORT="$port"
        uncomment_and_edit_line "$SSH_CONFIG" 'Port [0-9]+' "Port $port" '#'
    fi

    if question "Disable root login"; then
        uncomment_and_edit_line "$SSH_CONFIG" 'PermitRootLogin.*' "PermitRootLogin no" '#'
    fi

    if question "Disable password authentication"; then
        uncomment_and_edit_line "$SSH_CONFIG" 'PasswordAuthentication.*' "PasswordAuthentication no" '#'
    fi

    if question "Enable keep alives (prevents SSH disconnecting on idle)"; then
        uncomment_and_edit_line "$SSH_CONFIG" 'ClientAliveInterval [0-9]+' "ClientAliveInterval 60" '#'
        uncomment_and_edit_line "$SSH_CONFIG" 'ClientAliveCountMax [0-9]+' "ClientAliveCountMax 10" '#'
    fi

    question "Edit ssh config" && \
        $EDITOR "$SSH_CONFIG"
}

setup_users() {
    local name="$(prompt Username)"
    [ -z "$name" ] && return 1

    if id -u "$name" > /dev/null 2>&1; then
        echo "User already exists"
    else
        if question "Disable login"; then
            adduser --disabled-login "$name" || return
        else
            adduser "$name" || return
        fi
    fi

    if question "Add to sudo group"; then
        gpasswd -a "$name" sudo
    fi

    if question "Add SSH public key for login"; then
        local key="$(prompt "Public Key")"
        mkdir -p "/home/$name/.ssh"
        chmod 700 "/home/$name/.ssh"
        echo "$key" >> "/home/$name/.ssh/authorized_keys"
        chmod 600 "/home/$name/.ssh/authorized_keys"
        chown -R "$name:$name" "/home/$name/.ssh"
    fi

    if question "Enable SSH password login for this user"; then
        echo "
Match User $name
PasswordAuthentication yes
Match all" >> "$SSH_CONFIG"
    fi

    if question "Configure as SFTP user (disable SSH, allow SFTP, restrict to /var/www/<userdir>/htdocs)"; then
        local userdir="$(prompt "User directory in /var/www/ (typically the domain or user name, e.g. my.domain.com)")"
        echo "
Match User $name
ChrootDirectory /var/www/$userdir
ForceCommand internal-sftp -d /htdocs
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match all" >> "$SSH_CONFIG"
    fi

    if question "Change user shell to /bin/false"; then
        usermod --shell /bin/false "$name"
    fi

    while question "Add autostart script (cron)"; do
        local script_path="$(prompt "Script path")"
        script_path="$(realpath "$script_path")"
        sudo -u "$name" crontab -l 2>/dev/null | { cat; echo "@reboot $script_path"; } | sudo -u "$name" crontab -
        sudo -u "$name" crontab -l
        echo
    done
}

setup_groups() {
    while question "Create group"; do
        addgroup "$(prompt name)"
    done
}

setup_steam() {
    apt_update
    apt install lib32gcc1 lib32ncurses5 libtinfo5:i386 libncurses5:i386 libcurl3-gnutls:i386

    adduser --disabled-login steam
    mkdir /home/steam/steam
    chown -R steam:steam /home/steam/steam

    local dir="$PWD"
    cd /home/steam/steam || return 1
    curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf -

    question "Download TF2" && \
        steam_download 232250 tf2

    question "Download Gmod" && \
        steam_download 4020 gmod

    question "Download Sven Coop" && \
        steam_download 276060 sven
    cd "$dir" || return 1
}

# arg1: app id
# arg2: install dir (optional)
steam_download() {
    if [ -z "$2" ]; then
        local DIR="$(prompt "Install directory (leave empty for default)")"
    else
        local DIR="$2"
    fi

    if [ -n "$DIR" ]; then
        su - steam -c "steam/steamcmd.sh +login anonymous +force_install_dir \"$DIR\" +app_update $1 validate +quit"
    else
        su - steam -c "steam/steamcmd.sh +login anonymous +app_update $1 validate +quit"
    fi
}

setup_software() {
    dpkg --add-architecture i386
    apt_update
    apt install sudo vim ranger tmux screen atool python3-pip
}

setup_firewall() {
    question "Install UFW" && apt install ufw

    ufw default deny incoming
    ufw default allow outgoing

    question "Allow SSH (Port $SSH_PORT)" && \
        ufw allow "$SSH_PORT" comment SSH

    question "Open warsow port" && ufw allow 44400
    question "Open minecraft port" && ufw allow 25565
    if question "Open srcds ports"; then
        ufw allow 27000:27030/tcp
        ufw allow 27000:27030/udp
    fi

    while question "Open custom port"; do
        local port=$(prompt "Port")
        local comment=$(prompt "Comment")
        [ -n "$port" ] && ufw allow "$port" comment "${comment:- }"
    done

    question "Enable firewall now" && ufw enable
}

# arg1: size in GB, e.g. "1" for 1GB
create_swapfile() {
    fallocate -l "${1:-1}G" /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab
}

setup_apache() {
    if question "Setup Apache"; then
        apt_update
        apt install apache2
    fi

    if question "Setup PHP"; then
        apt_update
        apt install php libapache2-mod-php php-mysql composer
    fi

    if question "Setup MySQL"; then
        apt install mysql-server
        sudo mysql_secure_installation

        echo "Testing connection..."
        echo "exit" | mysql && echo "Connection successful"
    fi

    while question "Add Virtual Host"; do
        local domain="$(prompt "Domain, e.g. example.test.com")"
        [ -z "$domain" ] && continue

        local hostpath="$WWW_DIR/$domain"
        local htdocspath="$hostpath/htdocs"
        mkdir -p "$htdocspath"
        [ -e "$htdocspath/index.html" ] || echo "Index" > "$htdocspath/index.html"

        local owner="$(prompt "Owner user")"
        [ -n "$owner" ] && id -u "$owner" && chown -R "$owner:$owner" "$htdocspath"

        local conf="/etc/apache2/sites-available/$domain.conf"
        local aliases="$(prompt "Aliases (Separated by space) (Leave empty if unsure)")"

        echo "<VirtualHost *:80>
    StrictHostCheck ON
    ServerAdmin webmaster@localhost
    ServerName $domain" > "$conf"

    [ -n "$aliases" ] && \
        echo "    ServerAlias $aliases" >> "$conf"

        echo "    DocumentRoot $htdocspath
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> "$conf"

        question "Edit config" && $EDITOR "$conf"

        a2ensite "$domain.conf"
        apache2ctl configtest
    done

    question "Disable default virtual host" && \
        a2dissite 000-default.conf

    echo
    echo Restarting apache...
    systemctl restart apache2

    if question "Install certbot"; then
        echo Installing certbot...
        snap install core
        snap refresh core
        apt remove certbot
        snap install --classic certbot
        ln -s /snap/bin/certbot /usr/bin/certbot
    fi

    if question "Setup https"; then
        echo Running certbot
        certbot --apache

        echo Testing Auto-Renewal...
        certbot renew --dry-run
    fi

    if question "Add firewall rule for Apache"; then
        ufw allow "Apache Full"
    fi

    echo "Server directory is located at $WWW_DIR"
}

# Based on https://about.gitlab.com/install/?test=capabilities#ubuntu
setup_gitlab() {
    apt_update
    apt install curl openssh-server ca-certificates tzdata perl postfix

    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

    echo
    local url="$(prompt "URL at which you want to access your GitLab instance, e.g. https://gitlab.example.com")"
    EXTERNAL_URL="$url" apt install gitlab-ee

    echo "Installation finished."
    echo "You can now visit $url and log in for the first time using the default user 'root'."
    echo "Consider the recommended next steps, including authentication options and sign-up restrictions."
    echo "See here: https://docs.gitlab.com/ee/install/#next-steps"
}

# https://help.ubuntu.com/community/AutomaticSecurityUpdates
setup_auto_updates() {
    apt_update
    apt install unattended-upgrades update-notifier-common
    dpkg-reconfigure --priority=low unattended-upgrades

    local cfgfile="/etc/apt/apt.conf.d/50unattended-upgrades"

    if question "Setup email notifications (requires an email setup)"; then
        local email="$(prompt "Email Address")"
        uncomment_and_edit_line "$cfgfile" 'Unattended-Upgrade::Mail .*' "Unattended-Upgrade::Mail \"$email\";" '\/\/'
    fi

    if question "Setup auto-reboot"; then
        uncomment_and_edit_line "$cfgfile" 'Unattended-Upgrade::Automatic-Reboot .*' 'Unattended-Upgrade::Automatic-Reboot "true";' '\/\/'
        echo Automatic reboots enabled.
        echo You can edit the config file for more settings related to automatic rebooting.
    fi

    local periodic_file="/etc/apt/apt.conf.d/20auto-upgrades"

    if ! [ -f "$periodic_file" ] && [ -f "/etc/apt/apt.conf.d/10periodic" ]; then
        periodic_file="/etc/apt/apt.conf.d/10periodic"
    fi

    echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' > "$periodic_file"

    if question "Open config"; then
        $EDITOR "$cfgfile"
        $EDITOR "$periodic_file"
    fi

    echo Restarting service...
    systemctl restart unattended-upgrades.service
}


# arg1: file
# arg2: search regex
# arg3: replace regex
# arg4: use sudo (true/false)
replace_in_file() {
    local sudocmd=""
    ${4:-false} && sudocmd=sudo
    $sudocmd sed -Ei "s/$2/$3/g" "$1"
}

# arg1: file
# arg2: search regex
# arg3: comment char
# arg4: use sudo (true/false)
uncomment_line() {
    replace_in_file "$1" "^\\s*$3\\s*($2)\\s*$" '\1' "$4"
}

# arg1: file
# arg2: search regex
# arg3: replace regex
# arg4: comment char
# arg5: use sudo (true/false)
uncomment_and_edit_line() {
    uncomment_line "$1" "$2" "$4" "$5"
    replace_in_file "$1" "$2" "$3" "$5"
}

main "$@"

