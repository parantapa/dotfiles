# Provide a local install space
export LOCAL="$HOME/local"

# So that gcc can find stuff at compile time
export C_INCLUDE_PATH="$LOCAL/include"
export CPLUS_INCLUDE_PATH="$LOCAL/include"
export LIBRARY_PATH="$LOCAL/lib"

# So that programs can find stuff at runtime
export LD_LIBRARY_PATH="$LOCAL/lib"
export PKG_CONFIG_PATH="$LOCAL/lib/pkgconfig"
export MANPATH="$LOCAL/share/man:/usr/man:/usr/share/man:/usr/local/share/man"

export PYTHONUSERBASE="$LOCAL"

if shopt -q login_shell ; then
    PATH="$LOCAL/bin:$PATH"
fi
