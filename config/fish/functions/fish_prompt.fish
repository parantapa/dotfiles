set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'

function fish_prompt --description 'Write out the prompt'
    set stat $status

    # auto_switch_venv

    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if set -q VIRTUAL_ENV
        set_color green
        echo -n "(v:"(basename $VIRTUAL_ENV)") "
    end

    if set -q CONDA_PREFIX
        set_color green
        echo -n "(c:"(basename $CONDA_PREFIX)") "
    end

    set_color cyan
    echo -n "$USER@$__fish_prompt_hostname"

    set_color purple
    echo -n " : "

    set_color yellow
    echo -n (basename (pwd))

    set_color purple
    echo -n " - "

    if test $stat -eq 0
        set_color green
        echo -n ":)"
    else
        set_color red
        echo -n ":( $stat"
    end

    if git status >/dev/null 2>/dev/null
        set_color purple
        echo -n " -"

        set_color yellow
        __fish_git_prompt
    end

    set_color purple
    echo -n " - "

    set_color green
    echo -n (date '+%F %T')

    set_color purple
    echo -en "\n> "

    set_color normal
end
