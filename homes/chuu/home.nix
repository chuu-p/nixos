{
  config,
  pkgs,
  inputs,
  ...
}: let
  browser = [
    "firefox.desktop"
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
    "nvim.desktop"
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
  };
in {
  home.username = "chuu"; # Replace with your username
  home.homeDirectory = "/home/chuu"; # Replace with your home directory
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.swaylock.enable = true;
  services.swayidle.enable = true;

  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      # LSP servers
      nodePackages.bash-language-server
      blueprint-compiler
      docker-compose-language-service
      dockerfile-language-server
      emmet-language-server
      vscode-langservers-extracted
      rust-analyzer
      typescript-language-server
      vue-language-server
      vala-language-server
      nixd
      (python3.withPackages (ps:
        with ps; [
          python-lsp-server
          python-lsp-ruff
          flake8
        ]))
      # formatters
      nodePackages.prettier
      nixfmt
      rustfmt
      shfmt
    ];
    hm-activation = true;
    backup = false;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    ATUIN_NOBIND = "true";
    RUST_LOG = "asusctl=error,zbus=error,tracing=error"; # Fix asusctl
  };
  home.sessionPath = ["${config.home.homeDirectory}/git/nixos/PATH"];

  home.shellAliases = {
    l = "ls -alh";
    ll = "ls -l";
    ls = "ls --color=tty";
    kubectl = "sudo k3s kubectl";
    sudo = "sudo ";
    prettier = "npx prettier --write";
    g = "git";
    cg = "cargo";
    j = "just";
    zj = "zellij";
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      function fish_hybrid_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase
      end
      set -g fish_key_bindings fish_hybrid_key_bindings
      fish_user_key_bindings
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

  programs.mpv = {
    enable = true;
    config = {
      gpu-api = "opengl";
    };
  };

  home.file.".config/git/allowed-signers" = {
    text = builtins.readFile ./.config/allowed-signers;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "chuu-p";
        email = "chuu801@pm.me";
        signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
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
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "~/.config/git/allowed-signers";
      };
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ../../aesthetics/ene_gh.conf;
  };

  programs.keepassxc = {
    autostart = true;
    enable = true;
    settings = {
      # For available settings, see https://github.com/keepassxreboot/keepassxc/blob/develop/src/core/Config.cpp
      FdoSecrets.Enabled = true; # Enable Secret Service Integration
    };
  };

  xdg.autostart.enable = true; # Enable creation of XDG autostart entries.

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      input = {
        "type:touchpad" = {
          # Enables or disables tap for specified input device.
          tap = "enabled";
          # disable-while-typing
          dwt = "enabled";
          # Enables or disables natural (inverted) scrolling for the specified input device.
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };

        # Provide all keyboards connected the following configuration
        "type:keyboard" = {
          xkb_layout = "us,us";
          xkb_variant = "altgr-intl,intl";
          xkb_options = "caps:super,grp:win_space_toggle,shift:both_capslock";
        };
      };

      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "1.33";
        };
      };

      # Use kitty as default terminal
      terminal = "kitty";
      modifier = "Mod4";
      startup = [
        {command = "exec discord --start-minimized";}
        {command = "exec keepassxc";}
        {command = "exec flameshot";}
        {command = "exec mullvad-gui";}
        {command = "exec fcitx5";}
        {command = "exec obsidian";}
      ];

      keybindings = import ../_shared/sway/sway-keybindings.nix "Mod4";

      floating = {
        criteria = [
          {
            title = "Volume Control";
          }
        ];
      };

      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status -c ~/git/nixos/homes/_shared/sway/i3status.conf";
          fonts = {
            # names = ["Space Mono"];
            # style = "Regular";
            size = 10.0;
          };
        }
      ];

      window = {
        hideEdgeBorders = "both";
        titlebar = false;
        commands = [
          {
            command = "border pixel 2";
            criteria = {
              class = "InputOutput";
            };
          }
        ];
      };
    };
  };

  # xsession.windowManager.i3 = {
  #   enable = true;
  #   config = {
  #     modifier = "Mod4";
  #     startup = [
  #       {command = "exec discord --start-minimized";}
  #       {command = "exec keepassxc";}
  #       {command = "exec flameshot";}
  #       {command = "exec mullvad-gui";}
  #       {command = "exec fcitx5";}
  #       {command = "exec obsidian";}
  #       {command = "exec_always --no-startup-id xidlehook --not-when-fullscreen --not-when-audio --timer 600 'i3lock -i /home/chuu/git/nixos/wallpapers/cirno_nix.png' '' --detect-sleep";}
  #     ];
  #
  #     floating = {
  #       criteria = [
  #         {
  #           title = "Volume Control";
  #         }
  #       ];
  #     };
  #
  #     bars = [
  #       {
  #         position = "top";
  #         statusCommand = "i3status -c ~/git/nixos/homes/_shared/i3/i3status.conf";
  #         fonts = {
  #           names = ["Space Mono"];
  #           style = "Regular";
  #           size = 13.0;
  #         };
  #       }
  #     ];
  #
  #     keybindings = import ../_shared/i3/i3-keybindings.nix "Mod4";
  #
  #     window = {
  #       hideEdgeBorders = "both";
  #       titlebar = false;
  #       commands = [
  #         {
  #           command = "border pixel 2";
  #           criteria = {
  #             class = "InputOutput";
  #           };
  #         }
  #       ];
  #     };
  #   };
  # };:

  programs.yazi = {
    enable = true;
    initLua = ''
      -- show disk in status bar
      Status:children_add(function()
          local command = "df -kh .|awk '!/^Filesystem/{printf \" %s FREE \", $(NF-2)}'"
          local info = ui.Span(io.popen(command):read('*a')):fg("green")
          return info
      end, 1500, Header.RIGHT)
    '';
  };

  services.dunst.enable = true;

  services.batsignal.enable = true;

  # services.screen-locker = {
  #   enable = true;
  #   lockCmd = "i3lock -i /home/chuu/git/nixos/wallpapers/cirno_nix.png";
  # };

  # https://github.com/Nimor111/home.nix/blob/master/home.nix
  # https://github.com/jonringer/nixpkgs-config/blob/master/home.nix
  home.file.".config/redshift/hooks/brightness.sh" = {
    text = builtins.readFile ./.config/brightness.sh;
    executable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = associations;
    associations.added = associations;
  };
}
