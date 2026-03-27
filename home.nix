{ config, pkgs, ... }:

{
  home = {
    username = "ll";
    homeDirectory = "/home/ll";
    stateVersion = "25.05";
  
    packages = with pkgs; [
      # User-specific packages
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  imports = [
   ./kitty.nix
   ./fonts.nix
   ./nvim.nix
   ./zellij.nix
   ./bottom.nix
   ./firefox.nix
   ./rofi.nix
   ./git.nix
   ./zsh.nix
   ./hypr.nix
   ./hyprlock.nix
   ./waybar.nix
   ./card-unlock.nix
   ./flameshot.nix
   ./nextcloud.nix
  ];

  programs.home-manager.enable = true;
}
