# ~/.profile: executed by Bourne-compatible login shells.

# Add dotfiles bin to path
PATH="$HOME/.dotfiles/bin:$PATH"

if [ "$BASH" ] ; then
	if [ -f ~/.bashrc ] ; then
		. ~/.bashrc
	fi
fi

