{pkgs, ...}: {
  wayland.windowManager.hyprland = let
    configScreens = pkgs.writeShellScript "screens.sh" ''
      output=$(hyprctl monitors -j)
      if echo "$output" | grep "HDMI-A-1"; then
          max_size=$(echo "$output" | jq '.[] | select(.name == "HDMI-A-1") | .width, .height' | head -n 1 | awk '{printf "%dx%d", $1, $2}')
          max_refresh=$(echo "$output" | jq '.[] | select(.name == "HDMI-A-1") | .refreshRate' | head -n 1)
          hyprctl --batch "keyword monitor eDP-1, 1920x1200@60, 0x0, 1; keyword monitor HDMI-A-1, ''${max_size}@''${max_refresh}, -200x-1440, 1"
      else
          hyprctl keyword monitor eDP-1, 2560x1600@60, 0x0, 1
      fi
    '';
  in {
    enable = true;
    systemd.enable = true;
    settings = {
      exec-once = [configScreens];
      monitor = ",preferred,auto,auto";

      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct" # change to qt6ct if you have that
      ];

      "$powermenu" = "${./dotfiles/powermenu.sh}";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "${pkgs.rofi}/bin/rofi -show drun";

      input = {
        kb_layout = "us";
        kb_variant = "intl";
        follow_mouse = "1";

        touchpad = {
          natural_scroll = "no";
        };

        accel_profile = "flat";
        sensitivity = "0";
      };

      general = {
        gaps_in = "5";
        gaps_out = "20";
        border_size = "2";
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = "false";
      };

      decoration = {
        rounding = "10";

        blur = {
          enabled = "true";
          size = "3";
          passes = "1";
        };

        drop_shadow = "yes";
        shadow_range = "4";
        shadow_render_power = "3";
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_is_master = "true";
      };

      gestures = {
        workspace_swipe = "off";
      };

      misc = {
        force_default_wallpaper = "-1";
      };

      windowrulev2 = [
        # Make pavucontrol float
        "float,class:^(pavucontrol)$"
      ];

      "$mainMod" = "SUPER";

      bind = let
        generateBindings = keyBind: workspacePrefix: i: "${keyBind}, ${toString i}, ${workspacePrefix}, ${toString i}";
      in
        [
          "$mainMod, Q, exec, $terminal"
          "$mainMod, C, killactive"
          "$mainMod, M, exit"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating"
          "$mainMod, R, exec, $menu"
          "$mainMod, L, exec, $powermenu"
          "$mainMod, P, pseudo"
          "$mainMod, J, togglesplit"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Screenshot
          ", Print, exec, grim -g \"$(slurp -d)\" - | wl-copy"

          # Scroll through worskpaces
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Move workspace to another screen
          "$mainMod CTRL, left, movecurrentworkspacetomonitor, l"
          "$mainMod CTRL, right, movecurrentworkspacetomonitor, r"
          "$mainMod CTRL, up, movecurrentworkspacetomonitor, u"
          "$mainMod CTRL, down, movecurrentworkspacetomonitor, d"
        ]
        ++ map
        (i: generateBindings "$mainMod" "workspace" i)
        (pkgs.lib.range 1 9)
        ++ map
        (i: generateBindings "$mainMod SHIFT" "movetoworkspace" i)
        (pkgs.lib.range 1 9);

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindle = [
        ",XF86MonBrightnessUp,   exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set  5%-"
        ",XF86KbdBrightnessUp,   exec, ${pkgs.brightnessctl}/bin/brightnessctl -d asus::kbd_backlight set +1"
        ",XF86KbdBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -d asus::kbd_backlight set  1-"
      ];

      bindl = [
        ",XF86AudioPlay,    exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioStop,    exec, ${pkgs.playerctl}/bin/playerctl pause"
        ",XF86AudioPause,   exec, ${pkgs.playerctl}/bin/playerctl pause"
        ",XF86AudioPrev,    exec, ${pkgs.playerctl}/bin/playerctl previous"
        ",XF86AudioNext,    exec, ${pkgs.playerctl}/bin/playerctl next"
      ];
    };
  };
}
