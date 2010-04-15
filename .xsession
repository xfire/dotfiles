###
# window manager

export LANG="en_US.utf8"
export LC_CTYPE="$LANG"

PATH=$HOME/bin:$PATH

exec xmonad & wmpid=$!

###
# window manager

# set compose key to menu
# setxkbmap -option compose:menu
# xmodmap .xmodmap_x301
# load special keymappings for apple alu keyboard
if [ -n "$(lsusb | grep 'Apple.*Keyboard')" ]; then 
    xmodmap .xmodmap_apple_keyb_alu
fi


test -f /usr/bin/autocutsel && /usr/bin/autocutsel -selection CLIPBOARD -fork
test -f /usr/bin/autocutsel && /usr/bin/autocutsel -selection PRIMARY -fork

gnome-settings-daemon & # handles themes, starts gnome-screensaver. You may have to use gconf to disable it setting the background.
nm-applet &             # assuming you're using Network Manager
gnome-power-manager &   # for laptops and stuff
gnome-volume-manager &  # for mounting CDs, USB sticks, and such

$HOME/bin/pydzen.py &
trayer --edge top --align right --heighttype pixel --height 16 --widthtype pixel --width 70 --transparent true --alpha 0 --tint '0x2F2E2B'
$HOME/bin/set_random_wallpaper.zsh
#$HOME/bin/touchpad off
$HOME/bin/start.notify.server
$HOME/bin/start.osd.mail &

opera &

$HOME/bin/start.mail
$HOME/bin/start.loggers
$HOME/bin/start.irssi

wait $wmpid
