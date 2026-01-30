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
    fish # shell
      gemini-cli # ai
    git # holy grail of software
    home-manager # nixos user env manager
    htop # process monitor
      kitty # the best terminal emulator imo :3
    nvchad # neovim distro
      opencommit # generate commit messages with ai
      playerctl # control media from command line
      presenterm # cli presentations
    sshfs # mount via ssh
    tokei # count lines of code
    uutils-coreutils-noprefix # use uutils by default
    vim # fallback vim
    yazi # terminal file manager
    zellij # termux alternative
  ];
}
