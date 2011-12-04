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

# Time to set a fancy prompt
if [ "`id -u`" -eq 0 ] ; then
	PS1='['
else
	PS1='[\u@'
fi
PS1="$PS1\\h: \\W]\\$ "

# I am still on python2
alias python=python2
alias pydoc=pydoc2
alias pip=pip2
alias ipython=ipython2
alias cython=cython2
