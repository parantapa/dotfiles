#!/bin/bash
# Copy X11 clipboard to selection and vice versa

if [ "$1" == "-sel-to-clip" ] ; then
    xclip -o -selection primary | xclip -i -selection clipboard
    notify-send -u normal -t 5000 "clip-copy" "selection -> clipboard"
    exit 0
fi

if [ "$1" == "-clip-to-sel" ] ; then
    xclip -o -selection clipboard | xclip -i -selection primary
    notify-send -u normal -t 5000 "clip-copy" "clipboard -> selection"
    exit 0
fi

printf "Usage ./clip-copy.sh [-sel-to-clip|-clip-to-sel]\n" 
exit 1

