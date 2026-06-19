# █▀▀ ▄█ █░█
# █▄█ ░█ ▀▀█
{
  inputs,
  config,
  pkgs,
  callPackage,
  ...
}: {
  imports = [
    ../_shared/vscode.nix
    ../_shared/packages-dev.nix
    ../_shared/packages-base.nix
    ../_shared/packages-media.nix
    ../_shared/packages-desktop.nix
    ../../modules/nix.nix
    ../../modules/nixpkgs.nix
    ../../modules/stylix.nix
    ../../modules/sops.nix
  ];

  # nix = {
  #   distributedBuilds = true;
  #   buildMachines = [
  #     {
  #       hostName = "jinora";
  #       sshUser = "chuu";
  #       system = "aarch64-linux";
  #       protocol = "ssh-ng";
  #       maxJobs = 1;
  #       speedFactor = 2;
  #       supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #       mandatoryFeatures = [];
  #     }
  #     {
  #       hostName = "iroh";
  #       sshUser = "chuu";
  #       system = "aarch64-linux";
  #       protocol = "ssh-ng";
  #       maxJobs = 1;
  #       speedFactor = 2;
  #       supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #       mandatoryFeatures = [];
  #     }
  #     {
  #       hostName = "opal";
  #       sshUser = "chuu";
  #       system = "aarch64-linux";
  #       protocol = "ssh-ng";
  #       maxJobs = 1;
  #       speedFactor = 4;
  #       supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #       mandatoryFeatures = [];
  #     }
  #     {
  #       hostName = "toph";
  #       sshUser = "chuu";
  #       system = "aarch64-linux";
  #       protocol = "ssh-ng";
  #       maxJobs = 1;
  #       speedFactor = 4;
  #       supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #       mandatoryFeatures = [];
  #     }
  #     # {
  #     #   hostName = "nixos-wsl";
  #     #   sshUser = "chuu";
  #     #   systems = ["x86_64-linux" "aarch64-linux"];
  #     #   protocol = "ssh-ng";
  #     #   maxJobs = 6;
  #     #   speedFactor = 10;
  #     #   supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #     #   mandatoryFeatures = [];
  #     # }
  #   ];
  # };
  #
  powerManagement.powertop.enable = true;

  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  users.users = {
    chuu.openssh.authorizedKeys.keys = [
      (builtins.readFile ../../homes/chuu/chuu.pub)
    ];
    root.openssh.authorizedKeys.keys = [
      (builtins.readFile ../../homes/chuu/chuu.pub)
    ];
  };

  # only keep the last five generations (otherwise boot partition can fill up too much)
  documentation.man.generateCaches = false;

  services.postgresql = {
    enable = true;
    ensureDatabases = ["shop"];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  all       all     127.0.0.1/32 trust
    '';
  };

  services.postgrest = {
    enable = true;
    settings = {
      db-uri = {
        host = "127.0.0.1";
        dbname = "shop";
        user = "postgres";
      };
      db-anon-role = "postgres";
      db-schema = "public";
      server-port = 3000;
      server-unix-socket = null;
    };
  };

  services.udev.extraRules = ''
    # Your rule goes here
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
  '';

  hardware = {
    nvidia = {
      dynamicBoost.enable = false;
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        # intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0"; # If you have an AMD iGPU
      };
    };
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    openrazer.enable = true;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/f91f391f-67ab-4099-9ed3-b783d39900e2";
  };

  networking = {
    hostName = "g14"; # Define your hostname.
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
          user = "chuu";
        };
      };
    };
    redshift = {
      enable = true;
      temperature = {
        day = 5700;
        night = 3000;
      };
    };
    mullvad-vpn = {
      enable = true;
    };
    tailscale.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    printing.enable = true;
    avahi.enable = true;
    pulseaudio.enable = false;
    atuin.enable = true;
    flatpak.enable = true;
    logind.settings = {
      Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "ignore";
        HandlePowerKey = "ignore";
      };
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      group = "users";
      user = "chuu";
      dataDir = "/home/chuu/sync"; # Default folder for new synced folders
      configDir = "/home/chuu/sync/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false; # Disable password-based SSH login for security
      settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
      banner = ''
        █▀▀ ▄█ █░█
        █▄█ ░█ ▀▀█
      '';
    };
  };

  console.keyMap = "us";

  location = {
    latitude = 50.9;
    longitude = 6.9;
    provider = "manual";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.extraRules = [
      {
        users = ["chuu"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  users.users.chuu = {
    isNormalUser = true;
    description = "chuu";
    extraGroups = ["podman" "networkmanager" "wheel" "syncthing" "audio" "jackaudio" "openrazer"];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  programs = {
    kdeconnect.enable = true;
    direnv.enable = true;
    # This enables AppImage support.
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.curl
          pkgs.libmpg123
        ];
      };
    };
    fish.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs':
          with pkgs'; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib # Provides libstdc++.so.6
            libkrb5
            keyutils
          ];
      };
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
      ];
    };
    firefox = {
      enable = true;
      package = pkgs.firefox-bin; # pre-built, avoids compiling from source
    };
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        wlrobs
        waveform
        obs-websocket
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi #optional AMD hardware acceleration
        input-overlay
        obs-gstreamer
        obs-tuna
      ];
    };
    git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "macho";
        };
        alias = {
          a = "add";
          b = "branch";
          c = "commit";
          cfg = "config";
          chp = "cherry-pick";
          co = "checkout";
          cl = "clone";
          d = "diff";
          f = "fetch";
          graph = "log --graph";
          i = "init --template=";
          l = "log";
          last = "log -1";
          m = "merge";
          pl = "pull";
          ps = "push";
          r = "reset";
          rb = "rebase";
          re = "remote";
          rm = "remote";
          s = "status";
          wd = "diff --word-diff=color";
          dni = "diff --no-index";
          sw = "switch";
        };
        core = {
          pager = "delta";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        delta = {
          navigate = "true";
          dark = "true";
          line-numbers = "true";
          options = {
            syntax-theme = "ansi"; # Replace with your chosen theme
          };
        };
        merge = {
          conflictstyle = "zdiff3";
        };
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  system.stateVersion = "25.05";
}
