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
      PATH = "$HOME/.cargo/bin:$PATH";
    };
  };

  imports = [
   ./modules/kitty.nix
   ./modules/fonts.nix
   ./modules/nvim.nix
   ./modules/zellij.nix
   ./modules/bottom.nix
   ./modules/firefox.nix
   ./modules/rofi.nix
   ./modules/git.nix
   ./modules/zsh.nix
   ./modules/hypr.nix
   ./modules/hyprlock.nix
   ./modules/waybar.nix
   ./modules/card-unlock.nix
   ./modules/flameshot.nix
   ./modules/nextcloud.nix
  ];

  programs.home-manager.enable = true;
}
