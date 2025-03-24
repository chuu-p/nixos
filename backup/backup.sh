#!/bin/sh

exclude=/home/gxjb/Documents/git/nixos/backup/borg_exclude.txt
export BORG_REPO=ssh://chuu@192.168.178.33:22/run/media/chuu/Archive/backup
export BORG_PASSPHRASE='chuu'

cd /
if borg --verbose --progress create --list --filter AME? --stats \
   --compression auto,zstd,19 \
   --exclude-caches --patterns-from $exclude \
   ::'{hostname}-{now}' \
   "/home/gxjb/Desktop" \
   "/home/gxjb/Documents" \
   "/home/gxjb/Downloads" \
   "/home/gxjb/Music" \
   "/home/gxjb/notes" \
   "/home/gxjb/Pictures" \
   "/home/gxjb/syncthing" \
   "/home/gxjb/Templates" \
   "/home/gxjb/Videos"; then
    echo back up successful
else
    echo error or warning during back up
fi