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
   ./home/modules/kitty.nix
   ./home/modules/fonts.nix
   ./home/modules/nvim.nix
   ./home/modules/zellij.nix
   ./home/modules/bottom.nix
   ./home/modules/firefox.nix
   ./home/modules/rofi.nix
   ./home/modules/git.nix
   ./home/modules/zsh.nix
   ./home/modules/hypr.nix
   ./home/modules/hyprlock.nix
   ./home/modules/waybar.nix
   ./home/modules/card-unlock.nix
   ./home/modules/flameshot.nix
   ./home/modules/nextcloud.nix
  ];

  programs.home-manager.enable = true;
}
