# Automatically switch virtualenv
auto_switch_venv () {
    # Get the current directory's venv
    if [[ ! -r ".venv" ]] ; then
        return
    fi
    local dvenv="$(< .venv)"
    if [[ -z "$dvenv" ]] ; then
        return
    fi

    # Check if a venv is currently active
    local avenv="$( basename "$VIRTUAL_ENV" )"
    hash deactivate 2>/dev/null
    if [[ "$?" -eq 1 ]] ; then
        avenv=""
    fi

    # If the currently active venv and it is not an auto switched venv: return
    if [[ -n "$avenv" ]] && [[ "$SWITCH_VENV_AUTO" != "$avenv" ]] ; then
        return
    fi

    # If the directory's venv is same as active venv: return
    if [[ -n "$avenv" ]] && [[ "$dvenv" == "$avenv" ]] ; then
        return
    fi

    workon "$dvenv" 2>/dev/null
    # Check if the correct venv was activted
    local tmp="$( basename "$VIRTUAL_ENV" )"
    if [[ "$tmp" == "$dvenv" ]] ; then
        SWITCH_VENV_AUTO="$dvenv"
    fi
}

prompt_fn2 () {
    local ret="$1"

    auto_switch_venv
    PS1="$(my_ps1 $ret)"
    history -a
}

PROMPT_COMMAND='prompt_fn2 $?'
