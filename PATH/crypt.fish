#!/usr/bin/env fish

# This is the polymorphic executable.
# It checks how it was called and executes different code based on that.

# --- Configuration ---
set -l DEFAULT_DEVICE /dev/sda1
set -l DEFAULT_MOUNT_POINT /run/media/Backup
set -l DEVICE_MAPPER_NAME backup
# ---------------------

set invoked_name (basename (status current-filename))

function check_status
    if test $status -eq 0
        echo "$argv OK!"
    else
        echo "$argv ERROR!"
        exit 1
    end
end

# Set parameters with defaults
set -l device $argv[1]
if test -z "$device"
    set device $DEFAULT_DEVICE
end

set -l mount_point $argv[2]
if test -z "$mount_point"
    set mount_point $DEFAULT_MOUNT_POINT
end

# Main logic
switch $invoked_name
    case c-mount-backup
        echo "Attempting to mount $device to $mount_point..."
        sudo cryptsetup luksOpen $device $DEVICE_MAPPER_NAME
        and sudo mkdir -p $mount_point
        and sudo mount /dev/mapper/$DEVICE_MAPPER_NAME $mount_point
        check_status "Mounting and decrypting backup drive"

    case c-umount-backup
        echo "Attempting to unmount $mount_point and close LUKS device..."
        sudo umount $mount_point
        and sudo cryptsetup luksClose $DEVICE_MAPPER_NAME
        check_status "Unmounting and encrypting backup drive"

    case "*"
        echo "Unknown invocation: $invoked_name"
end
