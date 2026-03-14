{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "Arc-Dark"; # kannst du nach Belieben ändern
  };
}
