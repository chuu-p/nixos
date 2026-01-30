#!/usr/bin/env fish

# This is the polymorphic executable.
# It checks how it was called and executes different code based on that.

set invoked_name (basename (status current-filename))

function check_status
    if test $status -eq 0
        notify-send "$argv OK!"
    else
        notify-send "$argv ERROR!"
        exit 1
    end
end

# TODO: ~/.local/state/

switch $invoked_name
    case c-display-mirror
        wlr-randr --output DP-1 --on --same-as eDP-1
        check_status c-display-mirror

    case c-display-extend
        wlr-randr --output eDP-1 --on --output DP-1 --on --right-of eDP-1
        check_status c-display-extend

    case c-display-second
        wlr-randr --output eDP-1 --off --output DP-1 --on
        # randr --output eDP-1 --off --output DP-1 --mode 1920x1080 --scale 1.333x1.333 --rate 180.00
        check_status c-display-second

    case c-display-first
        wlr-randr --output eDP-1 --on --output DP-1 --off
        check_status c-display-first

    case displayctl.fish
        switch $argv[1]
            case --install
                ln -s "displayctl.fish" c-display-mirror
                ln -s "displayctl.fish" c-display-extend
                ln -s "displayctl.fish" c-display-second
                ln -s "displayctl.fish" c-display-first
                echo install OK

            case --help
                echo "displayctl.fish [--help / --install]"

            case "*"
                echo "unknown argument, run: displayctl.fish --help"
        end

    case "*"
        echo "unknown invocation: $invoked_name"
end
