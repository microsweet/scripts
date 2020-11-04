#!/bin/bash

~/scripts/monitor.sh
proc_number=`ps -ef | grep -w dwm-status | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	/bin/bash ~/scripts/dwm-status.sh &
fi
#proc_number=`ps -ef | grep -w dwmbar | grep -v grep|wc -l`
#if [ $proc_number -le 0 ]; then
	#dwmbar &
#fi

proc_number=`ps -ef | grep -w wp-autochange | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	/bin/bash ~/scripts/wp-autochange.sh &
else
	kpid=`ps -ef | grep wp-autochange | grep -v grep | awk '{print $2}'`
	kill -9 $kpid
	/bin/bash ~/scripts/wp-autochange.sh &
fi
#picom -o 0.95 -i 0.88 --detect-rounded-corners --vsync --blur-background-fixed -f -D 5 -c -b

proc_number=`ps -ef | grep -w picom | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	picom -b
fi

proc_number=`ps -ef | grep -w tap-to-click | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	/bin/bash ~/scripts/tap-to-click.sh &
fi

proc_number=`ps -ef | grep -w inverse-scroll | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	/bin/bash ~/scripts/inverse-scroll.sh &
fi

proc_number=`ps -ef | grep -w autolock | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	/bin/bash ~/scripts/autolock.sh &
fi
#/bin/bash ~/scripts/setxmodmap-colemak.sh &
#network-manager-applet
nm-applet &
#xfce4-power-manager &
#xfce4-volumed-pulse &
#/bin/bash ~/scripts/run-mailsync.sh &
fcitx5 & 

proc_number=`ps -ef | grep -w dwm-status | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	~/scripts/autostart_wait.sh &
fi

proc_number=`ps -ef | grep -w blueman-tray | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	blueman-tray &
fi

proc_number=`ps -ef | grep -w breakNotify | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	~/go/src/notify/breakNotify &
fi


proc_number=`ps -ef | grep -w upspeed | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	~/scripts/upspeed.sh &
fi
proc_number=`ps -ef | grep -w downspeed | grep -v grep|wc -l`
if [ $proc_number -le 0 ]; then
	~/scripts/downspeed.sh
fi

start-pulseaudio-x11
xinput --set-prop 'pointer:Logitech G502' 'libinput Accel Speed' -0.7
