{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = false;

    # --- Monitore ---
    settings = {
      monitor = [
        # Oberer Hauptmonitor (DP-4)
        "DP-4,2400x1350@60,0x0,1"

        # Rechts daneben, gedreht (DP-3, Portrait)
        "DP-3,1350x2400@60,2400x0,1,transform,3"

        # Unten drunter (eDP-1, Laptop)
        "eDP-1,1920x1080@60,480x1350,1"
      ];

      # --- Programme, die einmal beim Start ausgeführt werden ---
      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
        "kitty"
      ];

      # --- Tastatur & Input ---
      input = {
        kb_layout = "de";
        follow_mouse = 1;
      };

      # --- Gaps & Border ---
      general = {
        gaps_in = 5;
        border_size = 2;
      };
    };

    # --- Keybindings & weitere Konfiguration ---
    extraConfig = ''
      # --- Terminal + Launcher ---
      bind = SUPER,RETURN,exec,kitty
      bind = SUPER,SPACE,exec,rofi -show drun

      # --- Fenster Management: Fokus ---
      bind = SUPER,H,movefocus,l
      bind = SUPER,L,movefocus,r
      bind = SUPER,J,movefocus,d
      bind = SUPER,K,movefocus,u

      # --- Fenster verschieben ---
      bind = SUPER+SHIFT,H,movewindow,l
      bind = SUPER+SHIFT,L,movewindow,r
      bind = SUPER+SHIFT,J,movewindow,d
      bind = SUPER+SHIFT,K,movewindow,u

      # --- Fenster Größe ändern ---
      bind = SUPER+CTRL,H,resizeactive,l
      bind = SUPER+CTRL,L,resizeactive,r
      bind = SUPER+CTRL,J,resizeactive,d
      bind = SUPER+CTRL,K,resizeactive,u

      # --- Workspaces wechseln ---
      bind = SUPER,1,workspace,1
      bind = SUPER,2,workspace,2
      bind = SUPER,3,workspace,3
      bind = SUPER,4,workspace,4
      bind = SUPER,5,workspace,5
      bind = SUPER,6,workspace,6
      bind = SUPER,7,workspace,7
      bind = SUPER,8,workspace,8
      bind = SUPER,9,workspace,9

      # --- Fenster auf Workspaces verschieben ---
      bind = SUPER+SHIFT,1,movetoworkspace,1
      bind = SUPER+SHIFT,2,movetoworkspace,2
      bind = SUPER+SHIFT,3,movetoworkspace,3
      bind = SUPER+SHIFT,4,movetoworkspace,4
      bind = SUPER+SHIFT,5,movetoworkspace,5
      bind = SUPER+SHIFT,6,movetoworkspace,6
      bind = SUPER+SHIFT,7,movetoworkspace,7
      bind = SUPER+SHIFT,8,movetoworkspace,8
      bind = SUPER+SHIFT,9,movetoworkspace,9

      # --- Session Management ---
      bind = SUPER+SHIFT,E,exit
      bind = SUPER+CTRL,R,reload

      # --- Screenshot ---
      bind = PRINT,,exec,grim /tmp/screenshot.png
      bind = SUPER+PRINT,,exec,grim -g "$(slurp)" /tmp/screenshot.png
    '';
  };
}
