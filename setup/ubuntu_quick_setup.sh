#!/usr/bin/env bash

sudo apt install -y git

mkdir git &&
cd git/ || exit 1
git clone https://github.com/mphe/dotfiles.git
cd dotfiles
git submodule update --init --recursive
cd
ln -s git/dotfiles/homedir/.inputrc .
ln -s git/dotfiles/homedir/.vimrc .
ln -s git/dotfiles/homedir/.vim .
ln -s git/dotfiles/configdir/nvim/ .config/

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install -y neovim python3-pynvim \
    yarn nodejs python3-pip \
    ranger fonts-hack fonts-font-awesome exuberant-ctags cpupower-gui curl

pip3 install --user pylint mypy jedi-language-server

echo 'export EDITOR=nvim' >> .bashrc
echo 'alias vim=nvim' >> .bashrc
echo "export PATH=\"\$PATH:home/$USER/.local/bin\"" >> .bashrc

# curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
# sudo apt install nodejs

sudo apt install cinnamon-desktop-environment arc-theme

ssh-keygen -t rsa -b 2048
