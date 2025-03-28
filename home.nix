{
  config,
  pkgs,
  ...
}: {
  home.username = "chuu"; # Replace with your username
  home.homeDirectory = "/home/chuu"; # Replace with your home directory
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    kitty
  ];

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.fish.enable = true;

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

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty/miku_theme.conf;
  };

  # xdg.desktopEntries."kitty" = {
  #   name = "Kitty Terminal";
  #   description = "Fast, feature-rich, GPU based terminal emulator";
  #   exec = "${pkgs.kitty}/bin/kitty";
  #   icon = "utilities-terminal"; # You can change this icon
  #   terminal = false;
  #   categories = ["TerminalEmulator"];
  # };

  # dconf.settings = {
  #   "/org/gnome/desktop/wm/keybindings/custom-list" = [
  #     "<Super>t ['${pkgs.kitty}/bin/kitty']"
  #   ];
  # };

  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";
      # editor.cursor-shape = {
      #   normal = "block";
      #   insert = "bar";
      #   select = "underline";
      # };
    };

    # TODO
    # https://yazi-rs.github.io/docs/tips/#helix-with-zellij
    # keys.normal = {
    #   ctrl.y = ":sh zellij run -n Yazi -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh open";
    # };

    # ~/.config/helix/config.toml
    # [keys.normal]
    # C-y = ":sh zellij run -n Yazi -c -f -x 10% -y 10% --width 80% --height 80% -- bash ~/.config/helix/yazi-picker.sh open"

    # languages.language = [{
    #   name = "nix";
    #   auto-format = true;
    #   formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    # }];
    # themes = {
    #   autumn_night_transparent = {
    #     "inherits" = "autumn_night";
    #     "ui.background" = { };
    #   };
    # };
  };

  # TODO
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
