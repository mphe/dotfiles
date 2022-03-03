#!/usr/bin/env bash
mv ~/.vim/autoload/plug.vim ~/.vim/autoload/plug.vim.bak
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
