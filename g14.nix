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
    <musnix>
    ./packages.nix
  ];

  nixowos.enable = true;

  # This enables AppImage support.
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  powerManagement.powertop.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  nix.settings.trusted-users = ["root" "@wheel" "chuu"];

  programs.direnv.enable = true;
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';
  documentation.man.generateCaches = false;

  # nix.buildMachines = [
  #   {
  #     hostName = "jinora";
  #     sshUser = "chuu";
  #     system = "aarch64-linux";
  #     protocol = "ssh-ng";
  #     maxJobs = 1;
  #     speedFactor = 2;
  #     supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #     mandatoryFeatures = [];
  #   }
  #   {
  #     hostName = "iroh";
  #     sshUser = "chuu";
  #     system = "aarch64-linux";
  #     protocol = "ssh-ng";
  #     maxJobs = 1;
  #     speedFactor = 3;
  #     supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #     mandatoryFeatures = [];
  #   }
  #   {
  #     hostName = "opal";
  #     sshUser = "chuu";
  #     system = "aarch64-linux";
  #     protocol = "ssh-ng";
  #     maxJobs = 1;
  #     speedFactor = 2;
  #     supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #     mandatoryFeatures = [];
  #   }
  #   # {
  #   #   hostName = "nixos";
  #   #   sshUser = "nixos";
  #   #   system = "x86_64-linux";
  #   #   # systems = ["x86_64-linux" "aarch64-linux"];
  #   #   protocol = "ssh";
  #   #   maxJobs = 4;
  #   #   speedFactor = 10;
  #   #   supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
  #   #   mandatoryFeatures = [];
  #   # }
  # ];
  # nix.distributedBuilds = true;

  # This is needed for Slippi to run.
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.curl
      pkgs.libmpg123
    ];
  };

  services.udev.extraRules = ''
    # Your rule goes here
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
  '';

  musnix.enable = true;

  hardware.nvidia = {
    dynamicBoost.enable = false;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.openrazer.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];

  boot.plymouth = {
    enable = true;
    theme = "details";
  };

  networking.hostName = "g14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    videoDrivers = ["nvidia"];
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

  services.ollama = {
    enable = true;
    # Optional: preload models, see https://ollama.com/library
    loadModels = ["qwen2.5-coder:3b"];
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

  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  # };

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
    extraGroups = ["networkmanager" "wheel" "syncthing" "audio" "jackaudio" "openrazer"];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  programs.fish.enable = true;

  programs.steam.enable = true;

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
      input-overlay
      obs-gstreamer
      obs-tuna
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    # permittedInsecurePackages = [
    # "mkchromecast"
    # "python3.12-youtube-dl-2021.12.17"
    # ];
  };
  nixpkgs = {
    overlays = [
      (final: prev: {
        nvchad = inputs.nix4nvchad.packages."${pkgs.system}".nvchad;
      })
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.noto
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.symbols-only
    nerd-fonts.space-mono

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji

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

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend-then-hibernate";
      HandleLidSwitchExternalPower = "ignore";
      HandlePowerKey = "ignore";
    };
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
      █▀▀ ▄█ █░█
      █▄█ ░█ ▀▀█
    '';
  };

  users.users.chuu.openssh.authorizedKeys.keys = [
    (builtins.readFile /home/chuu/.ssh/id_ed25519.pub)
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile /home/chuu/.ssh/id_ed25519.pub)
  ];

  system.stateVersion = "25.05";
}
