mod: {
  "workspace" = {
    "Left" = "workspace prev";
    "Right" = "workspace next";

    "Shift+Left" = "move container to workspace prev, workspace prev";
    "Shift+Right" = "move container to workspace next, workspace next";

    "Mod1+Left" = "move workspace to output left";
    "Mod1+Right" = "move workspace to output right";

    "Escape" = "mode default";
    "${mod}+Shift+w" = "mode default";
  };
  "resize" = {
    "Mod1+Left" = "resize shrink width 10 px or 5 ppt";
    "Mod1+Down" = "resize grow height 10 px or 5 ppt";
    "Mod1+Up" = "resize shrink height 10 px or 5 ppt";
    "Mod1+Right" = "resize grow width 10 px or 5 ppt";

    "Left" = "resize shrink width 100 px or 10 ppt";
    "Down" = "resize grow height 100 px or 10 ppt";
    "Up" = "resize shrink height 100 px or 10 ppt";
    "Right" = "resize grow width 100 px or 10 ppt";

    "Shift+Left" = "resize shrink width 250 px or 20 ppt";
    "Shift+Down" = "resize grow height 250 px or 20 ppt";
    "Shift+Up" = "resize shrink height 250 px or 20 ppt";
    "Shift+Right" = "resize grow width 250 px or 20 ppt";

    "c" = "move position center";

    "m" = "mode move";
    "Return" = "mode default";
    "Escape" = "mode default";
    "${mod}+r" = "mode default";
  };
  "move" = {
    "Mod1+Left" = "move left 10";
    "Mod1+Down" = "move down 10";
    "Mod1+Up" = "move up 10";
    "Mod1+Right" = "move right 10";

    "Left" = "move left 100";
    "Down" = "move down 100";
    "Up" = "move up 100";
    "Right" = "move right 100";

    "Shift+Left" = "move left 250";
    "Shift+Down" = "move down 250";
    "Shift+Up" = "move up 250";
    "Shift+Right" = "move right 250";

    "c" = "move position center";

    "r" = "mode resize";
    "Return" = "mode default";
    "Escape" = "mode default";
    "${mod}+m" = "mode default";
  };
  "nokeys" = {
    "${mod}+Escape" = "mode default";
  };
  "mouse" = {
    "Mod1+Left" = "exec --no-startup-id xdotool mousemove_relative -- -16 0";
    "Mod1+Down" = "exec --no-startup-id xdotool mousemove_relative -- 0 16";
    "Mod1+Up" = "exec --no-startup-id xdotool mousemove_relative -- 0 -16";
    "Mod1+Right" = "exec --no-startup-id xdotool mousemove_relative -- 16 0";

    "Left" = "exec --no-startup-id xdotool mousemove_relative -- -128 0";
    "Down" = "exec --no-startup-id xdotool mousemove_relative -- 0 128";
    "Up" = "exec --no-startup-id xdotool mousemove_relative -- 0 -128";
    "Right" = "exec --no-startup-id xdotool mousemove_relative -- 128 0";

    "Shift+Left" = "exec --no-startup-id xdotool mousemove_relative -- -256 0";
    "Shift+Down" = "exec --no-startup-id xdotool mousemove_relative -- 0 256";
    "Shift+Up" = "exec --no-startup-id xdotool mousemove_relative -- 0 -256";
    "Shift+Right" = "exec --no-startup-id xdotool mousemove_relative -- 256 0";

    "Control+Left" = "exec --no-startup-id xdotool mousemove_relative -- -512 0";
    "Control+Down" = "exec --no-startup-id xdotool mousemove_relative -- 0 512";
    "Control+Up" = "exec --no-startup-id xdotool mousemove_relative -- 0 -512";
    "Control+Right" = "exec --no-startup-id xdotool mousemove_relative -- 512 0";

    "Return" = "exec --no-startup-id xdotool click 1";
    "Mod1+Return" = "exec --no-startup-id xdotool click 2";
    "Shift+Return" = "exec --no-startup-id xdotool click 3";

    "q" = "exec --no-startup-id xdotool mousedown 1";
    "e" = "exec --no-startup-id xdotool mouseup 1";

    "${mod}+q" = "mode default";
    "Escape" = "mode default";
  };
}
