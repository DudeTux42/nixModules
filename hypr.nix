{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # --- Monitore ---
      monitor = [
        # Laptop-Display unten links
        "eDP-1,1920x1080@60,0x1080,1"
        
        # Dell Monitor über Laptop
        "desc:Dell Inc. DELL U2414H,1920x1080@60,0x0,1"
        
        # Lenovo Monitor rechts, hochkant (270° = nach links gedreht)
        "desc:Lenovo Group Limited D27-45,1920x1080@60,1920x0,1,transform,3"
        
        # Fallback für unbekannte Monitore
        ",preferred,auto,1"
      ];

      # --- Autostart ---
      exec-once = [
        "waybar"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "blueman-applet"
        "hypridle"
      ];

      # --- Input ---
      input = {
        kb_layout = "us,de";
        kb_variant = "intl,";
        kb_options = "caps:swapescape,grp:alt_shift_toggle";
        follow_mouse = 1;
        
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };

      # --- Touchpad Gestures ---
      gesture = [
        "3, horizontal, workspace"
      ];

      # --- Window Rules ---
      windowrulev2 = [
        # Firefox Picture-in-Picture Fix: Automatisch floating, obenauf und fixe Größe
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "size 640 360, title:^(Picture-in-Picture)$"
        "move 70% 70%, title:^(Picture-in-Picture)$"
        "keepaspectratio, title:^(Picture-in-Picture)$"
      ];

      # --- Layer Rules ---
      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
      ];

      # --- Aussehen ---
      general = {
        gaps_in = 1;
        gaps_out = 0;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

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
        pseudotile = true;
        preserve_split = true;
      };

      # --- Keybindings ---
      bind = [
        # SUPER + ENTER: Terminal öffnen
        "SUPER, RETURN, exec, kitty"
        
        # SUPER + Q: Fenster schließen
        "SUPER, Q, killactive"

        # ALT + Taste: Programme starten
        "ALT, B, exec, firefox"
        "ALT, F, exec, thunar"
        "SUPER, SPACE, exec, rofi -show drun"
        
        # Screenshot mit grim + slurp + swappy
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # SUPER + Zahl: Workspace auf aktuellem Monitor wechseln (r~1 = relative)
        "SUPER, 1, workspace, r~1"
        "SUPER, 2, workspace, r~2"
        "SUPER, 3, workspace, r~3"
        "SUPER, 4, workspace, r~4"
        "SUPER, 5, workspace, r~5"
        "SUPER, 6, workspace, r~6"
        "SUPER, 7, workspace, r~7"
        "SUPER, 8, workspace, r~8"
        "SUPER, 9, workspace, r~9"

        # SUPER + SHIFT + Zahl: Fenster auf Workspace verschieben
        "SUPER SHIFT, 1, movetoworkspace, r~1"
        "SUPER SHIFT, 2, movetoworkspace, r~2"
        "SUPER SHIFT, 3, movetoworkspace, r~3"
        "SUPER SHIFT, 4, movetoworkspace, r~4"
        "SUPER SHIFT, 5, movetoworkspace, r~5"
        "SUPER SHIFT, 6, movetoworkspace, r~6"
        "SUPER SHIFT, 7, movetoworkspace, r~7"
        "SUPER SHIFT, 8, movetoworkspace, r~8"
        "SUPER SHIFT, 9, movetoworkspace, r~9"

        # Fenster-Navigation (SUPER + H/J/K/L)
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"
        
        # Monitor-Wechsel (SUPER + , und .)
        "SUPER, comma, focusmonitor, +1"
        "SUPER, period, focusmonitor, -1"
        
        # Zur letzten Anwendung wechseln (SUPER + TAB)
        "SUPER, TAB, cyclenext"
        "SUPER, TAB, bringactivetotop"
        
        # Fenster-Größe ändern (SUPER + SHIFT + H/J/K/L)
        "SUPER SHIFT, L, resizeactive, 50 0"
        "SUPER SHIFT, H, resizeactive, -50 0"
        "SUPER SHIFT, K, resizeactive, 0 -50"
        "SUPER SHIFT, J, resizeactive, 0 50"

        # Floating und Fullscreen
        "SUPER, V, togglefloating"
        "SUPER, F, fullscreen"

        # Session / System
        "SUPER SHIFT, E, exit"
        "SUPER, X, exec, hyprlock"
      ];

      # Maus-Bindings (Verschieben und Größe ändern mit SUPER)
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
