{
  inputs,
  config,
  pkgs,
  nixos-hardware,
  nixos-raspberrypi,
  ...
}: {
  imports = [
    nixos-raspberrypi.lib.inject-overlays
    nixos-raspberrypi.nixosModules.trusted-nix-caches
    ./common/base.nix
    nixos-hardware.nixosModules.raspberry-pi-5
  ];

  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  networking.hostName = "toph";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Disable password-based SSH login for security
    settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
    settings.Banner = toString (pkgs.writeText "ssh-banner" ''
      ▀█▀ █▀█ █▀█ █░█
      ░█░ █▄█ █▀▀ █▀█
      IM NOT TOPH!!!
      IM MELON LORD!
      MWAHAHAAHAHAHHA!!!!
    '');
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
    package = pkgs.postgresql_18;
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

  services.prometheus = {
    enable = true;
    port = 9090;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
      blackbox = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = 9115;

        # Configure probe modules (HTTP status checks, SSL validation, timeouts)
        configFile = pkgs.writeText "blackbox-config.yaml" (builtins.toJSON {
          modules = {
            http_2xx = {
              prober = "http";
              timeout = "5s";
              http = {
                valid_status_codes = [200 201 202 204]; # Expect successful API returns
                method = "GET";
                fail_if_ssl = false;
                fail_if_not_ssl = false; # Set to true if forcing HTTPS APIs
              };
            };
          };
        });
      };
    };
    scrapeConfigs = [
      {
        job_name = "api_uptime_monitors";
        metrics_path = "/probe";
        params = {module = ["http_2xx"];}; # Target our defined HTTP module

        # Define the arbitrary Web API endpoints you want to check
        static_configs = [
          {
            targets = [
              "https://api.github.com"
              "https://httpbin.org"
              "http://127.0.0.1:3000" # Local Grafana itself
            ];
          }
        ];

        # Magic relabel configs to pass targets cleanly through Blackbox Exporter
        relabel_configs = [
          {
            source_labels = ["__address__"];
            target_label = "__param_target";
          }
          {
            source_labels = ["__param_target"];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:9115";
          } # Exporter Address
        ];
      }
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
    configFile = ./toph/loki-local-config.yaml;
  };

  services.tempo = {
    enable = true;
    settings = {
      target = "all";

      server = {
        http_listen_port = 3200;
        grpc_listen_port = 9095;
      };

      storage = {
        trace = {
          backend = "local";
          local = {
            path = "/var/lib/tempo/traces";
          };
          wal = {
            path = "/var/lib/tempo/wal";
          };
        };
      };

      distributor = {
        receivers = {
          otlp = {
            protocols = {
              http = {endpoint = "0.0.0.0:4318";};
              grpc = {endpoint = "0.0.0.0:4317";};
            };
          };
          zipkin = {endpoint = "0.0.0.0:9411";};
          jaeger = {
            protocols = {
              thrift_http = {endpoint = "0.0.0.0:14268";};
            };
          };
        };
      };
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
      panels = {
      disable_sanitize_html = true;
    };
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
      };
      smtp = {
        enabled = true;
        host = "127.0.0.1:587";
        user = "alerts@chuu.dev";
        password = "test";
        from_address = "alerts@chuu.dev";
      };
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
        }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://127.0.0.1:3100";
        }
        {
          name = "Tempo";
          type = "tempo";
          access = "proxy";
          url = "http://127.0.0.1:3200";
          jsonData = {
            httpMethod = "GET";
          };
        }
      ];
      dashboards.settings.providers = [
        {
          name = "default";
          options.path = ./toph/dashboards;
        }
      ];
    };
  };

  systemd.services.tempo.serviceConfig.StateDirectory = "tempo";

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./toph/promtail.yaml}
      '';
    };
  };

  # Enable the PostgreSQL automated backup service
  services.postgresqlBackup = {
    enable = true;

    # Select which databases to back up. If left empty, it backs up everything.
    databases = ["tafl"];

    # Directory where backup files will be saved on your machine
    location = "/run/media/at-1/postgres-backup";

    # Systemd calendar event expression for scheduling (Daily at 1:15 AM)
    startAt = "*-*-* 01:15:00";
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
