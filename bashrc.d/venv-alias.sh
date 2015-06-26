# Make virtualenv
venv-make () {
    if [[ -z "$@" ]] && [[ -e .venv ]] ; then
        mkvirtualenv -p "$(command -vp python2.7)" "$(< .venv)"
    else
        mkvirtualenv -p "$(command -vp python2.7)" "$@"
    fi

    pip install -U pip
    pip install -U setuptools
}

# Setup PyGTK in the current virtualenv
# Assume pygkt is installed in system at /usr/lib/python2.7
venv-install-pygtk () {
    local fromdir="${1-/usr/lib/python2.7/site-packages}"
    local files=(glib gobject cairo gtk-2.0 pygtk.pth pygtk.py)
    local f

    cdsitepackages
    echo "cdsitepackages"

    set -x
    pwd

    for f in "${files[@]}" ; do
        ln -s "${fromdir}/${f}"
    done
    set +x

    cd -
}

# Upgrade all packages installed in virtualenv
# http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip
venv-upgrade-all () {
    pip freeze --local | \
        \grep -v "^\-e" | \
        cut -d = -f 1  | \
        xargs pip install -U
}
