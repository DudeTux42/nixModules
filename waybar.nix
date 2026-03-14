{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" ];
      };
    };
    style = ''
      * {
        font-size: 12pt;
        font-family: "JetBrainsMono Nerd Font";
      }
      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
      }
    '';
  };
}
