#!/usr/bin/env bash

sudo pacman -S --needed python-cairosvg
pip install --user --break-system-packages -r python_packages.txt
