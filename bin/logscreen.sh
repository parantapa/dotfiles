#!/bin/bash
# Screen with logging to custom logfile
# https://serverfault.com/questions/248193/specifying-a-log-name-for-screen-output-without-relying-on-screenrc

if [[ "$#" -eq 0 ]] ; then
    echo "Usage: ./logscreen.sh LOGFILE [SCREEN_OPTIONS] CMD [ARGS]"
    exit 0
fi

logfname=$(readlink -f "$1")
echo "logscreen.sh: using '$logfname' as log file"
shift

now=$(date --iso-8601=seconds)
if [[ -n "$XDG_RUNTIME_DIR" ]] ; then
    screenrc=$(mktemp -p "$XDG_RUNTIME_DIR" logscreenrc.$now.XXXXXX)
else
    screenrc=$(mktemp -t logscreenrc.$now.XXXXXX)
fi
echo "logscreen.sh: using '$screenrc' as screenrc file"

echo "logfile $logfname" > "$screenrc"
if [[ -r "$HOME/.screenrc" ]] ; then
    echo 'source $HOME/.screenrc' >> "$screenrc"
fi

exec screen -c "$screenrc" -L "$@"
