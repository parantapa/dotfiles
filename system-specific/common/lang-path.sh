# Set gem home and gem path paths and R packages
export R_LIBS_USER="$HOME/.r-packages"

# Modify path in login shell only
pathadd "$HOME/.cabal/bin"

# Add ruby stuff if we have it in path
if hash ruby 2>/dev/null ; then
    export GEM_PATH="$(ruby -e 'puts Gem.user_dir')"
    export GEM_HOME="$GEM_PATH"

    pathadd "$GEM_HOME/bin"
fi
