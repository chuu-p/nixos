curl https://github.com/nix-community/NixOS-WSL/releases/download/2505.7.0/nixos.wsl
wsl --install --web-download --no-distribution
wsl --install --from-file nixos.wsl
