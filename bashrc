# ~/.bashrc: executed by bash(1) for non-login shells.

export HOME_DOTFILES="$HOME/.dotfiles"
export HOME_QUICKREFS="$HOME/quickrefs"
export HOME_SDOCS="$HOME/sdocs"

# Add to path if not already exists
# NOTE: don't expect path to be empty
pathadd() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Add dotfiles/bin to path
pathadd "$HOME_DOTFILES/bin"

# set hist size; default is too small
HISTSIZE=100000
HISTFILESIZE=1000000

# Ignore duplicates and some stupid commands in history
HISTIGNORE="&:ls:ll:fg:bg:exit"

# Save time along with command in history
HISTTIMEFORMAT="%F %T "

# Set the list of updated bash options
shopt -s extglob
shopt -s autocd
shopt -s checkwinsize
shopt -s cmdhist
shopt -s globstar
shopt -s histappend
shopt -s histverify
shopt -s no_empty_cmd_completion

# colorize ls
LS_OPTIONS='--color=always -h --group-directories-first'

alias ls="ls $LS_OPTIONS"
alias ll="ls $LS_OPTIONS -l -v"
alias l.="ls $LS_OPTIONS -A --ignore='[^.]*'"

# Some more aliases to avoid stupid mistakes
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Alias sudo to work with other aliases
alias sudo="sudo "

# Alias cd to resolve symlinks
alias cd="cd -P"

# More alias for convenience
alias cpv="rsync --human-readable --progress"
alias dirs="dirs -v"
alias grep="grep --color=always"
alias less="less -niRS"
alias jq="jq -C"
alias ack="ack --color"
alias tmux="tmux -u"
if hash colordiff 2>/dev/null ; then
    alias diff=colordiff
fi

alias pq="pprint-data pickle"
alias yq="pprint-data yaml"
alias jqx="pprint-data json"
alias mq="pprint-data msgpack"

alias pqi="prepl-data pickle"
alias yqi="prepl-data yaml"
alias jqi="prepl-data json"
alias mqi="prepl-data msgpack"

# Set the environment variables to something I like
export PAGER="less -niRS"
export EDITOR=vim
export VISUAL=vim

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
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto

. "$HOME_DOTFILES/git-prompt.sh"

__my_ps1 () {
    local ret="$1"

    hash deactivate 2>/dev/null
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

prompt_fn () {
    local ret="$1"

    PS1="$(__my_ps1 $ret)"
    history -a
}

# Hack to consistently update history when using multiple sessions
# NOTE: May be reset in .bashrc_local
PROMPT_COMMAND='prompt_fn $?'

# Known places
. "$HOME_DOTFILES/marks.sh"
try_mark () {
    if ! [[ -h "$MARKPATH/$1" ]] && [[ -d "$2" ]] ; then
        mark "$1" "$2"
    fi
}
try_mark dotfiles "$HOME_DOTFILES"
try_mark quickrefs "$HOME_QUICKREFS"
try_mark sdocs "$HOME_SDOCS"
unset -f try_mark

# Shortcut for ps-ing pgrep output
psf  () { ps -O %cpu,%mem,rsz,vsz --sort -%cpu,-%mem "$@" ; }
psg  () { psf $( pgrep -f "$@" ) ; }
psu  () { psf -u $USER "$@" ; }
topu () { top -u $USER "$@" ; }

# Git shortcuts
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gdt="git difftool"
alias gca="git commit -a"
alias gs="git status"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gclone="git clone"
alias gpull="git pull"
alias gpush="git push"

# Git SVN shortcuts
gsclone () {
    if [[ -z "$1" ]] ; then
        echo "Must provide url to clone from"
        return 1
    fi

    local logfile="$(mktemp -t gsclone.XXXXXX)"
    echo "$logfile"
    svn log "$1" > "$logfile"
    if [[ $? -ne 0 ]] ; then
        echo "Failed to get repo log"
        return 1
        rm -f "$logfile"
    fi

    local frev=$(\grep -P '^r\d+' "$logfile" | tail -n 1 | cut -d \| -f 1)
    rm -f "$logfile"
    if [[ -z "$frev" ]] ; then
        echo "Failed to get first revision"
        return 1
    fi

    # Git clone
    git svn clone -$frev "$1"
    if [[ $? -ne 0 ]] ; then
        echo "Falied to clone repo"
        return 1
    fi

    # Get into the directory and download the stuff
    pushd "$(basename "$1")"
    git svn rebase
    popd
}
alias gspull="git svn rebase"
alias gspush="git svn dcommit"

# GVim alias
if [[ -n "$DISPLAY" ]] ; then
    alias g=gvim
else
    alias g=vim
fi

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
    evince $@ 2>/dev/null &
}

# Execute git svn pull in all the folders
pb-git-svn-rebase-all () {
    set -x
    for i in "$@" ; do
        if [[ -d "$i/.git" ]] ; then
            cd "$i"
            git svn rebase
            cd -
        fi
    done
    set +x
}

# Execute git pull in master branch in all the folders
pb-git-pull-in-master-all () {
    set -x
    for i in "$@" ; do
        if [[ -d "$i/.git" ]] || [[ -f "$i/.git" ]] ; then
            cd "$i"
            git checkout master
            git pull
            cd -
        fi
    done
    set +x
}

# Setup PyGTK in the current virtualenv
# Assume pygkt is installed in system at /usr/lib/python2.7
pb-pygtk-setup-virtualenv () {
    local fromdir="${1-/usr/lib/python2.7/site-packages}"
    local files=(glib gobject cairo gtk-2.0 pygtk.pth pygtk.py)
    local f

    cdsitepackages
    echo "cdsitepackages"

    set -x
    pwd

    for f in "${files[@]}" ; do
        ln -s "${fromdir}/${f}"
    done
    set +x

    cd -
}

# Use a separate file for system specific bashrc
if [ -r ~/.bashrc_local ] ; then
    myrc_d="$HOME_DOTFILES/system-specific/common"
    . ~/.bashrc_local
    unset -v myrc_d
fi

