#!/usr/bin/env fish

set hosts opal jinora toph iroh

printf "%s\n" $hosts | nix run nixpkgs#parallel -- \
  --jobs 4 \
  --lb \
  --tag \
  'ssh {} "sudo nixos-rebuild switch --flake github:chuu-p/nixos#{} --refresh --builders \'\'"'
