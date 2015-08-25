#!/bin/sh
touch atest
xrandr --output VGA-0 --mode 1280x768 --rate 60
exec awesome

