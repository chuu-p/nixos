#!/usr/bin/env bash
# shell script to prepend i3status with more stuff

i3status -c ~/git/nixos/homes/_shared/sway/i3status.conf | while IFS= read -r line
do
        bt_output=$(~/git/nixos/homes/_shared/sway/bt-battery-dbus.sh DB:0E:33:43:5D:BD)
        echo "${bt_output} | ${line}"
done
