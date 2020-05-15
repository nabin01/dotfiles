#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# keyboard hacks
# Swap escape and caps lock
setxkbmap -option "caps:swapescape" 

# set background
nitrogen --restore &

while true
do
	VOL=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')
	LOCALTIME=$(date +%h\ %d\ \|\ %H:%M)
	IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1) # can get confused if you use vmware
	#TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"

	BAT="Bat. $(acpi -b | awk '{ print $4  }' | tr -d ',')"
	xsetroot -name "$IP | $BAT | $VOL | $LOCALTIME"

	sleep 30s
done &

exec dwm 
