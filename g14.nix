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
    packages = with pkgs; [
    ];
  };

  programs.nix-ld.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    rustc
    rust-analyzer
    rustfmt
    cargo
    clang
    wasm-bindgen-cli
    wayland
    wayland-protocols
    libxkbcommon
    alejandra
    keepassxc
    chromium
    neofetch
    mpv
    discord
    obsidian
    alacritty
    fish
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    gnome-tweaks
    signal-desktop
    tmux
    pnpm
    just
    nodejs
    protobuf
    sqlite
    pkg-config
    diesel-cli
    helix
    jetbrains.rust-rover
    ranger
    appimage-run
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

    gnomeExtensions.tiling-shell
    gnomeExtensions.unite
  ];

  programs.git = {
    enable = true;
    # extraConfig = {
    #   alias = {
    #     st = "status";
    #     co = "checkout";
    #     br = "branch";
    #     ci = "commit";
    #     lol = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    #     last = "log -1 HEAD --stat";
    #   };
    # };
  };

  programs.bash.shellAliases = {
    l = "ls -alh";
    ll = "ls -l";
    ls = "ls --color=tty";
    kubectl = "sudo k3s kubectl";
    g = "git";
  };

  services.logind.lidSwitchExternalPower = "ignore";

  # FIXME
  # systemd.services.syncthing-permissions = {
  #   description = "Set permissions for /var/lib/syncthing";
  #   # before = ["syncthing.service"];
  #   after = ["syncthing.service"];
  #   # after = ["local-fs.target"];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "/run/wrappers/bin/sudo chmod g+rwx /var/lib/syncthing";
  #     RemainAfterExit = true;
  #   };
  #   wantedBy = ["multi-user.target"]; # Ensure it runs during boot
  # };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

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
