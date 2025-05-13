mod: {
  "${mod}+t" = "exec GLFW_IM_MODULE=ibus kitty";
  "${mod}+b" = "exec chromium --enable-blink-features=MiddleClickAutoscroll";
  "${mod}+Return" = "exec kitty";
  "${mod}+Shift+Return" = "exec kitty yazi";

  "${mod}+Shift+q" = "kill";
  "${mod}+Shift+d" = "exec i3-dmenu-desktop";
  "${mod}+d" = "exec dmenu_run";

  # TODO "${mod}+l" = "exec xautolock -locknow";

  "${mod}+Left" = "focus left";
  "${mod}+Down" = "focus down";
  "${mod}+Up" = "focus up";
  "${mod}+Right" = "focus right";
  "${mod}+Shift+f" = "[urgent=latest] focus";

  "${mod}+Shift+Left" = "move left";
  "${mod}+Shift+Down" = "move down";
  "${mod}+Shift+Up" = "move up";
  "${mod}+Shift+Right" = "move right";

  "${mod}+h" = "split h";
  "${mod}+v" = "split v";
  "${mod}+f" = "fullscreen toggle";

  "${mod}+s" = "layout stacking";
  "${mod}+w" = "layout tabbed";
  "${mod}+e" = "layout toggle split";

  # TODO "floating modifier $mod"

  "${mod}+Shift+space" = "floating toggle";
  "${mod}+space" = "focus mode_toggle";
  # "${mod}+Shift+a" = "mode_toggle";

  "${mod}+a" = "focus parent";
  "${mod}+Shift+a" = "focus child";

  "${mod}+Shift+c" = "reload";
  "${mod}+Shift+r" = "restart";

  "Print" = "exec flameshot launcher";

  "${mod}+p" = "exec sh -c '/home/chuu/git/nixos/PATH/c-display-first'";
  "${mod}+Control+p" = "exec sh -c '/home/chuu/git/nixos/PATH/c-display-mirror'";
  "${mod}+Shift+p" = "exec sh -c '/home/chuu/git/nixos/PATH/c-display-extend'";
  "${mod}+Shift+Control+p" = "exec sh -c '/home/chuu/git/nixos/PATH/c-display-second'";

  "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
  "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
  "Shift+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
  "Shift+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
  "XF86AudioMute" = "exec pactl set-sink-volume @DEFAULT_SINK@ 0%";
  "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

  "XF86AudioPause" = "exec playerctl play-pause";

  # TODO AudioPlay, etc.

  "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
  "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

  "XF86Launch1" = "exec gsudo systemctl suspend-then-hibernate"; # ROG
  "Mod1+XF86Launch1" = "exec gsudo systemctl hibernate"; # Alt + ROG
  "Shift+XF86Launch1" = "exec gsudo systemctl poweroff"; # Shift + ROG
  "Control+XF86Launch1" = "exec gsudo systemctl reboot"; # Control + ROG

  "XF86KbdBrightnessUp" = "exec asusctl -n";
  "XF86KbdBrightnessDown" = "exec asusctl -p";

  # asus rog fan curve profiles
  "XF86Launch4" = "exec sh -c 'asusctl profile -n && notify-send \"$(asusctl profile -p)\"'";

  "${mod}+1" = "workspace 1";
  "${mod}+2" = "workspace 2";
  "${mod}+3" = "workspace 3";
  "${mod}+4" = "workspace 4";
  "${mod}+5" = "workspace 5";
  "${mod}+6" = "workspace 6";
  "${mod}+7" = "workspace 7";
  "${mod}+8" = "workspace 8";
  "${mod}+9" = "workspace 9";
  "${mod}+0" = "workspace 10";
  "${mod}+Shift+1" = "move container to workspace 1";
  "${mod}+Shift+2" = "move container to workspace 2";
  "${mod}+Shift+3" = "move container to workspace 3";
  "${mod}+Shift+4" = "move container to workspace 4";
  "${mod}+Shift+5" = "move container to workspace 5";
  "${mod}+Shift+6" = "move container to workspace 6";
  "${mod}+Shift+7" = "move container to workspace 7";
  "${mod}+Shift+8" = "move container to workspace 8";
  "${mod}+Shift+9" = "move container to workspace 9";
  "${mod}+Shift+0" = "move container to workspace 10";

  # TODO
  # - [ ] modes
  # - [ ] bar
  # - [ ] initialization
}
