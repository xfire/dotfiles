#!/bin/bash
#
# vim:syntax=sh:sw=4:ts=4:expandtab

test -f /usr/bin/autocutsel && /usr/bin/autocutsel -selection CLIPBOARD -fork
test -f /usr/bin/autocutsel && /usr/bin/autocutsel -selection PRIMARY -fork

$HOME/bin/pydzen.py &
trayer --edge top --align right --heighttype pixel --height 16 --widthtype pixel --width 70 --transparent true --alpha 0 --tint '0x2F2E2B' &

$HOME/bin/start.notify.server
$HOME/bin/start.osd.mail &

$HOME/bin/wait_for_network.py

opera &

$HOME/bin/start.mail
$HOME/bin/start.loggers
$HOME/bin/start.irssi
