{
  description = "NixOS System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, awww, ... }@inputs:
    let
      system = "x86_64-linux";
      
      # Overlay für unstable packages
      overlays = [
        (final: prev: {
          unstable = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          
          specialArgs = { inherit inputs; };
          
          modules = [
            # Hardware config
            ./hardware-configuration.nix
            
            # Apply overlay
            { nixpkgs.overlays = overlays; }
            
            # Main system configuration
            ./system/configuration.nix
            
            # VirtualBox module
            ./vbox.nix
            
            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.ll = import ./home.nix;
            }
          ];
        };
      };
    };
}
