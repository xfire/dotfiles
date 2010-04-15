#!/usr/bin/env python
#
# vim:syntax=python:sw=4:ts=4:expandtab

# Based on:
# - http://projects.gnome.org/NetworkManager/developers/spec-08.html
# - test/nm-online.c (which however uses the depreciated state() method)
# - http://dbus.freedesktop.org/doc/dbus-python/doc/tutorial.html

import sys
from time import time, sleep

import dbus
from dbus.mainloop.glib import DBusGMainLoop


timeout = 30
if len(sys.argv) > 1:
    timeout = int(sys.argv[1])


DBusGMainLoop(set_as_default=True)

bus = dbus.SystemBus()
proxy = bus.get_object("org.freedesktop.NetworkManager", "/org/freedesktop/NetworkManager")


NM_STATE_UNKNOWN = 0 # The NetworkManager daemon is in an unknown state.
NM_STATE_ASLEEP = 1 # The NetworkManager daemon is asleep and all interfaces managed by it are inactive. 
NM_STATE_CONNECTING = 2 # The NetworkManager daemon is connecting a device.
NM_STATE_CONNECTED = 3 # The NetworkManager daemon is connected.
NM_STATE_DISCONNECTED = 4 # The NetworkManager daemon is disconnected.


def handle_StateChanged(state):
    if state == NM_STATE_CONNECTED:
        sys.exit(0)


state = proxy.Get("org.freedesktop.NetworkManager", "State", dbus_interface="org.freedesktop.DBus.Properties")
handle_StateChanged(state)

proxy.connect_to_signal('StateChanged', handle_StateChanged, dbus_interface='org.freedesktop.NetworkManager')

import gobject
loop = gobject.MainLoop()
gobject.threads_init()
context = loop.get_context()
start_time = time()
while 1:
    if (time() - start_time) > timeout:
        sys.exit(1)
    sleep(0.4)
    context.iteration(False)
