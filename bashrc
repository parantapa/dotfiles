# ~/.bashrc: executed by bash(1) for non-login shells.

# append to the history file, don't overwrite it
shopt -s histappend

# set hist size 500 is too small
HISTSIZE=5000

# Ignore duplicates and some stupid commands in history
HISTIGNORE="&:ls:ll:fg:bg:exit"

# Save time along with command in history
HISTTIMEFORMAT="%F %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# colorize ls
LS_OPTIONS='--color=auto -h --group-directories-first'

alias ls="ls $LS_OPTIONS"
alias ll="ls $LS_OPTIONS -l -v"
alias l.="ls $LS_OPTIONS -A --ignore='[^.]*'"

# Some more alias to avoid making mistakes:
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Known places
alias cd.="cd $HOME/.dotfiles"
alias cdw="cd $HOME/workspace"

# Set the environmetal veriables to something I like
export GREP_OPTIONS="--color=auto"
export LESS=-niRS
export PAGER=less
export EDITOR=vim
export VISUAL=vim

# Make tmux always use unicode
alias tmux="tmux -u"
alias diff=colordiff

# Fabric completion
function __fab_completion() {
    # Return if "fab" command doesn't exists
    [[ -e `which fab 2> /dev/null` ]] || return 0

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

# List of colors
txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
badgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

# Time to set a fancy prompt
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto

. "$HOME/.dotfiles/git-prompt.sh"

function __my_ps1() {
    ret="$?"

    type deactivate >/dev/null 2>&1
    if [ "$?" -eq 0 -a -n "$VIRTUAL_ENV" ] ; then
        printf '%s(%s)%s ' "${txtgrn}" "$(basename $VIRTUAL_ENV)" "${txtpur}"
    fi
    printf '%s\\u@\\h%s: ' "${txtcyn}" "${txtpur}"
    printf '%s\\W %s- '   "${txtylw}" "${txtpur}"
    if [ "$ret" -eq 0 ] ; then
        printf '%s:) %s- ' "${txtgrn}" "${txtpur}"
    else
        printf '%s:( %s %s- ' "${txtred}" "${ret}" "${txtpur}"
    fi
    printf '%s%s%s ' "${txtcyn}" "$(date '+%F %T')" "${txtpur}"
    printf '%s%s%s ' "${txtylw}" "$(__git_ps1 '(%s)')" "${txtpur}"
    printf '\\n%s\\$ %s' "${txtpur}" "${txtrst}"
}

# Hack to consistantly update history when using multiple sessions
PROMPT_COMMAND='history -a; PS1="$(__my_ps1)"'

# Shortcut for ps-ing pgrep output
psf  () { ps -O %cpu,%mem,rsz,vsz --sort -%cpu,-%mem "$@" ; }
psg  () { psf $( pgrep "$@" ) ; }
psu  () { psf -u $USER "$@" ; }
topu () { top -u $USER "$@" ; }

# Git shortcuts
alias gc="git commit"
alias gd="git diff"
alias gdt="git difftool"
alias gca="git commit -a"
alias gs="tig status"
alias gl="tig"

# GVim alias
g () {
    if [ -n "$DISPLAY" ] ; then
        if [ "$#" -eq 0 ] ; then
            gvim --servername G
        else
            gvim --servername G --remote-silent "$@"
        fi
    else
        vim "$@"
    fi
}

# Setup the rubygem locations
export GEM_HOME=~/.gem
export GEM_PATH=~/.gem

# User Distribute instead of Setuptools
export VIRTUALENV_DISTRIBUTE=1

# Use a separate file for system specific bashrc
if [ -r ~/.bashrc_local ] ; then
    . ~/.bashrc_local
fi

