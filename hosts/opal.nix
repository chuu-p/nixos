{
  pkgs,
  nixos-hardware,
  lib,
  ...
}: let
  # pythonWithFixedPsycopg = pkgs.python312.override {
  #   packageOverrides = self: super: {
  #     psycopg = super.psycopg.overrideAttrs (_: {
  #       checkPhase = ''
  #         echo "Skipping tests"
  #       '';
  #       doCheck = false;
  #     });
  #   };
  # };
  # paperlessFixed = pkgs.paperless-ngx.override {
  #   python3 = pythonWithFixedPsycopg;
  # };
  keybr = pkgs.buildNpmPackage {
    pname = "keybr";
    version = "0.0.0";

    src = pkgs.fetchgit {
      url = "http://opal:3000/artemis/keybr.com.git";
      rev = "68a3b57b9da90cf47a54f9f8498ae6ea34ce2a6d";
      sha256 = "sha256-Y54pxucGo4zm/zHq98Gpb8ohO7atgTZmx5NazamAuVg=";
    };

    npmDepsHash = "sha256-yc0qrkENKRWwMsa0d83BUCYM/WvUIdbZLf9iY3V4Z/o=";

    npmBuildScript = "build";

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in {
  imports = [
    ./common/base.nix
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  networking.hostName = "opal";

  # Use RPi4 optimized kernel for faster compilation and boot
  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  programs.ssh.startAgent = lib.mkForce false;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "chuu";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
    banner = ''
      █▀█ █▀█ ▄▀█ █░░
      █▄█ █▀▀ █▀█ █▄▄
      Protection and power
      are overrated.
      Choose happiness and love.
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

  services.music-assistant = {
    enable = true;
    providers = [
      # "audiobookshelf",
      "builtin"
      "chromecast"
      "dlna"
      "filesystem_local"
      "filesystem_smb"
      "gpodder"
      "jellyfin"
      "radiobrowser"
      "ytmusic"
    ];
  };
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "cast"
      "dlna_dmr"
      "esphome"
      "google_assistant"
      "homeassistant_hardware"
      "homeassistant_sky_connect"
      "homekit_controller"
      "ibeacon"
      "isal"
      "kegtron"
      "matter"
      "met"
      # "music_assistant"
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
      # "anthropic"
      # "kef"
      # "yale"
    ];
    # extraPackages = python3Packages:
    #   with python3Packages; [
    #     numpy
    #     python-matter-server
    #     universal-silabs-flasher
    #   ];
    config = {
      default_config = {};
    };
  };

  # Do not use this in production. This will make passwords world-readable in the Nix store
  services.maddy = {
    enable = true;

    hostname = "mail.chuu.dev";
    primaryDomain = "chuu.dev";

    ensureAccounts = [
      "alerts@chuu.dev"
    ];

    ensureCredentials = {
      "alerts@chuu.dev".passwordFile =
        pkgs.writeText "alerts-password" "test";
    };
  };

  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
      PORT = "3008";
    };
  };

  # environment.etc."paperless-admin-pass".text = "admin";
  #
  # services.paperless = {
  #   enable = true;
  #   address = "0.0.0.0";
  #   port = 28981;
  #   passwordFile = "/etc/paperless-admin-pass";
  #   dataDir = "/run/media/at-2/paperless";
  #   package = paperlessFixed;
  # };

  services.gitea = {
    enable = true;
    stateDir = "/run/media/at-2/gitea";
    settings = {
      packages = {
        ENABLED = true;
      };

      actions = {
        ENABLED = true;
      };

      database = {
        DB_TYPE = "sqlite3";
      };

      service = {
        REGISTER_EMAIL_CONFIRM = false;
        START_SSH_SERVER = true;
      };

      server = {
        DOMAIN = "opal";
        ROOT_URL = "http://opal:3000";
        HTTP_PORT = 3000;
        SSH_PORT = 2222;
      };

      ui = {
        THEMES = "github-auto, github-dark, github-light, github-pink-auto, github-pink-dark, github-pink-light, github-pink-soft-dark, github-soft-dark";
        DEFAULT_THEME = "github-pink-auto";
      };

      repository = {
        DEFAULT_BRANCH = "macho";
      };
    };
  };

  systemd.services.keybr = {
    description = "Keybr Typing Trainer";
    after = ["network.target"];

    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${pkgs.nodejs}/bin/node ${keybr}/root/index.js";
      WorkingDirectory = keybr;
      Restart = "always";
      Environment = "NODE_ENV=production";
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
    options = [
      "noatime"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=1min"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
    options = ["noatime"];
  };

  fileSystems."/run/media/at-2" = {
    device = "/dev/disk/by-uuid/998a6328-3ac2-4288-a8e2-ff828cfe3939";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      "exec"
    ];
  };
}
