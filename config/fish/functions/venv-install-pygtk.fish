# Setup PyGTK in the current virtualenv
# Assume pygkt is installed in system at /usr/lib/python2.7
function venv-install-pygtk
    set fromdir /usr/lib/python2.7/site-packages
    set files glib gobject cairo gtk-2.0 pygtk.pth pygtk.py

    echo cdsitepackages
    cdsitepackages

    echo pwd
    pwd

    for f in $files
        echo ln -s "$fromdir/$f"
        ln -s "$fromdir/$f"
    end

    cd -
end
