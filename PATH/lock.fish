#!/usr/bin/env fish

if playerctl -a status 2>&1 | not grep -q Playing
    i3lock -i /home/chuu/git/nixos/wallpapers/cirno_nix.png
end
