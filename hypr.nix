{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # --- Monitore ---
      monitor = [
        "eDP-1,1920x1080@60,0x1080,1"
        "desc:Dell Inc. DELL U2414H,1920x1080@60,0x0,1"
        "desc:Lenovo Group Limited D27-45,1920x1080@60,1920x0,1,transform,3"
        ",preferred,auto,1"
      ];

      # --- Autostart ---
      exec-once = [
        "waybar"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "blueman-applet"
        "hypridle"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      # --- Input ---
      input = {
        kb_layout = "us,de";
        kb_variant = "altgr-intl,";
        kb_options = "caps:swapescape,grp:alt_shift_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      # --- Gestures ---
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      # --- Window Rules ---
      windowrule = [
        "float,title:^(Picture-in-Picture)$"
        "pin,title:^(Picture-in-Picture)$"
        "size 640 360,title:^(Picture-in-Picture)$"
        "move 70% 70%,title:^(Picture-in-Picture)$"
        "keepaspectratio,title:^(Picture-in-Picture)$"
      ];

      # --- Layer Rules ---
      layerrule = [
        "blur,waybar"
        "ignorezero,waybar"
      ];

      # --- General appearance ---
      general = {
        gaps_in = 1;
        gaps_out = 0;
        border_size = 1;
        col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        col.inactive_border = "rgba(595959aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      # --- Decorations ---
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };

      # --- Animations ---
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      # --- Keybindings ---
      bind = [
        "SUPER, RETURN, exec, kitty"
        "SUPER, Q, killactive"
        "ALT, B, exec, firefox"
        "ALT, F, exec, thunar"
        "SUPER, SPACE, exec, rofi -show drun"
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # Workspaces
        "SUPER, 1, workspace, r~1"
        "SUPER, 2, workspace, r~2"
        "SUPER, 3, workspace, r~3"
        "SUPER, 4, workspace, r~4"
        "SUPER, 5, workspace, r~5"
        "SUPER, 6, workspace, r~6"
        "SUPER, 7, workspace, r~7"
        "SUPER, 8, workspace, r~8"
        "SUPER, 9, workspace, r~9"

        # Move to Workspaces
        "SUPER SHIFT, 1, movetoworkspace, r~1"
        "SUPER SHIFT, 2, movetoworkspace, r~2"
        "SUPER SHIFT, 3, movetoworkspace, r~3"
        "SUPER SHIFT, 4, movetoworkspace, r~4"
        "SUPER SHIFT, 5, movetoworkspace, r~5"
        "SUPER SHIFT, 6, movetoworkspace, r~6"
        "SUPER SHIFT, 7, movetoworkspace, r~7"
        "SUPER SHIFT, 8, movetoworkspace, r~8"
        "SUPER SHIFT, 9, movetoworkspace, r~9"

        # Navigation & Focus
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"
        "SUPER, comma, focusmonitor, +1"
        "SUPER, period, focusmonitor, -1"
        "SUPER, TAB, cyclenext"
        "SUPER, TAB, bringactivetotop"

        # Resize
        "SUPER SHIFT, L, resizeactive, 50 0"
        "SUPER SHIFT, H, resizeactive, -50 0"
        "SUPER SHIFT, K, resizeactive, 0 -50"
        "SUPER SHIFT, J, resizeactive, 0 50"

        # Layouts & Session
        "SUPER, V, togglefloating"
        "SUPER, F, fullscreen"
        "SUPER SHIFT, E, exit"
        "SUPER, X, exec, hyprlock"
      ];

      # --- Mouse bindings ---
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
