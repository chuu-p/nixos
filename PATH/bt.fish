#!/usr/bin/env fish

# This is the polymorphic executable.
# It checks how it was called and executes different code based on that.

set invoked_name (basename (status current-filename))

switch $invoked_name
    case c-bt-reset-headphones
        sudo modprobe -r btusb
        sleep 2
        sudo modprobe btusb
        sleep 3
        bluetoothctl power off
        sleep 2
        bluetoothctl power on
        sleep 2
        bluetoothctl scan on
        set mac 84:D3:52:E9:C3:49
        echo "Scanning for $mac ..."
        for i in (seq 1 30)
            if bluetoothctl devices | grep -qi $mac
                echo "Found! Connecting..."
                bluetoothctl connect $mac
                break
            end
            sleep 1
        end
        bluetoothctl scan off 2>/dev/null
        echo "Done."

    case c-bt-connect-headphones
        bluetoothctl connect 84:D3:52:E9:C3:49

    case c-bt-connect-soundbar
        bluetoothctl connect 00:02:3C:B6:EA:3D

    case c-bt-connect-pixelbuds
        bluetoothctl connect 24:29:34:B3:1A:9D

    case c-bt-connect-shokz
        bluetoothctl connect C0:86:B3:8F:1E:82

    case bt.fish
        switch $argv[1]
            case --install
                ln -s "bt.fish" c-bt-connect-headphones
                ln -s "bt.fish" c-bt-connect-soundbar
                ln -s "bt.fish" c-bt-connect-pixelbuds
                ln -s "bt.fish" c-bt-connect-shokz
                ln -s "bt.fish" c-bt-reset-headphones
                echo install OK

            case --help
                echo "bt.fish [--help / --install]"

            case "*"
                echo "unknown argument, run: bt.fish --help"
        end

    case "*"
        echo "unknown invocation: $invoked_name"
end
