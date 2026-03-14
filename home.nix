{ config, pkgs, zen-browser, ... }:

{
  home = {
    username = "ll";
    homeDirectory = "/home/ll";
    stateVersion = "25.05";
  
    packages = with pkgs; [
      # Hier können Sie zusätzliche Pakete für Ihren Benutzer definieren
      # zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Importieren Sie Ihre bestehenden Konfigurationen
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
  ];

  # Zusätzliche Konfigurationen können hier hinzugefügt werden
}
