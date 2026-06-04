{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    
    # Komplett leer lassen, um die fehlerhafte Modul-Generierung zu blockieren
    settings = {};

    # 1:1 unveränderter Konfigurationstext für Hyprland
    extraConfig = ''
      # --- Monitore ---
      monitor = eDP-1,1920x1080@60,0x1080,1
      monitor = desc:Dell Inc. DELL U2414H,1920x1080@60,0x0,1
      monitor = desc:Lenovo Group Limited D27-45,1920x1080@60,1920x0,1,transform,3
      monitor = ,preferred,auto,1

      # --- Autostart ---
      exec-once = waybar
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      exec-once = blueman-applet
      exec-once = hypridle

      # --- Input ---
      input {
          kb_layout = us,de
          kb_variant = altgr-intl,
          kb_options = caps:swapescape,grp:alt_shift_toggle
          follow_mouse = 1

          touchpad {
              natural_scroll = true
              disable_while_typing = true
          }
      }

      # --- Gestures ---
      gestures {
          workspace_swipe = true
          workspace_swipe_fingers = 3
      }

      # --- Window Rules (Firefox Picture-in-Picture) ---
      windowrulev2 = float, title:^(Picture-in-Picture)$
      windowrulev2 = pin, title:^(Picture-in-Picture)$
      windowrulev2 = size 640 360, title:^(Picture-in-Picture)$
      windowrulev2 = move 70% 70%, title:^(Picture-in-Picture)$
      windowrulev2 = keepaspectratio, title:^(Picture-in-Picture)$

      # --- Layer Rules ---
      layerrule = blur, waybar
      layerrule = ignorezero, waybar

      # --- Aussehen ---
      general {
          gaps_in = 1
          gaps_out = 0
          border_size = 1
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          layout = dwindle
      }

      decoration {
          rounding = 5
          blur {
              enabled = true
              size = 3
              passes = 1
          }
          shadow {
              enabled = true
              range = 4
              render_power = 3
          }
      }

      animations {
          enabled = true
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          preserve_split = true
      }

      # --- Keybindings ---
      bind = SUPER, RETURN, exec, kitty
      bind = SUPER, Q, killactive
      bind = ALT, B, exec, firefox
      bind = ALT, F, exec, thunar
      bind = SUPER, SPACE, exec, rofi -show drun
      bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -

      # Workspaces
      bind = SUPER, 1, workspace, r~1
      bind = SUPER, 2, workspace, r~2
      bind = SUPER, 3, workspace, r~3
      bind = SUPER, 4, workspace, r~4
      bind = SUPER, 5, workspace, r~5
      bind = SUPER, 6, workspace, r~6
      bind = SUPER, 7, workspace, r~7
      bind = SUPER, 8, workspace, r~8
      bind = SUPER, 9, workspace, r~9

      # Move to Workspaces
      bind = SUPER SHIFT, 1, movetoworkspace, r~1
      bind = SUPER SHIFT, 2, movetoworkspace, r~2
      bind = SUPER SHIFT, 3, movetoworkspace, r~3
      bind = SUPER SHIFT, 4, movetoworkspace, r~4
      bind = SUPER SHIFT, 5, movetoworkspace, r~5
      bind = SUPER SHIFT, 6, movetoworkspace, r~6
      bind = SUPER SHIFT, 7, movetoworkspace, r~7
      bind = SUPER SHIFT, 8, movetoworkspace, r~8
      bind = SUPER SHIFT, 9, movetoworkspace, r~9

      # Navigation & Focus
      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d
      bind = SUPER, comma, focusmonitor, +1
      bind = SUPER, period, focusmonitor, -1
      bind = SUPER, TAB, cyclenext
      bind = SUPER, TAB, bringactivetotop

      # Resize
      bind = SUPER SHIFT, L, resizeactive, 50 0
      bind = SUPER SHIFT, H, resizeactive, -50 0
      bind = SUPER SHIFT, K, resizeactive, 0 -50
      bind = SUPER SHIFT, J, resizeactive, 0 50

      # Layouts & Session
      bind = SUPER, V, togglefloating
      bind = SUPER, F, fullscreen
      bind = SUPER SHIFT, E, exit
      bind = SUPER, X, exec, hyprlock

      # Maus-Bindings
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
    '';
  };
}
