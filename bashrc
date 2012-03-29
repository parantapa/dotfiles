# ~/.bashrc: executed by bash(1) for non-login shells.

# append to the history file, don't overwrite it
shopt -s histappend

# Hack to consistantly update history when using multiple sessions
PROMPT_COMMAND="history -a"

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

# Set the environmetal veriables to something I like
export GREP_OPTIONS='--color=auto'
export LESS='-niRS'
export PAGER=less
export EDITOR=vim
export VISUAL=vim

# Make tmux always use unicode
alias tmux="tmux -u"
alias diff="colordiff"
alias pacman="pacman-color"

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
if [ -r /etc/bash_completion.d/git ] ; then
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto"

    . /etc/bash_completion.d/git

    PS1="${txtcyn}\u@\h${txtred}: ${txtgrn}\W ${txtylw}\$(__git_ps1 \"(%s)\")${txtred}\\\$ ${txtrst}"
else
    PS1="${txtcyn}\u@\h${txtred}: ${txtgrn}\W ${txtred}\\\$ ${txtrst}"
fi

# Shortcut for ps-ing pgrep output
psg () { ps -f $(pgrep "$@") ; }

# Use virtualenvwrapper
if [ -r /usr/bin/virtualenvwrapper.sh ] ; then
    export WORKON_HOME=$HOME/.virtualenvs

    . /usr/bin/virtualenvwrapper.sh
fi

alias gc="git commit"
alias gs="git status"
alias gd="git diff"
alias gl="git log"
alias gca="git commit -a"
