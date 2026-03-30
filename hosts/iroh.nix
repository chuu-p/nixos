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

  # Use RPi4 optimized kernel for faster compilation and boot
  boot.kernelPackages = pkgs.unstable.linuxPackages_rpi4;

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

  # services.faasd.enable = true;
  # services.faasd.gateway = {
  #   writeTimeout = 30;
  #   readTimeout = 30;
  #   upstreamTimeout = 35;
  # };

  # services.k3s = {
  #   enable = true;
  #   package = pkgs.k3s;
  #   role = "server";
  #   serverAddr = "https://jinora:6443";
  #   token = "9895e202-59c7-48ad-b87a-01edf859c40b";
  #   extraFlags = "--write-kubeconfig-mode 0644";
  # };

  services.gitea-actions-runner = {
    instances.default = {
      enable = true;
      name = "nixos-runner-iroh";
      token = "lWDbIQ44dLffgyfYZSECg7defHUaH9sklSYo2lMY";
      url = "http://opal:3000";
      labels = [
        "nixos-native:host"
        "iroh"
      ];
      hostPackages = with pkgs; [
        bash
        busybox
        curl
        docker
        gitMinimal
        just
        nix
        nodejs
        pnpm
        rsync
        wget
      ];
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
    device = "/dev/disk/by-uuid/04c06918-7370-4f52-a355-6e653c5dc174";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
    ];
  };
}
