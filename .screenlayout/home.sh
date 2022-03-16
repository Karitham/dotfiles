#!/bin/sh
xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --output HDMI-1-0 --mode 1920x1080 --pos 1920x0

i3-msg '[workspace=2]' move workspace to output right >/dev/null
i3-msg '[workspace=5]' move workspace to output right >/dev/null
i3-msg '[workspace=9]' move workspace to output right >/dev/null

i3-msg workspace number 2 >/dev/null
i3-msg workspace number 1 >/dev/null
