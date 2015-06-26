# Git shortcuts
alias ga="git add"
alias gd="git diff"
alias gs="git status"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias gc="git commit"
alias gc.="git commit -m ."

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

# Execute git svn pull in all the folders
git-svn-rebase-all () {
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
git-pull-master-all () {
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
