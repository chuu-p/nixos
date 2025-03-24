#!/bin/sh

exclude=/home/chuu/Documents/git/nixos/backup/borg_exclude.txt
export BORG_REPO=ssh://chuu@192.168.178.33:22/run/media/chuu/Archive/backup
export BORG_PASSPHRASE='password'

cd /
if borg --verbose --progress create --list --filter AME? --stats \
   --compression auto,zstd,19 \
   --exclude-caches --patterns-from $exclude \
   ::'{hostname}-{now}' \
   "/home/chuu/Desktop" \
   "/home/chuu/Documents" \
   "/home/chuu/Downloads" \
   "/home/chuu/Music" \
   "/home/chuu/notes" \
   "/home/chuu/Pictures" \
   "/home/chuu/syncthing" \
   "/home/chuu/Templates" \
   "/home/chuu/Videos"; then
    echo back up successful
else
    echo error or warning during back up
fi