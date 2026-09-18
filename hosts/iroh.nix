{
  inputs,
  pkgs,
  lib,
  config,
  nixos-hardware,
  nixos-raspberrypi,
  ...}
: {
  imports = [
    nixos-raspberrypi.lib.inject-overlays
    nixos-raspberrypi.nixosModules.trusted-nix-caches
    ./common/base.nix
    nixos-hardware.nixosModules.raspberry-pi-5
    inputs.sops-nix.nixosModules.sops
    inputs.hermes-agent.nixosModules.default
  ];

  networking.hostName = "iroh";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Disable password-based SSH login for security
    settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
    settings.Banner = toString (pkgs.writeText "ssh-banner" ''
      █ █▀█ █▀█ █░█
      █ █▀▄ █▄█ █▀█
      If you look for the light
      you will often
      find it.
    '');
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

  # NVMe SSD: hermes state + nixos checkout for agent-managed rebuilds
  fileSystems."/mnt/at-1" = {
    device = "/dev/disk/by-uuid/04c06918-7370-4f52-a355-6e653c5dc174";
    fsType = "btrfs";
    options = ["nofail"];
  };

  # ── Hermes agent: persistent agent, reachable via Discord DMs ──
  sops = {
    age.sshKeyPaths = ["/home/chuu/.ssh/id_ed25519"];
    secrets."hermes-env" = {
      sopsFile = ../secrets/hermes.env;
      format = "dotenv";
    };
  };

  services.hermes-agent = {
    enable = true;
    # State (memory, sessions, skills) lives on the NVMe
    stateDir = "/mnt/at-1/hermes";
    # OPENCODE_GO_API_KEY, DISCORD_BOT_TOKEN, DISCORD_ALLOWED_USERS
    environmentFiles = [config.sops.secrets."hermes-env".path];
    settings = {
      model = {
        provider = "opencode-go";
        default = "muse-spark-1.2-contributor";
      };
      platforms.discord.enabled = true;
    };
    hermesHomeFiles."SOUL.md" = ''
      You are Hermes, the persistent agent of iroh, a Raspberry Pi 5 running NixOS.
      You help manage this machine: you may restart services and prepare nixos-rebuild changes.
      The NixOS configuration lives in /mnt/at-1/nixos (a git checkout of the cluster repo).
      Sudo is allowed for systemctl and nixos-rebuild; check before you restart and never destroy data on the NVMe.
    '';
  };

  # Agent-managed machine: relax the module's sandbox so sudo/nixos-rebuild work.
  systemd.services.hermes-agent = {
    serviceConfig = {
      NoNewPrivileges = lib.mkForce false;
      ProtectSystem = lib.mkForce "off";
    };
    after = ["mnt-at\\x2d1.mount"];
    requires = ["mnt-at\\x2d1.mount"];
  };

  # Sudo for the agent. nixos-rebuild is root-equivalent (flake code runs as
  # root) — accepted risk on iroh, which only runs the agent itself.
  security.sudo.extraRules = [
    {
      users = ["hermes"];
      commands = [
        {command = "/run/current-system/sw/bin/nixos-rebuild"; options = ["NOPASSWD"];}
        {command = "/run/current-system/sw/bin/systemctl"; options = ["NOPASSWD"];}
      ];
    }
  ];

  # chuu shares HERMES_HOME with the gateway for CLI use over ssh
  services.hermes-agent.addToSystemPackages = true;
  users.users.chuu.extraGroups = ["hermes"];
}
