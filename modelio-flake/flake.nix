{
  description = "Modelio - Open Source Modeling Environment";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Alternativ für stable:
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Das Hauptpaket
      packages.${system} = {
        modelio = pkgs.callPackage ./modelio.nix {};
        default = self.packages.${system}.modelio; # 'nix run' Standard
      };

      # Development Shell für Entwicklung/Debugging
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk8
          ant
          ivy
          git
        ];
        
        shellHook = ''
          echo "🎯 Modelio Development Environment"
          echo "Java: $(java -version 2>&1 | head -1)"
          echo "Ant: $(ant -version 2>&1 | head -1)"
        '';
      };

      # Apps - direkt ausführbar
      apps.${system} = {
        modelio = {
          type = "app";
          program = "${self.packages.${system}.modelio}/bin/modelio";
        };
        default = self.apps.${system}.modelio;
      };

      # NixOS Module (fortgeschritten)
      nixosModules.modelio = { config, lib, pkgs, ... }: {
        options.programs.modelio = {
          enable = lib.mkEnableOption "Modelio modeling environment";
        };
        
        config = lib.mkIf config.programs.modelio.enable {
          environment.systemPackages = [ self.packages.${system}.modelio ];
        };
      };
    };
}
