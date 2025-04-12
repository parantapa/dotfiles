# ~/.bashrc: executed by bash(1) for non-login shells.

export HOME_DOTFILES="$HOME/dotfiles"
export HOME_QUICKREFS="$HOME/quickrefs"
export HOME_SDOCS="$HOME/sdocs"

source "$HOME/dotfiles/bashrc.d/basic.sh"
# source "$HOME/dotfiles/bashrc.d/myprompt.sh"
# source "$HOME/dotfiles/bashrc.d/git-alias.sh"

if [[ -r "$HOME/edocs/bashrc.sh" ]] ; then
    source "$HOME/edocs/bashrc.sh"
fi

pathadd "$HOME/dotfiles/bin"
# pathadd "$HOME/sdocs/bin"
# pathadd "$HOME/bin"
