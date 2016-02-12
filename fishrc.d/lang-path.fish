# Set gem home and gem path paths and R packages
set -x R_LIBS_USER "$HOME/.r-packages"

# Modify path in login shell only
set PATH "$HOME/.cabal/bin" $PATH

# Add ruby stuff if we have it in path
if command -s ruby >/dev/null
    set -x GEM_PATH (ruby -e 'puts Gem.user_dir')
    set -x GEM_HOME $GEM_PATH

    set PATH "$GEM_HOME/bin" $PATH
end
