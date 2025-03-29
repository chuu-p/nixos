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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
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
    defaultEditor = true;

    settings = {
      theme = "term16_transparent";
      editor = {
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
          after-delay.timeout = 3000;
        };
        line-number = "relative";
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        cursorline = true;
        bufferline = "always";
        color-modes = true;
        soft-wrap = {
          enable = true;
          max-wrap = 25;
          wrap-indicator = "";
        };
      };
      # editor.cursor-shape = {
      #   normal = "block";
      #   insert = "bar";
      #   select = "underline";
      # };
    };
    # languages.language = [{
    #   name = "nix";
    #   auto-format = true;
    #   formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    # }];
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
