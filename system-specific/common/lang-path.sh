# Set gem home and gem path paths and R packages
export R_LIBS_USER="$HOME/.r-packages"
export GEM_PATH="$(ruby -e 'puts Gem.user_dir')"
export GEM_HOME="$GEM_PATH"

# Modify path in login shell only
if shopt -q login_shell ; then
    PATH="$HOME/.cabal/bin:$PATH"
    PATH="$GEM_HOME/bin:$PATH"
fi
