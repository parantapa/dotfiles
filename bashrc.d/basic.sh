# Basic bash configs

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

# Set the environment variables to something I like
export PAGER="less -niRS"
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox-developer-edition
export PDFVIEWER=zathura
export MENU="rofi -show run -matching fuzzy"
export TERMINAL=alacritty

# colorize ls
LS_OPTIONS='--color=auto -h --group-directories-first'

alias ls="ls $LS_OPTIONS"
alias ll="ls $LS_OPTIONS -l -v"
alias l.="ls $LS_OPTIONS -A --ignore='[^.]*'"
alias lst='\ls -R | \grep ":\$" | sed -e "s/:\$//" -e "s/[^-][^\\/]*\\//--/g" -e "s/^/   /" -e "s/-/|/"'

# Some more aliases to avoid stupid mistakes
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Alias sudo and watch to work with other aliases
alias sudo="sudo "
alias watch="watch --color "

# Alias cd to resolve symlinks
alias cd="cd -P"

# More alias for convenience
alias cpv="rsync --human-readable --progress"
alias grep="grep --color=auto"
alias less="less -niRS"
alias rg="rg --color=auto"
alias tmux="tmux -u"
alias diff="diff --color=auto"

# Shortcut for ps-ing pgrep output
psf  () { ps -O %cpu,%mem,rsz,vsz --sort -%cpu,-%mem "$@" ; }
psg  () { psf "$( pgrep -f "$@" )" ; }
psu  () { psf -u "$USER" "$@" ; }
topu () { top -u "$USER" "$@" ; }

# GVim alias
if [[ -n "$DISPLAY" ]] && [[ "$DISPLAY" != "localhost:"* ]] ; then
    alias g=gvim
else
    alias g=vim
fi

# Add to path if not already exists
# NOTE: don't expect path to be empty
pathadd() {
    if [[ ":$PATH:" != *":$1:"* ]] ; then
        PATH="$1:$PATH"
    fi
}
