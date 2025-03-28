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

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.git = {
    enable = true;
    userName = "chuu-p";
    userEmail = "chuu801@pm.me";
    extraConfig = {
      alias = {
        a = "add";
        b = "branch";
        c = "commit";
        cfg = "config";
        chp = "cherry-pick";
        co = "checkout";
        d = "diff";
        f = "fetch";
        graph = "log --graph";
        i = "init --template=";
        l = "log";
        last = "log -1";
        m = "merge";
        pl = "pull";
        ps = "push";
        r = "reset";
        rb = "rebase";
        re = "remote";
        rm = "remote";
        s = "status";
        wd = "diff --word-diff=color";
        sw = "switch";
      };
    };
  };

  # programs.dconf.settings = {
  #   "org/gnome/settings-daemon/plugins/media-keys" = {
  #     custom-keybindings = [
  #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  #     ];
  #   };
  # };

  # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #   binding = "<Super>t";
  #   command = "hyper";
  #   name = "open-terminal";
  # };

  # programs.dconf.enable = true;
}
