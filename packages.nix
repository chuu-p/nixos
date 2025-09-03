{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  environment.systemPackages = with pkgs;
  with unstable; [
    # anki
    # appimage-run
    # conda
    # evil-helix
    # mkchromecast
    # python312Packages.conda
    # toot
    alacritty
    alejandra
    android-studio
    android-tools
    bacon
    bat
    black
    blender
    blockbench
    borgbackup
    bottles
    brightnessctl
    bun
    calibre
    cargo
    chromium
    clang
    clippy
    cryptsetup
    delta
    devenv
    diesel-cli
    discord
    evince
    exiftool
    f3d
    feh
    ffmpeg
    figma-linux
    firefox
    firejail
    fish
    flameshot
    font-awesome
    gemini-cli
    gh
    ghostscript
    gimp
    git
    glow
    google-chrome
    gparted
    gum
    helix
    home-manager
    htop
    hyperfine
    inkscape
    jetbrains.rust-rover
    jetbrains-toolbox
    just
    kdePackages.kcalc
    keepassxc
    kitty
    koto
    koto-ls
    krita
    libnotify
    libreoffice
    libxkbcommon
    lldb
    mask
    mcomix
    meld
    mkvtoolnix-cli
    monitor
    mprocs
    mpv
    mscp
    nautilus
    neofetch
    nodePackages.live-server
    nodejs
    nvtopPackages.full
    obsidian
    openrazer-daemon
    openssl
    pandoc
    pavucontrol
    pdftk
    pkg-config
    playerctl
    pnpm
    presenterm
    progress
    protobuf
    polychromatic
    pulseaudio
    python314
    qjackctl
    rio
    rust-analyzer
    rustc
    rustfmt
    signal-desktop
    sqlite
    tinymist
    tokei
    transmission_4-qt
    trashy
    tty-clock
    typst
    typstyle
    unzip
    upscayl
    uutils-coreutils-noprefix
    vdhcoapp
    vim
    wasm-bindgen-cli
    xautolock
    xdragon
    xidlehook
    xorg.xev
    xsel
    yad
    yazi
    yt-dlp
    zellij
    zoxide
    # (vscode-with-extensions.override {
    #   vscode = vscodium;
    #   vscodeExtensions = with vscode-extensions;
    #     [
    #       bierner.emojisense
    #       bradlc.vscode-tailwindcss
    #       foam.foam-vscode
    #       jnoortheen.nix-ide
    #       ms-python.python
    #       rust-lang.rust-analyzer
    #       streetsidesoftware.code-spell-checker
    #       streetsidesoftware.code-spell-checker-german
    #       tamasfe.even-better-toml
    #       tomoki1207.pdf
    #       vadimcn.vscode-lldb
    #       vscodevim.vim
    #       zxh404.vscode-proto3
    #     ]
    #     ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #       # {
    #       #   name = "doki-theme";
    #       #   publisher = "unthrottled";
    #       #   version = "88.1.15";
    #       #   sha256 = "ys3D84zg7mGGTG5Ey65gqgujbUJBsg27MC3qUnbluoM=";
    #       # }
    #       {
    #         name = "geminicodeassist";
    #         publisher = "Google";
    #         version = "2.43.0";
    #         sha256 = "jenr96MLxZE352f0WyUsFkRajP7L/4893RTtuKirEvs=";
    #       }
    #       {
    #         name = "github-vscode-theme";
    #         publisher = "GitHub";
    #         version = "6.3.5";
    #         sha256 = "dOadoYBPcYrpzmqOpJwG+/nPwTfJtlsOFDU3FctdR0o=";
    #       }
    #     ];
    # })
    gnomeExtensions.unite
  ];
}
