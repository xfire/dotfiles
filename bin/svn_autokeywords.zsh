#!/bin/zsh

# TODO
# - mit file test obs bin ist

DRYRUN=0
if [[ "$1" == "--dry-run" ]] {
    DRYRUN=1
    shift
}

test -z "$1" -o ! -r "$1" && exit

props=$(/bin/grep -I '\$\(\w*\)[:\$]' "$1" | sed 's|^.*\$\(\w*\)[:\$].*$|\1|g' | sort -u)

# geht das einfacher? 
props=$(echo -n "$props" |\
    grep '^LastChangedDate$|^Date$|^LastChangedRevision$|^Revision$|^Rev$|^LastChangedBy$|^Author$|^HeadURL$|^URL$|^Id$' | \
    tr '\n' ' ')

if [[ -n "$props" ]] {
    if [[ $DRYRUN -eq 0 ]] {
        svn propset svn:keywords "$props" "$1"
    } else {
        echo svn propset svn:keywords "$props" "$1"
    }
}
