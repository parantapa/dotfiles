# Set the environment variables to something I like
set -x PAGER "less -niRS"
set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER google-chrome-stable
set -x PDFVIEWER zathura

# colorize ls
set LS_OPTIONS "--color=always -h --group-directories-first"

alias ls "ls $LS_OPTIONS"
alias ll "ls $LS_OPTIONS -l -v"
alias l. "ls $LS_OPTIONS -A --ignore='[^.]*'"

# Some more aliases to avoid stupid mistakes
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"

# More alias for convenience
alias cpv "rsync --human-readable --progress"
alias dirs "dirs -v"
alias grep "grep --color=always"
alias less "less -niRS"
alias jq "jq -C"
alias ack "ack --color"
alias tmux "tmux -u"
if command -s colordiff >/dev/null
    alias diff colordiff
end

# Shortcut for ps-ing pgrep output
function psf
    ps -O "%cpu,%mem,rsz,vsz" --sort "-%cpu,-%mem" $argv
end
function psg
    psf (pgrep -f $argv)
end
function psu
    psf -u $USER $argv
end
function topu
    top -u $USER $argv
end

function man
    command env LESS_TERMCAP_md=(printf "\e[01;31m") \
                LESS_TERMCAP_me=(printf "\e[0m") \
                LESS_TERMCAP_se=(printf "\e[0m") \
                LESS_TERMCAP_so=(printf "\e[01;44;33m") \
                LESS_TERMCAP_ue=(printf "\e[0m") \
                LESS_TERMCAP_us=(printf "\e[01;32m") \
                man $argv
end

# GVim alias
if set -q DISPLAY
    switch $DISPLAY
    case 'localhost:*'
        alias g=vim
    case '*'
        alias g=vimer
    end
else
    alias g=vim
end
