{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  environment.systemPackages = with pkgs;
  with unstable; [
    alacritty
    alejandra
    android-studio
    android-tools
    anki
    # appimage-run
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
    conda
    cryptsetup
    delta
    devenv
    diesel-cli
    discord
    # evil-helix
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
    just
    kdePackages.kcalc
    keepassxc
    kitty
    koto
    koto-ls
    libnotify
    libreoffice
    libxkbcommon
    lldb
    mask
    mcomix
    meld
    # mkchromecast
    mkvtoolnix-cli
    monitor
    mprocs
    mpv
    mscp
    nautilus
    neofetch
    nodejs
    nodePackages.live-server
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
    pulseaudio
    python312Packages.conda
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
    toot
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
    xdragon
    xorg.xev
    xautolock
    xsel
    yad
    yazi
    yt-dlp
    zellij
    zoxide
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          vadimcn.vscode-lldb
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          foam.foam-vscode
          bierner.emojisense
          ms-python.python
          tamasfe.even-better-toml
          zxh404.vscode-proto3
          bradlc.vscode-tailwindcss
          tomoki1207.pdf
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "doki-theme";
            publisher = "unthrottled";
            version = "88.1.15";
            sha256 = "ys3D84zg7mGGTG5Ey65gqgujbUJBsg27MC3qUnbluoM=";
          }
          {
            name = "geminicodeassist";
            publisher = "Google";
            version = "2.43.0";
            sha256 = "jenr96MLxZE352f0WyUsFkRajP7L/4893RTtuKirEvs=";
          }
        ];
    })
    gnomeExtensions.unite
  ];
}
