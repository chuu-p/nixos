{
  config,
  pkgs,
  ...
}: let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
in {
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.chuu = {pkgs, ...}: {
    home.packages = with pkgs; [];
    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = with pkgs; [gnome.gnome-settings-daemon mutter];
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

  hardware.pulseaudio.enable = false;
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

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
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
    gnome.gnome-tweaks
    signal-desktop
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        foam.foam-vscode
        # unthrottled.doki-theme

        ms-python.python
      ];
    })

    gnomeExtensions.tiling-shell
    gnomeExtensions.unite
  ];

  # TODO dconf
  # (no title bars) https://askubuntu.com/a/1465451

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

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "-L" # print build logs
  #   ];
  #   dates = "09:00";
  #   randomizedDelaySec = "45min";
  # };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "24.11";
}
