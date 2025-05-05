#!/usr/bin/env fish

# This is the polymorphic executable.
# It checks how it was called and executes different code based on that.

set invoked_name (basename (status current-filename))

function check_status
    if test $status -eq 0
        echo "$argv OK!"
    else
        echo "$argv ERROR!"
        exit 1
    end
end

switch $invoked_name
    case c-mount-backup
        sudo cryptsetup luksOpen /dev/sda1 backup
        and sudo mkdir -p /run/media/Backup
        and sudo mount /dev/mapper/backup /run/media/Backup/
        check_status decrypt

    case c-umount-backup
        sudo umount /run/media/Backup
        and sudo cryptsetup luksClose backup
        check_status encrypt

    case "*"
        echo "Unknown invocation: $invoked_name"
end
