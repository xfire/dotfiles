#!/bin/zsh
#
# vim:syntax=zsh:sw=4:ts=4:expandtab

MCOOKIE=$(mcookie)
xauth add $(hostname)/unix$1 . $MCOOKIE
xauth add localhost/unix$1 . $MCOOKIE
Xephyr $*
xauth remove $(hostname)/unix$1 localhost/unix$1
exit 0
