#!/bin/bash
# Default bash script

# Standard list of shell colors
###############################################################################

# color_txtblk='\e[0;30m' # Black - Regular
color_txtred='\e[0;31m' # Red
color_txtgrn='\e[0;32m' # Green
color_txtylw='\e[0;33m' # Yellow
# color_txtblu='\e[0;34m' # Blue
# color_txtpur='\e[0;35m' # Purple
# color_txtcyn='\e[0;36m' # Cyan
# color_txtwht='\e[0;37m' # White
# color_bldblk='\e[1;30m' # Black - Bold
# color_bldred='\e[1;31m' # Red
# color_bldgrn='\e[1;32m' # Green
# color_bldylw='\e[1;33m' # Yellow
# color_bldblu='\e[1;34m' # Blue
# color_bldpur='\e[1;35m' # Purple
# color_bldcyn='\e[1;36m' # Cyan
# color_bldwht='\e[1;37m' # White
# color_unkblk='\e[4;30m' # Black - Underline
# color_undred='\e[4;31m' # Red
# color_undgrn='\e[4;32m' # Green
# color_undylw='\e[4;33m' # Yellow
# color_undblu='\e[4;34m' # Blue
# color_undpur='\e[4;35m' # Purple
# color_undcyn='\e[4;36m' # Cyan
# color_undwht='\e[4;37m' # White
# color_bakblk='\e[40m'   # Black - Background
# color_bakred='\e[41m'   # Red
# color_badgrn='\e[42m'   # Green
# color_bakylw='\e[43m'   # Yellow
# color_bakblu='\e[44m'   # Blue
# color_bakpur='\e[45m'   # Purple
# color_bakcyn='\e[46m'   # Cyan
# color_bakwht='\e[47m'   # White
color_txtrst='\e[0m'    # Text Reset

# Standard output functions
###############################################################################

notice () {
    echo -en "$color_txtgrn"
    echo "$@"
    echo -en "$color_txtrst"
}

warn () {
    echo -en "$color_txtylw"
    echo "$@"
    echo -en "$color_txtrst"
}

err () {
    echo -en "$color_txtred"
    echo "$@"
    echo -en "$color_txtrst"
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

if [[ "$(type -t "main_${SUBCOMMAND}")" != "function" ]] ; then
    err "Invalid command: $SUBCOMMAND"
    usage
    exit 1
fi

main_${SUBCOMMAND} "$@"
exit 0
