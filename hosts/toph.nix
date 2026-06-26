{
  inputs,
  config,
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    ./common/base.nix
    nixos-hardware.nixosModules.raspberry-pi-5
  ];

  # boot.kernelPackages = pkgs.linuxPackages_rpi;

  networking.hostName = "toph";

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

  boot.kernelParams = [
    "consoleblank=60"
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
    "swapaccount=1"
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = false;
    dataDir = "/run/media/at-1/tafl-db";
    ensureDatabases = ["toph"];
    ensureUsers = [
      {
        name = "toph";
        ensureDBOwnership = true;
      }
    ];
    authentication = ''
      local all all trust
      host  all all 127.0.0.1/32 trust
    '';
  };

  # services.grafana = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       http_addr = "0.0.0.0";
  #       http_port = 7119;
  #       # enforce_domain = true;
  #       enable_gzip = true;
  #       # domain = "grafana.your.domain";
  #
  #       # Alternatively, if you want to serve Grafana from a subpath:
  #       # domain = "your.domain";
  #       # root_url = "https://your.domain/grafana/";
  #       # serve_from_sub_path = true;
  #     };
  #
  #     # Prevents Grafana from phoning home
  #     #analytics.reporting_enabled = false;
  #   };
  # };

  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "chrysalis";
        static_configs = [
          {
            targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };

  services.tailscale.enable = true;

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

  services.loki = {
    enable = true;
    configFile = ./loki-local-config.yaml;
  };

  services.grafana = {
    enable = true;
    # domain = "";
    port = 2342;
    addr = "0.0.0.0";
  };


  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
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

  # fileSystems."/run/media/at-2" = {
  #   device = "/dev/disk/by-uuid/111b66d1-16ef-45b2-a7ef-6583c1d3817b";
  #   fsType = "btrfs";
  #   options = [
  #     "users"
  #     "nofail"
  #   ];
  # };
}
