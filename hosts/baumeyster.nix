{
  inputs,
  pkgs,
  lib,
  nixos-wsl,
  ...
}: {
  imports = [
    ./common/base.nix
    nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "nixos-wsl";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Disable password-based SSH login for security
    settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
    banner = ''
      █▄▄ ▄▀█ █░█ █▀▄▀█ █▀▀ █▄█ █▀ ▀█▀ █▀▀ █▀█
      █▄█ █▀█ █▄█ █░▀░█ ██▄ ░█░ ▄█ ░█░ ██▄ █▀▄
      money
      power
      influence
    '';
  };
  services.tailscale.enable = true;

  # Cross-compilation setup for native aarch64-linux compilation from x86_64
  # This enables native compilation instead of QEMU emulation for significantly faster builds
  boot.binfmt.emulatedSystems = [];
  boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;

  nix.settings = {
    extra-platforms = ["aarch64-linux"];
    # Enable extra-sandbox-paths to support cross-compilation
    extra-sandbox-paths = [];
  };

  # Support native aarch64 builds without emulation
  nixpkgs.config.allowUnsupportedSystem = true;

  wsl.enable = true;
  wsl.defaultUser = "chuu";
}
