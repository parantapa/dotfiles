#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Setup i3
xrdb ~/.Xresources
eval `ssh-agent -s -t 1d`
dunst &
nitrogen --restore &
xscreensaver -no-splash &
mpd
urxvtd -q -f -o
exec i3 -V > ~/.i3/i3log 2>&1

# exec gnome-session
# exec startkde
#exec startxfce4
# ...or the Window Manager of your choice
