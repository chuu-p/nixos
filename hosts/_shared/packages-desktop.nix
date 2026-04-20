{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
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
    fractal # matrix chat client
    google-chrome # for drm media
    i3status # status bar
    i3status-rust # status bar
    kdePackages.kcalc # calculator
    kitty # the best terminal emulator imo :3
    libnotify # notifications
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
    # rustdesk # rdp
    signal-desktop # communication
    thunderbird # emails
    tigervnc # vnc
    unstable.zmk-studio # split keyboard software
    vdhcoapp # videodownloadhelper companion application
    vial # keyboard config
    wiremix # pipewire tui
    wlr-randr # xrandr for wayland
    wmenu # launcher
    yt-dlp # media download tool
    zed-editor # rust based ide
    zmkBATx
  ];
}
