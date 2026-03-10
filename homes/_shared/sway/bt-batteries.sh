#!/usr/bin/env bash

devices=$(bluetoothctl devices Connected | awk '{print $2}')

output=""

for mac in $devices; do
    dev=$(echo "$mac" | tr ':' '_')
    path="/org/bluez/hci0/dev_${dev}"

    battery=$(busctl get-property org.bluez "$path" org.bluez.Battery1 Percentage 2>/dev/null | awk '{print $2}')

    if [ -n "$battery" ]; then
        name=$(bluetoothctl info "$mac" | awk -F': ' '/Name/ {print $2}')
        output="$output $name:$battery%"
    fi
done

echo "$output"
