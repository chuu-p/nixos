{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  environment.systemPackages = with pkgs;
  with unstable; [
    alejandra # formatter for .nix files
    android-studio # dev
    android-tools # dev
    ardour # linux daw
    blender # 3d modeling
    borgbackup # backups
    brightnessctl # monitor brightness
    btop # sysmon
    busybox # linux tools
    calibre # epub viewer
    caligula # burn iso to usb
    cargo # dev rust, not in dev flake for convinience
    cryptsetup # linux cryptography tools
    delta # cli diff viewer, git diff uses this
    devenv # nix based dev envs
    discord # communication
    dragon-drop # drag and drop files from the terminal
    evince # pdf viewer
    feh # image viewer
    ffmpeg # multimedia toolkit
    firefox # browser
    fish # shell
    flameshot # screenshots
    font-awesome # fonts
    fontconfig # fonts
    freetype # fonts
    gemini-cli # ai
    gh # github cli
    ghostscript # for imagemagick pdf processing
    gimp # image manipulation
    git # holy grail of software
    google-chrome # for drm media
    gparted # disk partition editor
    home-manager # nixos user env manager
    htop # process monitor
    inkscape # vector image manipulation
    just # command runner
    kdePackages.kcalc # calculator
    keepassxc # password manager
    kitty # the best terminal emulator imo :3
    libnotify # notifications
    libreoffice # nice to have office suite
    lldb # debugger
    mcomix # manga viewer
    meld # diff viewer
    mixxx # dj software
    mpv # video player
    mscp # multi threaded scp
    nautilus # graphical file explorer
    nautilus-open-any-terminal # open in terminal option for nautilus
    neofetch # show distro
    nodejs # js runtime
    ntfs3g # tools for ntfs drives
    nvchad # neovim distro
    nvtopPackages.full # gpu monitor
    obsidian # note-taking
    opencommit # generate commit messages with ai
    openrazer-daemon # for razer hardware
    openssl # ssl
    pavucontrol # volume control
    pkg-config # important for libraries
    playerctl # control media from command line
    presenterm # cli presentations
    prismlauncher # minecraft launcher
    progress # progress monitor for mv, dd, scp, etc.
    pulseaudio # audio system
    # rustdesk # rdp
    shotcut # video editor
    signal-desktop # communication
    sshfs # mount via ssh
    tigervnc # vnc
    tokei # count lines of code
    trashy # cli trash
    tty-clock # terminal clock
    typst # typst compiler
    typstyle # typst formatter
    unzip # unzip
    p7zip # 7zip
    usbutils # lsusb and other tools
    uutils-coreutils-noprefix # use uutils by default
    vdhcoapp # videodownloadhelper companion application
    vial # keyboard config
    vim # fallback vim
    xidlehook # TODO
    xorg.xev # x event tester
    xsel # clipboard tool
    yazi # terminal file manager
    yt-dlp # media download tool
    zed-editor # rust based ide
    zellij # termux alternative
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
  ];
}
