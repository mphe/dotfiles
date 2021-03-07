#!/usr/bin/env bash

sudo pacman --needed -S openssh

read -rp "Comment for key (optional): " comment
ssh-keygen -t rsa -b 4096 -C "$comment"
