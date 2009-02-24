###
# window manager

export LANG="en_US.utf8"
export LC_CTYPE="$LANG"

PATH=$HOME/bin:$PATH

# samsung TV
#  xrandr --output LVDS --off
#  xrandr --output VGA --mode 1600x1200

if [[ -n "$(xrandr | grep 'VGA connected')" ]]; then
    xrandr --output VGA --right-of LVDS --auto
    export XINERAMA_SCREENS=2
else
    export XINERAMA_SCREENS=1
fi

xhost +local:

xset fp+ $HOME/.fonts/
xset fp rehash

exec xmonad & wmpid=$!

keychain --nocolor $HOME/.ssh/id_private

sudo /sbin/ifup wlan0

###
# window manager

# set compose key to menu
setxkbmap -option compose:menu
xmodmap .xmodmap_x301
# load special keymappings for apple alu keyboard
if [[ -n $(lsusb | grep 'Apple.*Keyboard') ]]; then 
    xmodmap .xmodmap_apple_keyb_alu
fi


test -f /usr/bin/autocutsel && /usr/bin/autocutsel -selection CLIPBOARD -fork
test -f /usr/bin/autocutsel && /usr/bin/autocutsel -selection PRIMARY -fork

$HOME/bin/pydzen.py &
$HOME/bin/set_random_wallpaper.zsh
$HOME/bin/touchpad off
$HOME/bin/start.notify.server
$HOME/bin/start.osd.mail &

opera &
pidgin &

$HOME/bin/start.mail
$HOME/bin/start.loggers
$HOME/bin/start.irssi

wait $wmpid
