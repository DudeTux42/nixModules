{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
  ];
  
  shellHook = ''
    echo "Rust development environment loaded"
    echo "rustc version: $(rustc --version)"
  '';
}
