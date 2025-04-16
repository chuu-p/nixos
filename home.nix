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
    dconf
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "orchis-theme";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };
  home.sessionPath = ["${config.home.homeDirectory}/git/nixos/PATH"];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    functions = {
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
    ];
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
    # extraConfig = builtins.readFile ./themes/miku.conf;
    extraConfig = builtins.readFile ./themes/ene.conf;
  };

  # home.file.".config/zellij/themes/miku.kdl".source = ./themes/miku.kdl;

  programs.zellij = {
    enable = true;
    settings = {
      theme = "ayu_dark";
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      # TODO
      # startup = [
      #   {
      #     command = "systemctl --user restart polybar";
      #     always = true;
      #     notification = false;
      #   }
      # ];
      keybindings = import ./i3-keybindings.nix "Mod4";
    };
  };

  # programs.yazi.enable = true;

  # programs.yazi.flavors = {
  #   catppuccin-mocha = pkgs.fetchFromGitHub {
  #     owner = "yazi-rs";
  #     repo = "flavors";
  #     rev = "main";
  #     sha256 = "nhIhCMBqr4VSzesplQRF6Ik55b3Ljae0dN+TYbzQb5s=";
  #   };
  # };

  # programs.yazi.settings = {
  #   theme = "catppuccin-mocha";
  # };

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
      theme = "term16_dark";
      # globally enable inlay-hints for all languages
      editor.lsp.display-messages = true;
      editor.lsp.display-inlay-hints = true;
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
    ];
  };

  services.dunst.enable = true;

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

  # gtk = {
  #   enable = true;
  #   theme.name = "Adwaita-dark"; # Or any dark theme you prefer
  #   theme.package = pkgs.gnome-themes-extra;
  # };
}
