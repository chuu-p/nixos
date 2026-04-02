{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra # formatter for .nix files
    borgbackup # backups
    btop # sysmon
    busybox # linux tools
    cryptsetup # linux cryptography tools
    delta # cli diff viewer, git diff uses this
    devenv # nix based dev envs
    fastfetch # show distro
    fish # shell
    gemini-cli # ai
    git # holy grail of software
    gparted # disk partition editor
    home-manager # nixos user env manager
    htop # process monitor
    keepassxc # password manager
    mscp # multi threaded scp
    ntfs3g # tools for ntfs drives
    nvchad # neovim distro
    opencommit
    openssl # ssl
    p7zip # 7zip
    pkg-config # important for libraries
    progress # progress monitor for mv, dd, scp, etc.
    sshfs # mount via ssh
    trashy # cli trash
    tty-clock # terminal clock
    unzip # unzip
    usbutils # lsusb and other tools
    uutils-coreutils-noprefix # use uutils by default
    vim # fallback vim
    yazi # terminal file manager
    zellij # termux alternative
  ];
}
