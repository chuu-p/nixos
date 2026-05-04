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

  networking.hostName = "toph";

  # Use RPi4 optimized kernel for faster compilation and boot
  boot.kernelPackages = pkgs.unstable.linuxPackages_rpi4;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Disable password-based SSH login for security
    settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
    banner = ''
      ▀█▀ █▀█ █▀█ █░█
      ░█░ █▄█ █▀▀ █▀█
      IM NOT TOPH!!!
      IM MELON LORD!
      MWAHAHAAHAHAHHA!!!!
    '';
  };

  services.k3s = {
    enable = true;
    package = pkgs.k3s;
    role = "server";
    serverAddr = "https://jinora:6443";
    token = "9895e202-59c7-48ad-b87a-01edf859c40b";
    extraFlags = "--write-kubeconfig-mode 0644";
  };

  boot.kernelParams = [
    "consoleblank=60"
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
    "swapaccount=1"
  ];

  services.gitea-actions-runner = {
    instances.default = {
      enable = true;
      name = "nixos-runner-toph";
      token = "lWDbIQ44dLffgyfYZSECg7defHUaH9sklSYo2lMY";
      url = "http://opal:3000";
      labels = [
        "nixos-native:host"
        "toph"
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

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "cast"
      "dlna_dmr"
      "esphome"
      "google_assistant"
      "google_translate"
      "homeassistant_hardware"
      "homeassistant_sky_connect"
      "homekit_controller"
      "ibeacon"
      "isal"
      "kegtron"
      "matter"
      "met"
      "music_assistant"
      "opensky"
      "otbr"
      "piper"
      "radio_browser"
      "roomba"
      "rpi_power"
      "samsungtv"
      "shopping_list"
      "thread"
      "wake_word"
      "webostv"
      "whisper"
      "wyoming"
    ];
    config = {
      default_config = {};
    };
  };

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
    device = "/dev/disk/by-uuid/3c608d2e-3507-43a1-9dc2-332a95c3d2e2";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
    ];
  };

  fileSystems."/run/media/at-2" = {
    device = "/dev/disk/by-uuid/111b66d1-16ef-45b2-a7ef-6583c1d3817b";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
    ];
  };
}
