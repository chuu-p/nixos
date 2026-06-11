{
  pkgs,
  lib,
  inputs,
  ...
}: let
  fishBin = lib.getExe pkgs.fish;

  entryShell = pkgs.writeShellScriptBin "op9pro-shell" ''
    . /etc/profile
    exec ${fishBin} "$@"
  '';
in {
  imports = [
    ./sshd.nix
  ];

  environment.packages = with pkgs;
    [
      busybox # linux tools
      fastfetch # show distro
      fish # shell
      git # holy grail of software
      htop # process monitor
      sysbench # benchmark
      tty-clock # terminal clock
      vim # fallback vim
      yazi # terminal file manager
      zellij # termux alternative

      # LSP servers for nvchad
      nodePackages.bash-language-server
      dockerfile-language-server
      emmet-language-server
      nodePackages.vscode-langservers-extracted
      nixd
      nodePackages.prettier
      nixfmt
      shfmt
      typescript-language-server
    ]
    ++ [
      inputs.nix4nvchad.packages.${pkgs.system}.nvchad
    ];

  environment.etcBackupExtension = ".bak";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.sshd = {
    enable = true;
    ports = [8022];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQHb+VwHnS97Wmu4xpUDlLhzB+Ip11BINatUivsr6+a"
    ];
  };

  android-integration.termux-setup-storage.enable = true;
  android-integration.am.enable = true;

  user.shell = "${entryShell}/bin/op9pro-shell";

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "24.05";
}
