# ~/.bashrc: executed by bash(1) for non-login shells.

export HOME_DOTFILES="$HOME/dotfiles"
export HOME_QUICKREFS="$HOME/quickrefs"
export HOME_SDOCS="$HOME/sdocs"

source "$HOME_DOTFILES/bashrc.d/basic.sh"
source "$HOME_DOTFILES/bashrc.d/dotfiles.sh"

# source "$HOME_DOTFILES/bashrc.d/myprompt.sh"
# source "$HOME_DOTFILES/bashrc.d/git-alias.sh"
# source "$HOME_DOTFILES/bashrc.d/myvars.sh"
# source "$HOME_DOTFILES/bashrc.d/misc.sh"

if [[ -r "$HOME/edocs/bashrc.sh" ]] ; then
    source "$HOME/edocs/bashrc.sh"
fi

# pathadd "$HOME_SDOCS/bin"
# pathadd "$HOME/bin"
