#!/usr/bin/env bash

DEVICE_MAC="$1"

DEVICE_PATH=$(echo "$DEVICE_MAC" | tr ':' '_')
DBUS_PATH="/org/bluez/hci1/dev_${DEVICE_PATH}"

battery=$(busctl get-property org.bluez "$DBUS_PATH" org.bluez.Battery1 Percentage 2>/dev/null | awk '{print $2}')

if [ -n "$battery" ]; then
    echo "$battery%"
else
    echo "N/A"
fi
