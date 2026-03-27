{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 6;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/keyboard" "pulseaudio" "cpu" "memory" "temperature" "battery" "tray" ];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            urgent = "";
            active = "";
            default = "";
          };
          sort-by-number = true;
        };
        
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };
        
        
        "custom/keyboard" = {
          exec = "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | sed 's/German/🇩🇪/' | sed 's/English (US, intl., with dead keys)/🇺🇸/'";
          interval = 1;
          format = "{}";
          on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
          tooltip = false;
        };
        
        tray = {
          spacing = 10;
        };
        
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%d.%m.%Y  %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        
        cpu = {
          format = "💻  {usage}%";
          tooltip = false;
        };
        
        memory = {
          format = "🧠 {}%";
        };
        
        temperature = {
          critical-threshold = 80;
          format = "🌡️ {temperatureC}°C";
          format-critical = "🔥 {temperatureC}°C";
          format-icons = [ "❄️" "🌡️" "🔥" ];
        };
        
        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "⚡ {capacity}%";
          format-plugged = "🔌 {capacity}%";
          format-alt = "{icon}  {time}";
          format-icons = [ "🪫" "🔋" "🔋" "🔋" "🔋" ];
        };
        
       
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-bluetooth = "🎧 {volume}%";
          format-bluetooth-muted = "🎧 🔇";
          format-muted = "🔇 {volume}%";
          format-icons = {
            headphone = "🎧";
            hands-free = "📞";
            headset = "🎧";
            phone = "📱";
            portable = "🔊";
            car = "🚗";
            default = [ "🔈" "🔉" "🔊" ];
          };
          on-click = "pavucontrol";
          tooltip-format = "{desc}\nVolume: {volume}%";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: linear-gradient(135deg, rgba(17, 17, 27, 0.95), rgba(30, 30, 46, 0.95));
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: .5s;
        border-bottom: 1px solid transparent;
        border-image: linear-gradient(90deg, #89b4fa, #cba6f7, #f5c2e7) 1;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces {
        margin: 0 4px;
      }

      #workspaces button {
        padding: 0 10px;
        background-color: transparent;
        color: #6c7086;
        border-radius: 10px;
        margin: 3px 3px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.15);
        color: #89b4fa;
        box-shadow: 0 0 8px rgba(137, 180, 250, 0.3);
      }

      #workspaces button.active {
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.5), rgba(203, 166, 247, 0.5));
        color: #cdd6f4;
        box-shadow: 0 0 12px rgba(137, 180, 250, 0.5);
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
        color: #1e1e2e;
      }

      #window {
        margin: 0 12px;
        padding: 0 12px;
        color: #a6adc8;
        font-style: italic;
        font-weight: 500;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #idle_inhibitor,
      #custom-keyboard,
      #tray {
        padding: 4px 14px;
        margin: 4px 3px;
        background: rgba(49, 50, 68, 0.7);
        border-radius: 12px;
        border: 1px solid rgba(180, 190, 254, 0.1);
        transition: all 0.3s ease;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #idle_inhibitor,
      #custom-keyboard,
      #tray {
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
      }

      #clock:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover,
      #network:hover,
      #pulseaudio:hover,
      #idle_inhibitor:hover,
      #custom-keyboard:hover,
      #tray:hover {
        background: rgba(49, 50, 68, 0.9);
        box-shadow: 0 3px 10px rgba(137, 180, 250, 0.3);
      }

      #clock {
        background: linear-gradient(135deg, rgba(137, 180, 250, 0.3), rgba(116, 199, 236, 0.3));
        color: #89b4fa;
        font-weight: bold;
        font-size: 14px;
        padding: 4px 16px;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.good {
        color: #a6e3a1;
      }

      #battery.charging, #battery.plugged {
        color: #a6e3a1;
        background: linear-gradient(135deg, rgba(166, 227, 161, 0.2), rgba(148, 226, 213, 0.2));
      }

      #battery.warning:not(.charging) {
        color: #fab387;
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.2), rgba(249, 226, 175, 0.2));
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.3), rgba(235, 160, 172, 0.3));
      }

      #cpu {
        color: #f9e2af;
        background: linear-gradient(135deg, rgba(249, 226, 175, 0.15), rgba(250, 179, 135, 0.15));
      }

      #memory {
        color: #cba6f7;
        background: linear-gradient(135deg, rgba(203, 166, 247, 0.15), rgba(245, 194, 231, 0.15));
      }

      #temperature {
        color: #fab387;
        background: linear-gradient(135deg, rgba(250, 179, 135, 0.15), rgba(243, 139, 168, 0.15));
      }

      #temperature.critical {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.3);
      }

      #network {
        color: #94e2d5;
        background: linear-gradient(135deg, rgba(148, 226, 213, 0.15), rgba(137, 220, 235, 0.15));
      }

      #network.disconnected {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.2);
      }

      #pulseaudio {
        color: #89dceb;
        background: linear-gradient(135deg, rgba(137, 220, 235, 0.15), rgba(116, 199, 236, 0.15));
      }

      #pulseaudio.muted {
        color: #6c7086;
        background: rgba(108, 112, 134, 0.15);
      }

      #idle_inhibitor {
        color: #f5e0dc;
        background: linear-gradient(135deg, rgba(245, 224, 220, 0.15), rgba(242, 205, 205, 0.15));
      }

      #idle_inhibitor.activated {
        color: #f38ba8;
        background: linear-gradient(135deg, rgba(243, 139, 168, 0.3), rgba(235, 160, 172, 0.3));
        box-shadow: 0 0 10px rgba(243, 139, 168, 0.4);
      }

      #custom-keyboard {
        color: #f5c2e7;
        background: linear-gradient(135deg, rgba(245, 194, 231, 0.15), rgba(203, 166, 247, 0.15));
      }

      #custom-keyboard:hover {
        background: linear-gradient(135deg, rgba(245, 194, 231, 0.3), rgba(203, 166, 247, 0.3));
        box-shadow: 0 0 10px rgba(245, 194, 231, 0.4);
      }

      #tray {
        color: #cdd6f4;
        background: linear-gradient(135deg, rgba(205, 214, 244, 0.1), rgba(166, 173, 200, 0.1));
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
      }
    '';
  };
}
