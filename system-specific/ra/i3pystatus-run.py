#!/usr/bin/python3
# -*- coding: utf-8 -*-

import subprocess
from i3pystatus import Status

status = Status(standalone=True)

# Diplay the system volume
status.register("alsa", format = "♪: {volume}%")

# Displays clock like this:
# Jan 17 2014, 05:30PM
status.register("clock", format="%b %d %Y, %I:%M%p")

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load")

status.run()
