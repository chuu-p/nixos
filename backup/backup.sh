#!/run/current-system/sw/bin/bash

exclude=/home/chuu/git/nixos/backup/borg_exclude.txt
export BORG_REPO=ssh://chuu@q:22/run/media/chuu/Archive/borg/g14
export BORG_PASSPHRASE='chuu'

cd /
if borg --verbose --progress create --list --filter AME? --stats \
   --compression auto,zstd,19 \
   --exclude-caches --patterns-from $exclude \
   ::'{hostname}-{now}' \
   "/home/chuu/"; then
    echo back up successful
else
    echo error or warning during back up
fi
