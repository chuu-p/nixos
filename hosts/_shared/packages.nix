{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # nvtopPackages.full # gpu monitor
    # rustdesk # rdp
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
    fractal # matrix chat client
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
    i3status # status bar
    i3status-rust # status bar
    inkscape # vector image manipulation
    insomnia # rest client
    just # command runner
    keepassxc # password manager
    kdePackages.kcalc # calculator
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
    obsidian # note-taking
    opencommit # generate commit messages with ai
    openrazer-daemon # for razer hardware
    openssl # ssl
    p7zip # 7zip
    pavucontrol # volume control
    pkg-config # important for libraries
    playerctl # control media from command line
    presenterm # cli presentations
    prismlauncher # minecraft launcher
    progress # progress monitor for mv, dd, scp, etc.
    protonmail-bridge-gui # emails
    pulseaudio # audio system
    shotcut # video editor
    signal-desktop # communication
    sshfs # mount via ssh
    thunderbird # emails
    tigervnc # vnc
    tokei # count lines of code
    trashy # cli trash
    tty-clock # terminal clock
    typst # typst compiler
    typstyle # typst formatter
    unzip # unzip
    usbutils # lsusb and other tools
    uutils-coreutils-noprefix # use uutils by default
    vdhcoapp # videodownloadhelper companion application
    vial # keyboard config
    vim # fallback vim
    wlr-randr # xrandr for wayland
    yazi # terminal file manager
    yt-dlp # media download tool
    zed-editor # rust based ide
    zellij # termux alternative
    zmkBATx
    unstable.zmk-studio # split keyboard software
  ];
}
