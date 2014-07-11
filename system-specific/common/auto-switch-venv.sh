# Automatically switch virtualenv
auto_switch_venv () {
    if [[ ! -r ".venv" ]] ; then
        return
    fi
    local venv="$(< .venv)"
    if [[ -z "$venv" ]] ; then
        return
    fi
    local xvenv="$( basename "$VIRTUAL_ENV" )"
    hash deactivate 2>/dev/null
    if [[ "$?" -eq 0 ]] && [[ -n "$xvenv" ]] ; then
        if [[ "$SWITCH_VENV_AUTO" == "$xvenv" ]] && [[ "$venv" != "$xvenv" ]]; then
            workon "$venv"
            local yvenv="$( basename "$VIRTUAL_ENV" )"
            if [[ "$yvenv" == "$venv" ]] ; then
                SWITCH_VENV_AUTO="$venv"
            fi
        fi
    else
        workon "$venv"
        local yvenv="$( basename "$VIRTUAL_ENV" )"
        if [[ "$yvenv" == "$venv" ]] ; then
            SWITCH_VENV_AUTO="$venv"
        fi
    fi
}

PROMPT_COMMAND='LAST_RET=$? ; auto_switch_venv ; PS1="$(__my_ps1)" ; unset LAST_RET ; history -a'

