function venv-make
    if test (count $argv) -eq 0 -a -e .venv
        mkvirtualenv -p /usr/bin/python2.7 (cat .venv)
    else
        mkvirtualenv -p /usr/bin/python2.7 $argv
    end

    pip install -U pip
    pip install -U setuptools
end
