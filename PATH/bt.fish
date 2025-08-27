#!/usr/bin/env fish

# This is the polymorphic executable.
# It checks how it was called and executes different code based on that.

set invoked_name (basename (status current-filename))

switch $invoked_name
    case c-bt-connect-headphones
        bluetoothctl connect 84:D3:52:E9:C3:49

    case c-bt-connect-soundbar
        bluetoothctl connect 00:02:3C:B6:EA:3D

    case c-bt-connect-pixelbuds
        bluetoothctl connect 24:29:34:B3:1A:9D

    case bt.fish
        switch $argv[1]
            case --install
                ln -s "bt.fish" c-bt-connect-headphones
                ln -s "bt.fish" c-bt-connect-soundbar
                ln -s "bt.fish" c-bt-connect-pixelbuds
                echo install OK

            case --help
                echo "bt.fish [--help / --install]"

            case "*"
                echo "unknown argument, run: bt.fish --help"
        end

    case "*"
        echo "unknown invocation: $invoked_name"
end
