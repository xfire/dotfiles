#!/bin/zsh

DRYRUN=0
if [[ "$1" == "--dry-run" ]] {
    DRYRUN=1
    shift
}

PATTERN="$1"
test -z "$PATTERN" && echo "syntax: $0 [--dry-run] <svn:ignore pattern>" && exit -1

autoload zargs
foreach dir in $(zargs -- **/*(/) --);
    local ic=$(svn pg svn:ignore "$dir")
    local hp=$(svn pg svn:ignore "$dir" | grep "$PATTERN")
    if [[ -z "$hp" ]] {
        if [[ -z "$ic" ]] {
            ic="$PATTERN"
        } else {
            ic=$(echo "$ic\n$PATTERN")
        }
        if [[ $DRYRUN -eq 0 ]] {
            svn propset svn:ignore "$ic" "$dir"
        } else {
            echo -E svn propset svn:ignore "\"$ic\"" "\"$dir\""
        }
    }
end

