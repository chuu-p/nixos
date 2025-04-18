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
    extraConfig = builtins.readFile ./themes/ene.conf;
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "ene";
      themes.ene = {
        fg = "#e5e1cf";
        bg = "#0e1419";
        black = "#000000";
        red = "#ff3333";
        green = "#b8cc52";
        yellow = "#e6c446";
        blue = "#36a3d9";
        magenta = "#f07078";
        cyan = "#95e5cb";
        white = "#ffffff";
        orange = "#f19618"; # Using cursor color as there's no dedicated orange in ene.conf
        light_black = "#323232";
        light_red = "#ff6565";
        light_green = "#e9fe83";
        light_yellow = "#fff778";
        light_blue = "#68d4ff";
        light_magenta = "#ffa3aa";
        light_cyan = "#c7fffc";
        light_white = "#ffffff";
      };
      pane_frames = false;
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      # TODO
      startup = [
        {command = "exec discord --start-minimized";}
        {command = "exec keepassxc";}
        {command = "exec flameshot";}
        {command = "exec mullvad-gui";}
      ];

      bars = [
        {
          position = "top";
          statusCommand = "i3status -c ~/git/nixos/i3status.conf";
          # trayOutput = "DP-2"; # Make sure this matches your desired output
          # font = "pango:Cousine 11"; # Ensure this font is availabl
          fonts = {
            names = ["Space Mono"];
            style = "Regular";
            size = 10.0;
          };
        }
      ];

      # FIXME
      # settings = {
      #   # focusFollowsMouse = false;
      #   defaultBorder = "normal 2";
      #   defaultFloatingBorder = "normal 2";
      #   hideEdgeBorders = "both";
      #   workspaceLayout = "tabbed";
      # };
      # TODO
      # - [ ] modes
      # - [ ] bar
      # - [ ] initialization
      # - [ ] pavucontrol always floating
      # - [ ] default app -> pdf chromium
      # - [ ] default app -> feh image viewer
      # - [ ] lol cursor set
      keybindings = import ./i3-keybindings.nix "Mod4";
      # modes = import ./i3-modes.nix "Mod4";

      # FIXME this does not work
      # forWindow = [
      #   {
      #     title = "^Volume Control$";
      #     floating = true;
      #   }
      # ];
    };
  };

  programs.yazi = {
    enable = true;
    theme = builtins.fromTOML (builtins.readFile ./themes/yazi-catppuccin-mocha.toml);
  };

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

  # programs.dconf.enable = true;

  # gtk = {
  #   enable = true;
  #   theme.name = "Adwaita-dark"; # Or any dark theme you prefer
  #   theme.package = pkgs.gnome-themes-extra;
  # };
}
