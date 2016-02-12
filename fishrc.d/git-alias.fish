# Git shortcuts
alias ga "git add"
alias gd "git diff"
alias gs "git status"
alias gl "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias gc "git commit"
alias gc. "git commit -m ."

alias gclone "git clone"
alias gpull "git pull"
alias gpush "git push"

# Git SVN shortcuts
function gsclone
    if test (count $argv) -ne 1
        echo "Must provide url to clone from"
        return 1
    end
    set repourl $argv[1]
    echo $repourl

    set logfile (mktemp -t gsclone.XXXXXX)
    echo $logfile
    svn log $repourl > $logfile
    if test $status -ne 0
        echo "Failed to get repo log"
        return 1
        rm -f $logfile
    end

    set frev (command grep -P '^r\d+' $logfile | tail -n 1 | cut -d \| -f 1 | tr -d " ")
    echo $frev
    rm -f $logfile
    if test -z $frev
        echo "Failed to get first revision"
        return 1
    end

    # Git clone
    echo git svn clone -$frev $repourl
    git svn clone -$frev $repourl
    if test $status -ne 0
        echo "Falied to clone repo"
        return 1
    end

    # Get into the directory and download the stuff
    pushd (basename $repourl)
    git svn rebase
    popd
end
alias gspull "git svn rebase"
alias gspush "git svn dcommit"

function mkrepo_dotrepos
    echo ssh dotrepos "git init --bare dotrepos/"$argv[1]".git"
end

