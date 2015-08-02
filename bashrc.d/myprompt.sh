# List of colors
_mycolor_txtblk='\[\e[0;30m\]' # Black - Regular
_mycolor_txtred='\[\e[0;31m\]' # Red
_mycolor_txtgrn='\[\e[0;32m\]' # Green
_mycolor_txtylw='\[\e[0;33m\]' # Yellow
_mycolor_txtblu='\[\e[0;34m\]' # Blue
_mycolor_txtpur='\[\e[0;35m\]' # Purple
_mycolor_txtcyn='\[\e[0;36m\]' # Cyan
_mycolor_txtwht='\[\e[0;37m\]' # White
# _mycolor_bldblk='\[\e[1;30m\]' # Black - Bold
# _mycolor_bldred='\[\e[1;31m\]' # Red
# _mycolor_bldgrn='\[\e[1;32m\]' # Green
# _mycolor_bldylw='\[\e[1;33m\]' # Yellow
# _mycolor_bldblu='\[\e[1;34m\]' # Blue
# _mycolor_bldpur='\[\e[1;35m\]' # Purple
# _mycolor_bldcyn='\[\e[1;36m\]' # Cyan
# _mycolor_bldwht='\[\e[1;37m\]' # White
# _mycolor_unkblk='\[\e[4;30m\]' # Black - Underline
# _mycolor_undred='\[\e[4;31m\]' # Red
# _mycolor_undgrn='\[\e[4;32m\]' # Green
# _mycolor_undylw='\[\e[4;33m\]' # Yellow
# _mycolor_undblu='\[\e[4;34m\]' # Blue
# _mycolor_undpur='\[\e[4;35m\]' # Purple
# _mycolor_undcyn='\[\e[4;36m\]' # Cyan
# _mycolor_undwht='\[\e[4;37m\]' # White
# _mycolor_bakblk='\[\e[40m\]'   # Black - Background
# _mycolor_bakred='\[\e[41m\]'   # Red
# _mycolor_badgrn='\[\e[42m\]'   # Green
# _mycolor_bakylw='\[\e[43m\]'   # Yellow
# _mycolor_bakblu='\[\e[44m\]'   # Blue
# _mycolor_bakpur='\[\e[45m\]'   # Purple
# _mycolor_bakcyn='\[\e[46m\]'   # Cyan
# _mycolor_bakwht='\[\e[47m\]'   # White
_mycolor_txtrst='\[\e[0m\]'    # Text Reset

# Import __git_ps1
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto
source "$HOME_DOTFILES/bashrc.d/git-prompt.sh"

my_ps1 () {
    local ret="$1"

    hash deactivate 2>/dev/null
    if [[ "$?" -eq 0 ]] && [[ -n "$VIRTUAL_ENV" ]] ; then
        printf '%s(%s)%s ' "${_mycolor_txtgrn}" "$(basename $VIRTUAL_ENV)" "${_mycolor_txtpur}"
    fi

    printf '%s\\u@\\h%s: ' "${_mycolor_txtcyn}" "${_mycolor_txtpur}"
    printf '%s\\W %s- '   "${_mycolor_txtylw}" "${_mycolor_txtpur}"
    if [[ "$ret" -eq 0 ]] ; then
        printf '%s:) %s- ' "${_mycolor_txtgrn}" "${_mycolor_txtpur}"
    else
        printf '%s:( %s %s- ' "${_mycolor_txtred}" "${ret}" "${_mycolor_txtpur}"
    fi
    printf '%s%s%s ' "${_mycolor_txtcyn}" "$(date '+%F %T')" "${_mycolor_txtpur}"

    type __git_ps1 >/dev/null 2>&1
    if [[ "$?" -eq 0 ]] ; then
        printf '%s%s%s ' "${_mycolor_txtylw}" "$(__git_ps1 '(%s)')" "${_mycolor_txtpur}"
    fi

    printf '\\n%s\\$ %s' "${_mycolor_txtpur}" "${_mycolor_txtrst}"
}

my_titlebar () {
    case "$TERM" in
        xterm*|rxvt*)
            echo -ne "\033]0;${USER}@${HOSTNAME}: $(basename ${PWD})\007"
            ;;
        *)
            ;;
    esac
}

prompt_fn () {
    local ret="$1"

    PS1="$(my_ps1 $ret)"
    my_titlebar
    history -a
}

PROMPT_COMMAND='prompt_fn $?'
