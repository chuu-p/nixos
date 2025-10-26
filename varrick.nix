# █▀▀ ▄█ █░█
# █▄█ ░█ ▀▀█
{
  config,
  pkgs,
  callPackage,
  ...
}: {
  imports = [
    ./packages.nix
  ];

  powerManagement.powertop.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  nix.settings.trusted-users = ["root" "@wheel" "chuu"];

  nix.buildMachines = [
    {
      hostName = "jinora";
      sshUser = "chuu";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      mandatoryFeatures = [];
    }
    {
      hostName = "iroh";
      sshUser = "chuu";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 3;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      mandatoryFeatures = [];
    }
    {
      hostName = "opal";
      sshUser = "chuu";
      system = "aarch64-linux";
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      mandatoryFeatures = [];
    }
    # {
    #   hostName = "nixos";
    #   sshUser = "nixos";
    #   system = "x86_64-linux";
    #   # systems = ["x86_64-linux" "aarch64-linux"];
    #   protocol = "ssh";
    #   maxJobs = 4;
    #   speedFactor = 10;
    #   supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    #   mandatoryFeatures = [];
    # }
  ];
  nix.distributedBuilds = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "varrick"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.enable = true;
  networking.wireless.interfaces = ["wlp2s0"];
  networking.wireless.networks."FRITZ!Box 7583 UJ" = {
    psk = "41808552962347953265";
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      options = "caps:super";
    };
    # videoDrivers = ["nvidia"];
    displayManager.lightdm = {
      enable = true;
      greeters.slick = {
        enable = true;
        draw-user-backgrounds = true;
      };
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  location = {
    latitude = 50.9;
    longitude = 6.9;
    provider = "manual";
  };

  services.redshift = {
    enable = true;
    temperature = {
      day = 5700;
      night = 3000;
    };
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.tailscale.enable = true;

  console.keyMap = "us";

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  services.flatpak.enable = true;

  services.blueman.enable = true;

  services.picom.enable = true;

  services.printing.enable = true;

  services.avahi.enable = true;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.atuin.enable = true;

  # # services.pipewire = {
  # #   enable = true;
  # #   alsa.enable = true;
  # #   alsa.support32Bit = true;
  # #   pulse.enable = true;
  # # };

  # services.jack = {
  #   jackd.enable = true;
  #   # support ALSA only programs via ALSA JACK PCM plugin
  #   alsa.enable = false;
  #   # support ALSA only programs via loopback device (supports programs like Steam)
  #   loopback = {
  #     enable = true;
  #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #     #dmixConfig = ''
  #     #  period_size 2048
  #     #'';
  #   };
  # };

  users.users.chuu = {
    isNormalUser = true;
    description = "chuu";
    extraGroups = ["networkmanager" "wheel" "syncthing" "audio"];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  programs.fish.enable = true;

  programs.nix-ld.enable = true;

  programs.firefox.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
      waveform
      waveform
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-webkitgtk
      input-overlay
      obs-gstreamer
      obs-tuna
    ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.noto
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.symbols-only
    nerd-fonts.space-mono

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji

    font-awesome
  ];

  programs.git = {
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

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    group = "users";
    user = "chuu";
    dataDir = "/home/chuu/sync"; # Default folder for new synced folders
    configDir = "/home/chuu/sync/.config/syncthing";
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    overrideFolders = true; # overrides any folders added or deleted through the WebUI
  };

  # auto upgrading is a bad pattern due to supply chain attacks.
  # you should lock your versions
  # https://youtu.be/69F9IuBWb-E?t=119
  # system.autoUpgrade = {
  #   enable = true;
  #   randomizedDelaySec = "30min"; # Adds a random delay to prevent simultaneous updates
  #   dates = "daily"; # or "weekly", "monthly", etc.
  #   flags = ["--impure" "--flake" "/etc/nixos"];
  #   allowReboot = true; # Allow the system to reboot if necessary
  #   # email = "your-email@example.com"; # Uncomment to receive email notifications
  #   # emailOnFailure = true;
  # };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Disable password-based SSH login for security
    settings.PermitRootLogin = "prohibit-password"; # Allow root login only with a key
    banner = ''
      █░█ ▄▀█ █▀█ █▀█ █ █▀▀ █▄▀
      ▀▄▀ █▀█ █▀▄ █▀▄ █ █▄▄ █░█
    '';
  };

  users.users.chuu.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
  ];

  system.stateVersion = "24.11";
}
