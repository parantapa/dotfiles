# Set the environment variables to something I like
set -x PAGER "less -niRS"
set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER firefox-developer-edition
set -x PDFVIEWER evince
set -x MENU "rofi -matching fuzzy -dmenu"
set -x TERMINAL alacritty

# colorize ls
alias ls "ls --color=auto -h --group-directories-first"

# Add color support to watch
alias watch="watch --color"

# Some more aliases to avoid stupid mistakes
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"

# More alias for convenience
alias cpv "rsync --human-readable --progress"
alias grep "grep --color=auto"
alias less "less -niRS"
alias tmux "tmux -u"
alias diff "diff --color=auto"

# Modern unix tools
alias rg "rg --color=auto"
alias ll "exa --long --group --color=auto --group-directories-first --time-style long-iso"
alias llt "exa --long --group --color=auto --group-directories-first --time-style long-iso --tree"

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
        alias g=gvim
    end
else
    alias g=vim
end
