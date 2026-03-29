{
  config,
  pgks,
  lib,
  ...
}: {
  networking.hostName = "bolin";
  users.users.chuu = {
    initialPassword = "chuu";
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };
  users.users.chuu.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
  ];

  # networking.networkmanager.enable = true;
  # networking.networkmanager.enable = lib.mkForce false;
  networking.wireless.enable = true;
  networking.wireless.interfaces = ["wlp2s0"];
  networking.wireless.networks."FRITZ!Box 7583 UJ" = {
    psk = "41808552962347953265";
  };

  services.openssh.enable = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  nix.settings = {
    trusted-users = ["root" "@wheel" "chuu"];
    experimental-features = ["nix-command" "flakes"];
    extra-platforms = ["aarch64-linux"];
  };
}
