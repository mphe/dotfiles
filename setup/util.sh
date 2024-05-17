#!/usr/bin/env bash

question() {
    local ANS
    until [[ $ANS =~ ^[YyNn]$ ]]; do
        read -p "$1?  [y/N] " -n 1 -r ANS
        echo
    done
    [[ $ANS =~ ^[Yy]$ ]] && return 0 || return 1
}
