#!/usr/bin/python
# -*- coding: iso-8859-15 -*-
# Copyright (C) 2005 2006 Rico Schiekel <fire@donwgra.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation version 2
# of the License.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA # 02111-1307, USA.
#

import sys
import getopt
import logging
import dbus
from socket import *

def syntax():
    print "osd_server.py [options]"
    print "   options:"
    print "     -h --help       print this message"
    print "     -H --host       host of the notify server (def: localhost)"
    print "     -P --port       port of the notify server (def: 11111)"
    print "     -l --log        log file ('-' logs to stdout)"

host = 'localhost'
port = 11111
notify_send = 'notify-send'

logfile_name = ''

try:
    opts, args = getopt.getopt(sys.argv[1:], "hH:P:l:", ["help", "host=", "port=", "log="])
except getopt.GetoptError:
    syntax()
    sys.exit(2)

for opt, arg in opts:
    if opt in ("-h", "--help"):
        syntax()
        sys.exit(3)
    elif opt in ("-H", "--host"):
        host = arg
    elif opt in ("-P", "--port"):
        port = int(arg)
    elif opt in ("-l", "--log"):
        logfile_name = arg

l = socket(AF_INET, SOCK_STREAM)
l.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
l.bind((host, port))
l.listen(5)

logger = logging.getLogger('notify_server')
lformatter = logging.Formatter('%(asctime)s %(message)s')
if logfile_name not in ('', '-'):
    lfh = logging.FileHandler(logfile_name)
    lfh.setFormatter(lformatter)
    logger.addHandler(lfh)
else:
    lout = logging.StreamHandler(sys.stdout)
    lout.setFormatter(lformatter)
    logger.addHandler(lout)
logger.setLevel(logging.INFO)

logger.info("notify_server running on [%s] port [%d]" % (host, port))

bus = dbus.SessionBus()
notifyService = bus.get_object("org.freedesktop.Notifications", '/org/freedesktop/Notifications')
interface = dbus.Interface(notifyService, 'org.freedesktop.Notifications')

while 1:
    (con, addr) = l.accept()
    message = con.recv(255).strip()
    con.close()

    logger.info(message)

    message, title = (':' + message).split(':')[::-1][0:2]
    if not title:
        title, message = message, title
    interface.Notify('notify-server', 0, '', title, message, [], {}, -1)

