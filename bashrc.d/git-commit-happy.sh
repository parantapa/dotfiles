# Play happy kids music on git commit
if [[ "$DISPLAY" = ":0.0" ]] ; then
    unalias gc
    unalias gca

    function gc () {
        git commit && { aplay ~/sdocs/misc-files/happykids.wav & }
    }

    function gca () {
        git commit -a && { aplay ~/sdocs/misc-files/happykids.wav & }
    }
fi
