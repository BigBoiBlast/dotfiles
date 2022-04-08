#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
#sysresources=/etc/X11/xinit/.Xresources
#sysmodmap=/etc/X11/xinit/.Xmodmap

unset XDG_RUNTIME_DIR
export XDG_RUNTIME_DIR=$(mktemp -d /tmp/$(id -u)-runtime-dir.XXX)

# merge in defaults and keymaps

#if [ -f $sysresources ]
#then
#	xrdb -merge $sysresources
#fi

#if [ -f $sysmodmap ]
#then
#	xmodmap $sysmodmap
#fi

if [ -f "$userresources" ]
then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]
then
	xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ]
then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh
	do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xset m 0 0
xset -dpms s off

pipewire &
pipewire-pulse &
pipewire-media-session &
exec dbus-launch --exit-with-session openbox-session
