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
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox-developer-edition
export PDFVIEWER=evince
export MENU="rofi -show run -matching fuzzy"
export TERMINAL=alacritty

# colorize ls
alias ls="ls --color=auto -h --group-directories-first"

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
alias tmux="tmux -u"
alias diff="diff --color=auto"

# Modern unix tools
alias rg="rg --color=auto"
alias ll="exa --long --group --color=auto --group-directories-first --time-style long-iso"
alias llt="exa --long --group --color=auto --group-directories-first --time-style long-iso --tree"

# FZF
export FZF_DEFAULT_COMMAND='fd --type file --one-file-system'
export FZF_DEFAULT_OPTS="--layout=reverse --height=20 --border=none --history-size=100000"

# Shortcut for ps-ing pgrep output
psf  () { ps -O %cpu,%mem,rsz,vsz --sort -%cpu,-%mem "$@" ; }
psg  () { psf "$( pgrep -f "$@" )" ; }
psu  () { psf -u "$USER" "$@" ; }
topu () { top -u "$USER" "$@" ; }

# Colorful man
man () {
    env LESS_TERMCAP_md=$(printf "\e[01;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[01;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[01;32m") \
        \man "$@"
}

histdel () {
    for line in $(history | fzf --multi | get-first-field) ; do
        history -d "$line"
    done
}

# PDF viewer shortcut
e () {
    $PDFVIEWER "$@" >/dev/null 2>&1 &
}


# GVim alias
alias g=nvim

# Add to path if not already exists
# NOTE: don't expect path to be empty
pathadd() {
    if [[ ":$PATH:" != *":$1:"* ]] ; then
        PATH="$1:$PATH"
    fi
}
