# Setup virtualenvs
export VIRTUALENV_DISTRIBUTE=1
export WORKON_HOME=$LOCAL/virtualenvs

if [[ -r "$LOCAL/bin/virtualenvwrapper.sh" ]] ; then
    . "$LOCAL/bin/virtualenvwrapper.sh"
fi
