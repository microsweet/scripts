#!/bin/bash

#/usr/bin/amixer -qM set Master 5%+ umute
$HOME/.Scripts/DSvolume.sh up
#pactl set-sink-volume @DEFAULT_SINK@ +5%
bash ~/scripts/dwm-status-refresh.sh
