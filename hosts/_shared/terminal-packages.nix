{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra # formatter for .nix files
    btop # sysmon
    busybox # linux tools
    delta # cli diff viewer, git diff uses this
    devenv # nix based dev envs
    fish # shell
    git # holy grail of software
    home-manager # nixos user env manager
    htop # process monitor
    nvchad # neovim distro
    uutils-coreutils-noprefix # use uutils by default
    vim # fallback vim
    yazi # terminal file manager
    zellij # termux alternative
  ];
}
