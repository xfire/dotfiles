#!/bin/zsh
#

WPDIR="$HOME/.backgrounds"

WP=$(ls -1 "$WPDIR" | awk -v r=$RANDOM 'BEGIN{RS="";FS="\n";srand();}{x=int((rand() * r) % NF);print $x}')

#Esetroot -center -fit "$WPDIR/$WP"
Esetroot -mirror "$WPDIR/$WP"
