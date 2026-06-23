{ config, pkgs, ... }:

let
  # Template für eigene Rofi Modi
  # Erstelle ein Script mit echo pro Zeile für Menü-Einträge
  # Bei Auswahl wird die gewählte Zeile als $1 übergeben
  
  # WiFi Manager
  rofi-wifi = pkgs.writeShellScriptBin "rofi-wifi" ''
    if [ -z "$@" ]; then
      echo "󰤨 Scan Networks"
      echo "󰤪 Enable WiFi"
      echo "󰤭 Disable WiFi"
      echo "---"
      nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2 | while read line; do
        echo "󰤨 $line"
      done
    else
      case "$1" in
        *"Scan Networks"*)
          nmcli device wifi rescan
          ;;
        *"Enable WiFi"*)
          nmcli radio wifi on
          ;;
        *"Disable WiFi"*)
          nmcli radio wifi off
          ;;
        *"󰤨 "*)
          # Entferne Icon und extrahiere SSID (alles vor den letzten 2 Spalten SIGNAL und SECURITY)
          LINE=$(echo "$1" | sed 's/^󰤨 //')
          SSID=$(echo "$LINE" | awk '{for(i=1;i<=NF-2;i++) printf "%s%s", $i, (i<NF-2?" ":"")}')
          PASSWORD=$(rofi -dmenu -p "Password for $SSID" -password)
          if [ -n "$PASSWORD" ]; then
            nmcli device wifi connect "$SSID" password "$PASSWORD"
          fi
          ;;
      esac
    fi
  '';

  # Power Menu
  rofi-power = pkgs.writeShellScriptBin "rofi-power" ''
    if [ -z "$@" ]; then
      echo "⏻ Shutdown"
      echo "⟳ Reboot"
      echo "⇠ Logout"
      echo "⏾ Suspend"
      echo "🔒 Lock"
    else
      case "$1" in
        *"Shutdown"*)
          systemctl poweroff
          ;;
        *"Reboot"*)
          systemctl reboot
          ;;
        *"Logout"*)
          hyprctl dispatch exit
          ;;
        *"Suspend"*)
          systemctl suspend
          ;;
        *"Lock"*)
          hyprlock
          ;;
      esac
    fi
  '';

  # Command Runner mit History
  rofi-commands = pkgs.writeShellScriptBin "rofi-commands" ''
    HISTORY_FILE="$HOME/.cache/rofi-commands-history"
    
    if [ -z "$@" ]; then
      if [ -f "$HISTORY_FILE" ]; then
        echo " Recent Commands"
        echo "---"
        tac "$HISTORY_FILE" | head -n 10
        echo "---"
      fi
      echo "💡 Type command and press Enter"
    else
      if [[ "$1" != " Recent Commands" ]] && [[ "$1" != "---" ]] && [[ "$1" != "💡"* ]]; then
        # Speichere Command in History
        mkdir -p "$(dirname "$HISTORY_FILE")"
        echo "$1" >> "$HISTORY_FILE"
        
        # Führe Command aus
        kitty -e bash -c "{ $1; echo; echo 'Press Enter to close...'; } >> ~/log/rofi_command_run.log; read"
      fi  
    fi
  '';

  # Clipboard Manager (benötigt cliphist)
  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    if [ -z "$@" ]; then
      cliphist list
    else
      echo -n "$1" | cliphist decode | wl-copy
    fi
  '';

  # Template für eigene Modi:
  # rofi-custom = pkgs.writeShellScriptBin "rofi-custom" ''
  #   if [ -z "$@" ]; then
  #     # Zeige Menü-Einträge (echo pro Zeile)
  #     echo "Option 1"
  #     echo "Option 2"
  #   else
  #     # Handle Auswahl in $1
  #     case "$1" in
  #       "Option 1"*)
  #         # Aktion für Option 1
  #         ;;
  #     esac
  #   fi
  # '';

in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    
    extraConfig = {
      modi = "drun,run,wifi:${rofi-wifi}/bin/rofi-wifi,commands:${rofi-commands}/bin/rofi-commands,power:${rofi-power}/bin/rofi-power,clipboard:${rofi-clipboard}/bin/rofi-clipboard";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = true;
      display-drun = "  Apps";
      display-run = "  Run";
      display-wifi = "󰤨  WiFi";
      display-commands = "  Commands";
      display-power = "⏻  Power";
      display-clipboard = "  Clipboard";
    };
    
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col = mkLiteral "#1e1e2e";
        bg-col-light = mkLiteral "#313244";
        border-col = mkLiteral "#89b4fa";
        selected-col = mkLiteral "#45475a";
        blue = mkLiteral "#89b4fa";
        fg-col = mkLiteral "#cdd6f4";
        fg-col2 = mkLiteral "#f38ba8";
        grey = mkLiteral "#6c7086";
        width = 600;
      };

      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "window" = {
        height = mkLiteral "360px";
        border = mkLiteral "3px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "12px";
      };

      "mainbox" = {
        background-color = mkLiteral "@bg-col";
      };

      "inputbar" = {
        children = mkLiteral "[prompt,entry]";
        background-color = mkLiteral "@bg-col-light";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px";
        margin = mkLiteral "8px";
      };

      "prompt" = {
        background-color = mkLiteral "@blue";
        padding = mkLiteral "6px 12px";
        text-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "6px";
        margin = mkLiteral "0px 8px 0px 0px";
      };

      "textbox-prompt-colon" = {
        expand = false;
        str = ":";
      };

      "entry" = {
        padding = mkLiteral "6px";
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col-light";
      };

      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "6px 0px 0px";
        margin = mkLiteral "10px 10px 0px 10px";
        columns = 1;
        lines = 6;
        background-color = mkLiteral "@bg-col";
      };

      "element" = {
        padding = mkLiteral "8px";
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
        border-radius = mkLiteral "6px";
      };

      "element-icon" = {
        size = mkLiteral "28px";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@blue";
      };

      "mode-switcher" = {
        spacing = 0;
      };

      "button" = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@blue";
      };

      "message" = {
        background-color = mkLiteral "@bg-col-light";
        margin = mkLiteral "8px";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "8px";
      };

      "textbox" = {
        padding = mkLiteral "6px";
        margin = mkLiteral "20px 0px 0px 20px";
        text-color = mkLiteral "@fg-col";
        background-color = mkLiteral "@bg-col-light";
      };
    };
  };
}
