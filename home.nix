{
  config,
  pkgs,
  ...
}: {
  home.username = "chuu"; # Replace with your username
  home.homeDirectory = "/home/chuu"; # Replace with your home directory
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Example: Install a package
  home.packages = with pkgs; [
    neovim
    git
    # Add more packages here
  ];

  # Example: Configure git
  programs.git = {
    enable = true;
    userName = "chuu-p";
    userEmail = "chuu801@pm.me";
  };
}
