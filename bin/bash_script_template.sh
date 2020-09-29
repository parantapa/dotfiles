#!/bin/bash
# Default bash script

# Standard list of shell colors
###############################################################################

# color_bold=""
# color_underline=""
# color_standout=""
color_normal=""
# color_black=""
color_red=""
color_green=""
color_yellow=""
# color_blue=""
# color_magenta=""
# color_cyan=""
# color_white=""

# Check if stdout is a terminal
if [[ -t 1 ]] ; then
    # see if it supports colors...
    ncolors="$(tput colors)"

    if [[ -n "$ncolors" ]] && [[ "$ncolors" -ge 8 ]] ; then
        # color_bold="$(tput bold)"
        # color_underline="$(tput smul)"
        # color_standout="$(tput smso)"
        color_normal="$(tput sgr0)"
        # color_black="$(tput setaf 0)"
        color_red="$(tput setaf 1)"
        color_green="$(tput setaf 2)"
        color_yellow="$(tput setaf 3)"
        # color_blue="$(tput setaf 4)"
        # color_magenta="$(tput setaf 5)"
        # color_cyan="$(tput setaf 6)"
        # color_white="$(tput setaf 7)"
    fi
fi

# Standard output functions
###############################################################################

notice () {
    echo -en "$color_green"
    echo "$@"
    echo -en "$color_normal"
}

warn () {
    echo -en "$color_yellow"
    echo "$@"
    echo -en "$color_normal"
}

err () {
    echo -en "$color_red"
    echo "$@"
    echo -en "$color_normal"
}

# Option variables
###############################################################################

nval=0

# Usage message
###############################################################################

usage () {
    echo "Usage: $0 [-n 10..20] [hello|world]"
}

# Script main(s)
###############################################################################

main_default() {
    echo "\$NVAL=$nval"
    notice "Default"
}

main_hello () {
    echo "\$NVAL=$nval"
    warn "Hello"
}

main_world () {
    echo "\$NVAL=$nval"
    err "World"
}

# Option and argument handling
###############################################################################

while getopts ":hn:" opt; do
    case ${opt} in
        h )
            usage
            exit 0
        ;;
        n )
            nval="$OPTARG"
        ;;
        \? )
            err "Invalid Option: -$OPTARG"
            usage
            exit 1
        ;;
        : )
            err "Invalid Option: $OPTARG requires an argument"
            usage
            exit 1
        ;;
    esac
done
shift $((OPTIND -1))

if [[ -z "$1" ]] ; then
    SUBCOMMAND="default"
else
    SUBCOMMAND="$1"
    shift 1
fi

if [[ "$( type -t "main_${SUBCOMMAND}" )" != "function" ]] ; then
    err "Invalid command: $SUBCOMMAND"
    usage
    exit 1
fi

"main_${SUBCOMMAND}" "$@"
exit 0
