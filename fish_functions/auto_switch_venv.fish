function auto_switch_venv
    # Get the current directory's venv
    if test ! -r .venv
        return
    end

    set dvenv (cat .venv)
    if test -z "$dvenv"
        return
    end

    # Check if a venv is currently active
    set avenv (basename "$VIRTUAL_ENV")
    type deactivate >/dev/null ^/dev/null
    if test $status -eq 1
        set avenv ""
    end

    # If the currently active venv and it is not an auto switched venv: return
    if test -n "$avenv" -a "$SWITCH_VENV_AUTO" != "$avenv"
        return
    end

    # If the directory's venv is same as active venv: return
    if test -n "$avenv" -a "$dvenv" = "$avenv"
        return
    end

    workon "$dvenv" >/dev/null ^/dev/null

    # Check if the correct venv was activted
    set tmp (basename "$VIRTUAL_ENV")
    if test "$tmp" = "$dvenv"
        set -g SWITCH_VENV_AUTO "$dvenv"
    end
end
