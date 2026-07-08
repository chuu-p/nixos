{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # rustdesk # rdp
    android-studio # dev
    anki-bin # flashcard learning
    brightnessctl # monitor brightness
    calibre # epub viewer
    discord # communication
    dragon-drop # drag and drop files from the terminal
    evince # pdf viewer
    feh # image viewer
    firefox # browser
    flameshot # screenshots
    fontconfig # important!
    # element-desktop # matrix chat client (electron-based, faster to install)
    google-chrome # for drm media
    i3status # status bar
    i3status-rust # status bar
    kdePackages.kcalc # calculator
    alacritty # terminal emulator
    libnotify # notifications
    # logseq # obsidian open source
    mcomix # manga viewer
    meld # diff viewer
    mixxx # dj software
    mpv # video player
    nautilus # graphical file explorer
    nautilus-open-any-terminal # open in terminal option for nautilus
    obsidian # note-taking
    openrazer-daemon # for razer hardware
    pavucontrol # volume control
    playerctl # control media from command line
    prismlauncher # minecraft launcher
    protonmail-bridge-gui # emails
    pulseaudio # audio system
    signal-desktop # communication
    thunderbird-bin # emails (pre-built, avoids compiling from source)
    tigervnc # vnc
    unstable.zmk-studio # split keyboard software
    # vdhcoapp removed - no longer needed for VDH >= 10
    vial # keyboard config
    wiremix # pipewire tui
    wlr-randr # xrandr for wayland
    wmenu # launcher
    yt-dlp # media download tool
    zed-editor # rust based ide
    zmkbatx
  ];
}
