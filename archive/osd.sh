#!/usr/bin/env bash

TITLE=$(playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl metadata artist 2>/dev/null)
STATUS=$(playerctl status 2>/dev/null)

[ -z "$TITLE" ] && TITLE="Nothing Playing"
[ -z "$ARTIST" ] && ARTIST=""

ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)
ICON_PATH="/tmp/cover.jpg"

if [[ $ART_URL == file://* ]]; then
    IMG_PATH="${ART_URL#file://}"
    cp "$IMG_PATH" "$ICON_PATH"
else
    ICON_PATH="/usr/share/icons/Adwaita/64x64/status/media-playback-start.png"
fi

# Use dunstify with actions
dunstify \
    -a "Media Controls" \
    -i "$ICON_PATH" \
    -u normal \
    -h string:x-dunst-stack-tag:media \
    "🎵 $ARTIST" "$TITLE [$STATUS]"
