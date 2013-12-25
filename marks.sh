# Bash bookmarks
# https://news.ycombinator.com/item?id=6229001

export MARKPATH=$HOME/.marks

function jump {
    { cd -P "$MARKPATH/$1" 2>/dev/null && cd - >/dev/null && pushd "$OLDPWD" >/dev/null && pwd ; } || echo "No such mark: $1"
}

function mark {
    local kw
    if [ -z "$1" ] ; then
        kw="$( basename $( pwd ) )"
    else
        kw="$1"
    fi

    mkdir -p "$MARKPATH"; ln -sT "$(pwd)" "$MARKPATH/$kw"
}

function unmark {
    rm -i "$MARKPATH/$1"
}

function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/ \+/ /g' | cut -d' ' -f9- | sed 's/ -> / /g' | column -t -s ' '
}

function _jump {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local marks=$(find $MARKPATH -type l | awk -F '/' '{print $NF}')
    COMPREPLY=($(compgen -W '${marks[@]}' -- "$cur"))
    return 0
}
complete -o default -o nospace -F _jump jump
complete -o default -o nospace -F _jump unmark

alias j=jump
complete -o default -o nospace -F _jump j
