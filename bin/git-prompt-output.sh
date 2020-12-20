#!/bin/bash

if [[ ! -r "/usr/share/git/git-prompt.sh" ]] ; then
    echo "Error: git prompt script not found!"
    exit 1
fi

if [[ ! -d "$1/.git" ]] ; then
    echo "Error: given directory is not a git repo."
    exit 1
fi

. "/usr/share/git/git-prompt.sh"

cd "$1"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_DESCRIBE_STYLE="branch"

__git_ps1 
