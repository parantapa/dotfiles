# Set the environment variables to something I like
set -x PAGER "less -niRS"
set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER firefox-aurora
set -x PDFVIEWER evince

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

# GVim alias
if set -q DISPLAY
    switch $DISPLAY
    case ':0.0'
        alias g=gvim
    case '*'
        alias g=vim
    end
else
    alias g=vim
end
