{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      # Helper: baut ein NixOS-System aus hostname + CPU-Architektur.
      # Neuen Rechner hinzufügen = eine Zeile in nixosConfigurations.
      mkSystem = hostname: system: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          # Overlay: pkgs.unstable ist überall verfügbar
          {
            nixpkgs.overlays = [(final: prev: {
              unstable = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            })];
          }

          # Hardware + host-spezifische Einstellungen
          ./hosts/${hostname}/default.nix

          # Gemeinsame Module (auf jedem Rechner gleich)
          ./modules/common.nix
          ./modules/desktop.nix
          ./modules/firefox.nix

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.ll = import ./home.nix;
          }
        ];
      };

    in {
      nixosConfigurations = {
        t480s = mkSystem "t480s" "x86_64-linux";

        # Neuen Rechner so hinzufügen:
        # newmachine = mkSystem "newmachine" "x86_64-linux";
      };
    };
}
