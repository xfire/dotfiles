#! /bin/zsh

rm -fr ~/.bogofilter


filter() {
    find ~/Maildir/$1/{cur,new} -type f | bogofilter -b $2
}

cd ~/Maildir

now=`date +%s`
bigmark=$now
for i (.*) {
    mark=$now
    type=""
    case "$i" {
        (..) continue ;;
        (.Drafts) continue ;;
        (.Sent*) continue ;;
        (.archiv*) continue ;;
        (.spam.learn*) 
            filter "$i" "-s"
            type="[spam]"
            ;;
        (*)
            filter "$i" "-n"
            type="[ham]"
            ;;
    }
    now=`date +%s`
    printf "%-34s %3d seconds %s\n" $i $(($now - $mark)) $type
}

printf "----\n"
printf "%-34s %3d seconds\n" total $(($now - $bigmark))
