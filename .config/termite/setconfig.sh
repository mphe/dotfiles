#!/bin/bash

cd $(dirname $(readlink -f "$0"))
[ -L config ] && rm config && ln -s "$1" config
