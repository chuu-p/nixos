{
  config,
  pkgs,
  ...
}: let
  browser = [
    "chromium-browser.desktop"
  ];
  image-viewer = [
    "feh.desktop"
  ];
  media-player = [
    "mpv.desktop"
  ];
  ebook-viewer = [
    "calibre-ebook-viewer.desktop"
  ];
  text-editor = [
    "Helix.desktop"
  ];
  associations = {
    "application/epub+zip" = ebook-viewer;
    "application/json" = text-editor;
    "application/pdf" = ["org.gnome.Evince.desktop"];
    "application/vnd.amazon.ebook" = ebook-viewer;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    # "application/x-ms-dos-executable" = ["wine.desktop"];
    "audio/aac" = media-player;
    "audio/flac" = media-player;
    "audio/mpeg" = media-player;
    "audio/ogg" = media-player;
    "audio/wav" = media-player;
    "audio/webm" = media-player;
    "image/avif" = image-viewer;
    "image/bmp" = image-viewer;
    "image/gif" = image-viewer;
    "image/jpeg" = image-viewer;
    "image/png" = image-viewer;
    "image/tiff" = image-viewer;
    "image/vnd.microsoft.icon" = image-viewer;
    "image/webp" = image-viewer;
    "text/css" = text-editor;
    "text/html" = browser;
    "text/javascript" = text-editor;
    "video/mp4" = media-player;
    "video/mpeg" = media-player;
    "video/ogg" = media-player;
    "video/webm" = media-player;
    "video/x-msvideo" = media-player;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;
    # "text/csv" = ?;
  };
in {
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

  home.file.".config/git/allowed-signers" = {
    text = builtins.readFile ./.config/allowed-signers;
  };

  programs.git = {
    enable = true;
    userName = "chuu-p";
    userEmail = "chuu801@pm.me";
    extraConfig = {
      init = {
        defaultBranch = "macho";
      };
      commit = {
        gpgsign = true;
      };
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
      gpg.format = "ssh";
      user.signingkey = "/home/chuu/.ssh/id_ed25519.pub";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed-signers";
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty-themes/themes/misa.conf;
  };

  programs.rio = {
    enable = true;
    settings = {
      fonts = {
        size = 13;
        family = "Space Mono";
        # regular = {
        #   family = "Space Mono";
        #   style = "Normal";
        #   width = "Normal";
        #   weight = 400;
        # };
        # bold = {
        #   family = "Space Mono";
        #   style = "Normal";
        #   width = "Normal";
        #   weight = 800;
        # };
        # italic = {
        #   family = "Space Mono";
        #   style = "Italic";
        #   width = "Normal";
        #   weight = 400;
        # };
        # bold-italic = {
        #   family = "Space Mono";
        #   style = "Italic";
        #   width = "Normal";
        #   weight = 800;
        # };
        # [fonts.emoji]
        # family = "Noto Color Emoji"
        # [renderer]
        # filters = [
        #   # Loads built-in crt
        #   "NewPixieCrt",
        #   "fubax_vr"
        # ]
      };
      window.background-image = {
        path = "/home/chuu/git/nixos/themes/ene.png";
        opacity = 0.05;
        x = 0;
        y = 0;
        width = 2560;
        height = 1440;
      };
    };
  };

  home.file.".config/rio/themes/dracula.toml" = {
    text = builtins.readFile ./themes/ayu.toml;
  };

  home.file.".config/bato/bato.yaml" = {
    text = builtins.readFile ./.config/bato.yaml;
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "gruvbox-dark";
      themes.gruvbox-dark = {
        fg = "#d5c4a1";
        bg = "#282828";
        black = "#3C3836";
        red = "#CC241D";
        green = "#98971A";
        yellow = "#D79921";
        blue = "#3C8588";
        magenta = "#B16286";
        cyan = "#689D6A";
        white = "#ebdbb2";
        orange = "#D65D0E";
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
        {command = "exec fcitx5";}
        {command = "exec /home/chuu/git/nixos/.config/bato.sh";}
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
            size = 11.0;
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

  # programs.yazi.yaziPlugins = {
  #   enable = true;
  #   plugins = {
  #     bookmarks.enable = true;
  #     git.enable = true;
  #     glow.enable = true;
  #     smart-enter.enable = true;
  #     smart-filter.enable = true;
  #     jump-to-char = {
  #       enable = true;
  #       keys.toggle.on = ["F"];
  #     };
  #     relative-motions = {
  #       enable = true;
  #       show_numbers = "relative_absolute";
  #       show_motion = true;
  #     };
  #   };
  # };

  programs.helix = {
    enable = true;
    settings = {
      theme = "term16_dark";
      # globally enable inlay-hints for all languages
      editor = {
        line-number = "relative";
        soft-wrap.enable = true;
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
      };
      keys.normal = {
        # space.space = "file_picker";
        # "C-y" = ":sh zellij run --floating -n 'yazi picker' -- /home/chuu/git/nixos/helix/open_in_helix_from_yazi.fish";
      };
      keys.insert = {
        j = {k = "normal_mode";};
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
      {
        name = "json5";
        auto-format = true;
        formatter.command = "/run/current-system/sw/bin/npx prettier --write";
      }
      # {
      #   name = "typst";
      #   auto-format = true;
      #   formatter.command = "${lib.getExe pkgs.typstyle} format-all";
      # }
    ];
  };

  services.dunst.enable = true;

  # https://github.com/Nimor111/home.nix/blob/master/home.nix
  # https://github.com/jonringer/nixpkgs-config/blob/master/home.nix
  home.file.".config/redshift/hooks/brightness.sh" = {
    text = builtins.readFile ./.config/brightness.sh;
    executable = true;
  };

  # programs.dconf.enable = true;

  # gtk = {
  #   enable = true;
  #   theme.name = "Adwaita-dark"; # Or any dark theme you prefer
  #   theme.package = pkgs.gnome-themes-extra;
  # };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = associations;
    associations.added = associations;
  };
}
