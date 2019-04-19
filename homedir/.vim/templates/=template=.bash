#!/bin/bash

printhelp() {
    echo "docstring"
    echo -e "Usage:\n\t${0##*/} [options] arguments"
    echo -e "\nOptions:"
    echo -e "\t-h, --help\tShow help"
}

main() {
    if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        printhelp
        exit
    fi
}

main "$@"
