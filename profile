# ~/.profile: executed by Bourne-compatible login shells.

HOME_DOTFILES="$HOME/.dotfiles"
HOME_QUICKREFS="$HOME/quickrefs"
HOME_SDOCS="$HOME/sdocs"

export HOME_DOTFILES
export HOME_QUICKREFS
export HOME_SDOCS

# Add dotfiles bin to path
PATH="$HOME_DOTFILES/bin:$PATH"

if [ "$BASH" ] ; then
	if [ -f ~/.bashrc ] ; then
		. ~/.bashrc
	fi
fi

