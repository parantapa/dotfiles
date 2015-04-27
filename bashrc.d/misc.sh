# Find alias
f () {
    local n fname

    if [[ $# -eq 1 ]] ; then
        find . -iname "*$1*" | nl
    elif [[ $# -eq 2 ]] ; then
        n="$2"
        fname="$( find . -iname "*$1*" | sed "${n}q;d" )"
        if [[ -f "${fname}" ]] ; then
            xdg-open "${fname}" 2>/dev/null &
        else
            printf "No files found: PATTERN='%s' N='%s'\n" "$1" "$2"
        fi
    else
        echo "Usage: f PATTERN [N]"
    fi
}

# Evince alias
e () {
    evince "$@" 2>/dev/null &
}
