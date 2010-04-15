#!/usr/bin/env python
#
# *hackhack*
#
# vim:syntax=python:sw=4:ts=4:expandtab

import sys
import re
import dbus
import subprocess

CMD = 'amixer'
CHANNEL = 'Master'
OFFSET = 5

def notify_level(level):
    vtype = 'high'
    if level < 0:
        vtype = 'off'
    elif level < 33:
        vtype = 'low'
    elif level < 66:
        vtype = 'medium'

    bus = dbus.SessionBus()
    notifications = dbus.Interface(
        bus.get_object('org.freedesktop.Notifications', '/org/freedesktop/Notifications'),
        dbus_interface='org.freedesktop.Notifications'
    )
    notifications.Notify('gnome-settings-daemon',
                         dbus.UInt32(0),
                         'notification-audio-volume-%s' % vtype,
                         '  ',
                         '',
                         dbus.Array(signature='v'),
                         dbus.Dictionary({'value': level, 'x-canonical-private-synchronous': 'volume'}, signature='sv'),
                         -1)

RE_LEVEL = re.compile(r'^.*Playback (?P<level>\d+) \[.*$')
def notify():
    info = subprocess.Popen([CMD, "sget", CHANNEL], stdout = subprocess.PIPE)
    lines = [l for l in info.stdout.readlines() if 'Playback' in l and '[on]' in l]
    info.wait()
    if lines:
        line = lines[0]
        m = RE_LEVEL.match(line)
        if m:
            notify_level(int(m.group('level')))
    else:
        notify_level(-1)

def do_lower():
    subprocess.call([CMD, "sset", CHANNEL, "%d%%-" % OFFSET])
    notify()

def do_raise():
    subprocess.call([CMD, "sset", CHANNEL, "%d%%+" % OFFSET])
    notify()

def do_mute():
    subprocess.call([CMD, "sset", CHANNEL, "toggle"])
    notify()

def syntax():
    print 'syntax: sound.py mute|lower|raise'

if len(sys.argv) > 1:
    {'lower': do_lower,
     'raise': do_raise,
     'mute': do_mute}.get(sys.argv[1], syntax)()
