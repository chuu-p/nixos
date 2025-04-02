{
  config,
  pkgs,
  ...
}: {
  imports = [
  ];

  hardware.nvidia.dynamicBoost.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = with pkgs; [gnome-settings-daemon mutter];
      extraGSettingsOverrides = ''
        [org.gnome.settings-daemon.plugins.media-keys]
        custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

        [org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0]
        binding='<Super>t'
        command='alacritty'
        name='Open terminal'

        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.chuu = {
    isNormalUser = true;
    description = "chuu";
    extraGroups = ["networkmanager" "wheel" "syncthing"];
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  programs.fish.enable = true;

  programs.nix-ld.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Editors/IDEs
    vim
    helix
    obsidian
    jetbrains.rust-rover

    # Version Control
    git
    delta

    # Rust Development
    rustc
    rust-analyzer
    rustfmt
    cargo
    clippy
    diesel-cli
    koto
    koto-ls

    # C/C++ Development
    clang
    protobuf

    # Web Development
    wasm-bindgen-cli
    nodejs
    pnpm
    nodePackages.live-server

    # System/Utilities
    wayland
    wayland-protocols
    libxkbcommon
    alejandra
    neofetch
    alacritty
    kitty
    fish
    gnome-tweaks
    tmux
    just
    sqlite
    pkg-config
    ranger
    zellij
    yazi
    appimage-run
    home-manager
    mullvad-vpn
    xsel

    # Multimedia
    mpv

    # Communication
    discord
    signal-desktop

    # Security
    keepassxc

    # Browsers
    chromium

    # Fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          foam.foam-vscode
          bierner.emojisense
          ms-python.python
          tamasfe.even-better-toml
          zxh404.vscode-proto3
          bradlc.vscode-tailwindcss
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "doki-theme";
            publisher = "unthrottled";
            version = "88.1.15";
            sha256 = "ys3D84zg7mGGTG5Ey65gqgujbUJBsg27MC3qUnbluoM=";
          }
        ];
    })

    gnomeExtensions.unite
  ];

  # programs.git = {
  #   enable = true;
  # };

  programs.git = {
    enable = true;
    config = {
      init = {
        defautBranch = "macho";
      };
      alias = {
        a = "add";
        b = "branch";
        c = "commit";
        cfg = "config";
        chp = "cherry-pick";
        co = "checkout";
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
        sw = "switch";
      };
    };
  };
  # programs.fish.shellAliases = {
  #   l = "ls -alh";
  #   ll = "ls -l";
  #   ls = "ls --color=tty";
  #   kubectl = "sudo k3s kubectl";
  #   sudo = "sudo ";
  #   prettier = "npx prettier --write";
  #   g = "git";
  #   cg = "cargo";
  #   j = "just";
  # };

  services.logind.lidSwitchExternalPower = "ignore";

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

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  system.autoUpgrade = {
    enable = true;
    randomizedDelaySec = "30min"; # Adds a random delay to prevent simultaneous updates
    dates = "daily"; # or "weekly", "monthly", etc.
    flags = ["--impure" "--flake" "/etc/nixos"];
    allowReboot = true; # Allow the system to reboot if necessary
    # email = "your-email@example.com"; # Uncomment to receive email notifications
    # emailOnFailure = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "24.11";
}
