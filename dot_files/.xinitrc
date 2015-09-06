#!/bin/sh
xrandr --output VGA-0 --mode 1280x768 --rate 60
xrdb -merge ~/.Xresources
xinput set-button-map 11 3 2 1 #lefty
synclient MaxTapTime=0
exec awesome
