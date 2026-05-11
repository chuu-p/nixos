{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./sshd.nix
  ];

  environment.packages = with pkgs; [
    vim
    git
    fish
    yazi
  ];

  environment.etcBackupExtension = ".bak";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.sshd = {
    enable = true;
    ports = [8022];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
    ];
  };

  user.shell = "${lib.getExe pkgs.fish}";

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "24.05";
}
