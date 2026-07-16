{
  inputs,
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    ./common/base.nix
    nixos-hardware.nixosModules.raspberry-pi-5
  ];

  networking.hostName = "iroh";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Disable password-based SSH login for security
    settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
    banner = ''
      █ █▀█ █▀█ █░█
      █ █▀▄ █▄█ █▀█
      If you look for the light
      you will often
      find it.
    '';
  };


  boot.kernelParams = [
    "consoleblank=60"
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
    "swapaccount=1"
  ];

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-uuid/2175-794E";
    fsType = "vfat";
    options = ["noatime" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=1min"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/run/media/at-1" = {
    device = "/dev/disk/by-uuid/04c06918-7370-4f52-a355-6e653c5dc174";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
    ];
  };
}
