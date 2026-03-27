#!/usr/bin/env bash
# Template für eigene Rofi Modi
# 
# Usage in rofi.nix:
#   rofi-mymode = pkgs.writeShellScriptBin "rofi-mymode" (builtins.readFile ./rofi-custom-template.sh);
#   modi = "...,mymode:${rofi-mymode}/bin/rofi-mymode";
#   display-mymode = "  My Mode";

# Wenn keine Auswahl getroffen wurde ($@ ist leer), zeige das Menü
if [ -z "$@" ]; then
  # Hier deine Menü-Einträge (ein echo pro Zeile)
  echo "󰀄 Option 1"
  echo "󰀅 Option 2"
  echo "󰀆 Option 3"
  echo "---"  # Separator
  echo "⚙ Settings"
  
  # Du kannst auch dynamische Inhalte generieren:
  # ls ~/ | while read file; do
  #   echo "📁 $file"
  # done

# Wenn eine Auswahl getroffen wurde, handle sie
else
  case "$1" in
    *"Option 1"*)
      # Deine Aktion für Option 1
      notify-send "Rofi" "Option 1 selected"
      ;;
      
    *"Option 2"*)
      # Aktion für Option 2
      kitty -e bash -c "echo 'Running Option 2'; sleep 2"
      ;;
      
    *"Option 3"*)
      # Weitere Aktionen...
      echo "Option 3 clicked" >> /tmp/rofi-log.txt
      ;;
      
    *"Settings"*)
      # Settings-Dialog
      ;;
      
    # Für dynamische Inhalte:
    # *"📁 "*)
    #   FILE=$(echo "$1" | sed 's/📁 //')
    #   xdg-open "$HOME/$FILE"
    #   ;;
  esac
fi
