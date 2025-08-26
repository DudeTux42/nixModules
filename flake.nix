{
  description = "Home Manager + Neovim config flake (non-flat structure)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "ll"; # Change to your actual username
      homeDirectory = "/home/ll"; # Change to your actual home dir
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          /home/ll/.config/home-manager/home.nix  
          ./nvim.nix  # Same here; adjust path if needed
        ];
        extraSpecialArgs = { inherit username homeDirectory; };
      };
    };
}
