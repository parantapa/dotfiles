#!/bin/bash
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
xrdb "$HOME/.dotfiles/Xresources"
xmodmap "$HOME/.dotfiles/capslock-esc"
eval `ssh-agent -s -t 16h`
dunst &
nitrogen --restore &
xscreensaver -no-splash &
mpd
urxvtd -q -f -o
unclutter &

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

make-i3-config
exec i3 -V > "$HOME/.i3/i3log" 2>&1
