# Nix Configuration

Meine persönliche Nix Home Manager Konfiguration.

## Struktur

- `flake.nix` - Haupt-Flake-Konfiguration
- `shell.nix` - Rust Entwicklungsumgebung (mit `nix-shell` zu verwenden)
- Module:
  - `firefox.nix` - Firefox mit Extensions und Policies
  - `nvim.nix` - Neovim mit LSPs und Tools
  - `kitty.nix` - Kitty Terminal mit Zellij Integration
  - `zellij.nix` - Terminal Multiplexer
  - `waybar.nix` - Wayland Status Bar
  - `hypr.nix` - Hyprland Window Manager
  - `rofi.nix` - Application Launcher
  - `bottom.nix` - System Monitor
  - `fonts.nix` - Font Packages
  - `git.nix` - Git Konfiguration
  - `zsh.nix` - Zsh Shell mit Aliases

## Installation

```bash
# Home Manager aktivieren
home-manager switch --flake ~/nix#ll
```

## Rust Development

```bash
# Shell mit Rust Tools laden
cd ~/nix
nix-shell
```

## vbox.nix - Wichtig!

`vbox.nix` ist eine **System-Konfiguration** und muss in `/etc/nixos/configuration.nix` importiert werden:

```nix
# /etc/nixos/configuration.nix
imports = [
  /home/ll/nix/vbox.nix
];
```

## Updates

```bash
# Flake Updates
nix flake update

# Home Manager neu bauen
home-manager switch --flake ~/nix#ll
```
