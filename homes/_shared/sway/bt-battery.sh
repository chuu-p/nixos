#!/usr/bin/env bash

DEVICE="DB:0E:33:43:5D:BD"   # MAC of your keyboard

battery=$(bluetoothctl info $DEVICE | grep "Battery Percentage" | grep -o '[0-9]\+')

if [ -n "$battery" ]; then
    echo "⌨ $battery%"
else
    echo "⌨ ?"
fi
