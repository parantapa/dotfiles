"""Evince SyncTex Support."""

import os.path
from threading import Thread

import dbus
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

import vim

DAEMON_NAME = "org.gnome.evince.Daemon"
DAEMON_PATH = "/org/gnome/evince/Daemon"
DAEMON_IFACE = "org.gnome.evince.Daemon"

WINDOW_PATH = "/org/gnome/evince/Window/0"
WINDOW_IFACE = "org.gnome.evince.Window"


class EvinceMonitor(Thread):
    """Evince Monitor."""

    def __init__(self, fname, sync_source_vimfn):
        """Initialize."""
        super().__init__()

        fname = os.path.expanduser(fname)
        fname = os.path.abspath(fname)

        self.fname = fname
        self.sync_source_vimfn = sync_source_vimfn

        self.closed = False

        self.dbus_loop = DBusGMainLoop()
        self.mainloop = GLib.MainLoop()
        self.session_bus = dbus.SessionBus(mainloop=self.dbus_loop)

        self.evince_daemon = self.session_bus.get_object(
            DAEMON_NAME, DAEMON_PATH, follow_name_owner_changes=True
        )
        self.evince_name = self.evince_daemon.FindDocument(
            "file://" + self.fname, True, dbus_interface=DAEMON_IFACE
        )
        self.evince_window = self.session_bus.get_object(self.evince_name, WINDOW_PATH)

        self.session_bus.add_signal_receiver(
            self.handle_sync_source,
            "SyncSource",
            WINDOW_IFACE,
            self.evince_name,
            WINDOW_PATH,
        )
        self.session_bus.add_signal_receiver(
            self.handle_closed, "Closed", WINDOW_IFACE, self.evince_name, WINDOW_PATH
        )

    def handle_sync_source(self, fname, line_col, timestamp):
        """Handle SyncSource signal from Evince."""
        _ = timestamp

        fname = str(fname)
        fname = fname[len("file://") :]

        line = int(line_col[0])
        col = int(line_col[1])
        col = min(1, col)

        print("SyncSource", fname, line, col)
        vim.command(f"call {self.sync_source_vimfn}('{fname}', {line}, {col})")

    def handle_closed(self):
        """Handle Window Closed signal."""
        print("Closed")

        self.mainloop.quit()
        self.closed = True

    def sync_view(self, fname, line, col=-1):
        """Send SyncView signal to Evince."""
        if self.closed:
            raise ValueError("Monitor already closed")

        line = int(line)
        col = int(col)

        self.evince_window.SyncView(fname, (line, col), 0, dbus_interface=WINDOW_IFACE)

    def run(self):
        """Run the monitor thread."""
        self.mainloop.run()

    def stop(self):
        """Stop the monitor thread."""
        if not self.closed:
            self.mainloop.quit()
            self.closed = True
        self.join()
