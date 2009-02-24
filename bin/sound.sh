#!/bin/zsh

CHANNEL="Master"
OFFSET=5
PIDFILE=/tmp/osd_cat.pid

test -n "$2" && CHANNEL="$2"

if [[ -f $PIDFILE ]] {
    kill `cat $PIDFILE` 2> /dev/null
    rm -f $PIDFILE
}

case "$1" {
    ("lower" | "l")
        amixer sset $CHANNEL "$OFFSET%-" >/dev/null 2>&1
    ;;
    ("raise" | "r")
        amixer sset $CHANNEL "$OFFSET%+" >/dev/null 2>&1
    ;;
    ("mute" | "m")
        amixer sset $CHANNEL toggle >/dev/null 2>&1
    ;;
    (*)
        echo "syntax: $0 mute|lower|raise [channel (def: master)]"
        exit
    ;;
}

nvol=$(amixer sget $CHANNEL | grep "Playback" | grep "\[on\]" | grep -m 1 "%" | sed 's|^.*\[\([0-9]\{1,3\}\)%\].*$|\1|')

posd="$nvol"
test -z "$posd" && posd="0"

if [[ -z "$nvol" ]] {
    info="$CHANNEL -> Mute"
} else {
    info="$CHANNEL -> $nvol%"
}

osd_cat -b percentage -P "$posd" -c green -A center -p bottom -T "$info" &

echo $! > $PIDFILE

