{
  inputs,
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    ./common/base.nix
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  networking.hostName = "jinora";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
    banner = ''
      ░░█ █ █▄░█ █▀█ █▀█ ▄▀█
      █▄█ █ █░▀█ █▄█ █▀▄ █▀█
      I will make
      no such
      promises.
    '';
  };

  services.k3s = {
    enable = true;
    package = pkgs.k3s;
    role = "server";
    token = "9895e202-59c7-48ad-b87a-01edf859c40b";
    clusterInit = true;
    extraFlags = "--write-kubeconfig-mode 0644";
  };

  networking.resolvconf.useLocalResolver = false;
  networking.nameservers = ["100.100.100.100" "1.1.1.1"];
  services.dnsmasq = {
    enable = true;
    settings = {
      address = ["/jinora.lan/100.96.143.57"];
      ptr-record = ["100.96.143.57,jinora.lan"];
      listen-address = ["127.0.0.1" "100.96.143.57"];
      local = "/jinora.lan/"; # fix dns 20 sec timeout
    };
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
    device = "/dev/disk/by-label/at-1";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
    ];
  };
}
