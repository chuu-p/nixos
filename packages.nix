{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  environment.systemPackages = with pkgs;
  with unstable; [
    aider-chat
    alacritty
    alejandra
    alsa-lib
    android-studio
    android-tools
    anki
    ardour
    asciinema
    bacon
    bat
    black
    blender
    blockbench
    borgbackup
    bottom
    brightnessctl
    btop
    btop-cuda
    btop-rocm
    bun
    calibre
    caligula
    cargo
    chromium
    clang
    clippy
    colmena
    cryptsetup
    delta
    devenv
    diesel-cli
    discord
    dragon-drop
    evil-helix
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
    fluxcd
    font-awesome
    fontconfig
    freetype
    # gemini-cli
    gh
    ghostscript
    gimp
    git
    glow
    godot
    google-chrome
    gparted
    gtk3-x11
    gtk4
    gum
    harvid
    home-manager
    htop
    hyperfine
    inkscape
    jetbrains-toolbox
    # jetbrains.rust-rover
    just
    k3s
    kdePackages.kcalc
    kdePackages.kdenlive
    keepassxc
    kitty
    krita
    libnotify
    libreoffice
    libuv
    libxkbcommon
    lldb
    mask
    mcomix
    meld
    meowpdf
    mixxx
    mkvtoolnix-cli
    monitor
    mprocs
    mpv
    mscp
    nautilus
    nautilus-open-any-terminal
    neofetch
    nodejs
    nvchad
    nvtopPackages.full
    obsidian
    opencommit
    openrazer-daemon
    openssl
    openutau
    pandoc
    pavucontrol
    pdftk
    pkg-config
    playerctl
    pnpm
    polychromatic
    presenterm
    prismlauncher
    progress
    protobuf
    pulseaudio
    python314
    qjackctl
    reaper
    rio
    rust-analyzer
    rustc
    # rustdesk
    rustfmt
    shotcut
    signal-desktop
    sqlite
    sshfs
    teams-for-linux
    tic-80
    tigervnc
    tinymist
    tokei
    transmission_4-qt
    trashy
    tty-clock
    typst
    typstyle
    unzip
    upscayl
    usbutils
    uutils-coreutils-noprefix
    vdhcoapp
    vial
    vim
    wasm-bindgen-cli
    xautolock
    xidlehook
    xjadeo
    xorg.xev
    xsel
    yad
    yazi
    yt-dlp
    zed-editor
    zellij
    zoxide
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          bierner.emojisense
          bradlc.vscode-tailwindcss
          foam.foam-vscode
          jebbs.plantuml
          jnoortheen.nix-ide
          ms-kubernetes-tools.vscode-kubernetes-tools
          ms-python.python
          rust-lang.rust-analyzer
          streetsidesoftware.code-spell-checker
          streetsidesoftware.code-spell-checker-german
          tamasfe.even-better-toml
          tomoki1207.pdf
          vadimcn.vscode-lldb
          vscodevim.vim
          zxh404.vscode-proto3
          redhat.vscode-yaml
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "geminicodeassist";
            publisher = "Google";
            version = "2.43.0";
            sha256 = "jenr96MLxZE352f0WyUsFkRajP7L/4893RTtuKirEvs=";
          }
          {
            name = "github-vscode-theme";
            publisher = "GitHub";
            version = "6.3.5";
            sha256 = "dOadoYBPcYrpzmqOpJwG+/nPwTfJtlsOFDU3FctdR0o=";
          }
          {
            name = "vscode-gitops-tools";
            publisher = "Weaveworks";
            version = "0.27.0";
            sha256 = "7MCKDnHCot/CL/SqZ2WuTxbqFdF75EC5WC+OxW0dcaE=";
          }
        ];
    })

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
