#!/bin/sh
xrandr --output VGA-0 --mode 1280x768 --rate 60
xrdb -merge ~/.Xresources
exec awesome

