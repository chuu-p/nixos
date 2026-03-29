{
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

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.loader.generic-extlinux-compatible.enable = lib.mkForce false;
  nix.settings.extra-platforms = ["aarch64-linux"];

  wsl.enable = true;
  wsl.defaultUser = "chuu";
}
