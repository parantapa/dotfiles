# ~/.profile: executed by Bourne-compatible login shells.

# Add My Cabal to path
PATH="$HOME/.cabal/bin:$HOME/.dotfiles/bin:$PATH"
export PATH

if [ "$BASH" ] ; then
	if [ -f ~/.bashrc ] ; then
		. ~/.bashrc
	fi
fi

