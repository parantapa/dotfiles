# Fabric completion

function __fab_completion() {
    # Return if "fab" command doesn't exists
    hash fab 2>/dev/null || return 0

    # Try generate a shortlist
    local tasks=$(fab --shortlist 2> /dev/null)
    [[ $? -eq 0 ]] || return 0

    # Generate the long options
    local opts=$(fab --help 2>&1 | egrep -o "\-\-[A-Za-z_\-]+\=?" | sort -u)

    # Set of possible completions
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "${tasks} ${opts}" -- ${cur}))
}
complete -o default -o nospace -F __fab_completion fab
