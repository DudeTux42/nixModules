# NixOS System Flake - Migration Guide

## 🎯 Was wurde geändert?

### Vorher (mit Channels):
- `import <nixpkgs-unstable>` → nicht reproduzierbar (nutzt NIX_PATH)
- `<home-manager/nixos>` → nicht reproduzierbar
- Separate flake.nix für Home Manager

### Jetzt (vollständig Flake-basiert):
- Alle Inputs in `flake.nix` deklariert und gepinnt
- System-Config und Home-Manager in einer Flake
- `pkgs.unstable` via Overlay verfügbar
- Vollständig reproduzierbar

## 📂 Struktur

```
/home/ll/nix/
├── flake.nix.new         # Neue Flake-Config (ersetzt alte flake.nix)
├── flake.lock            # Wird automatisch generiert
├── system/
│   └── configuration.nix # System-Config (bereinigt)
├── home.nix              # Home-Manager Config
├── vbox.nix              # VirtualBox Module
├── kitty.nix             # Terminal Config
├── nvim.nix              # Neovim Config
├── hypr.nix              # Hyprland Config
└── ... (weitere Module)
```

## 🚀 Migration Schritte

### 1. Teste die neue Config (ohne System zu ändern):
```bash
cd /home/ll/nix
nix flake check --show-trace
```

### 2. Baue das System (ohne zu aktivieren):
```bash
sudo nixos-rebuild build --flake /home/ll/nix#nixos
```

### 3. Wenn Build erfolgreich, ersetze alte Flake:
```bash
cd /home/ll/nix
mv flake.nix flake.nix.old
mv flake.nix.new flake.nix
```

### 4. Aktiviere die neue Config:
```bash
sudo nixos-rebuild switch --flake /home/ll/nix#nixos
```

### 5. (Optional) Bereinige alte Channels:
```bash
nix-channel --list
# Falls vorhanden:
sudo nix-channel --remove nixpkgs-unstable
```

## 🔄 Tägliche Nutzung

### System rebuilden:
```bash
rebuild  # Alias: sudo nixos-rebuild switch --flake /home/ll/nix#nixos
```

### System & Flake Updates:
```bash
update   # Alias: cd /home/ll/nix && nix flake update && rebuild
```

### Nur Flake-Inputs updaten:
```bash
cd /home/ll/nix
nix flake update
```

### Bestimmte Inputs updaten:
```bash
nix flake update nixpkgs
nix flake update home-manager
```

## 📦 Config mitnehmen (auf neues System)

### Variante 1: Manuell
```bash
# Auf neuem System:
git clone <dein-repo> /home/ll/nix
cd /home/ll/nix

# Hardware-config generieren:
sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix
# Dann in flake.nix anpassen

# System bauen:
sudo nixos-rebuild switch --flake .#nixos
```

### Variante 2: Mit GitHub Actions (siehe unten)

## 🤖 GitHub Actions Setup

### .github/workflows/build.yml
```yaml
name: Build NixOS Config

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Nix
        uses: cachix/install-nix-action@v24
        with:
          extra_nix_config: |
            experimental-features = nix-command flakes
      
      - name: Check Flake
        run: nix flake check --show-trace
      
      - name: Build System (dry-run)
        run: |
          # Hardware-config mocken für CI
          mkdir -p /tmp/etc/nixos
          cat > /tmp/etc/nixos/hardware-configuration.nix << 'EOF'
          { config, lib, pkgs, modulesPath, ... }:
          {
            imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
            boot.loader.grub.device = "/dev/sda";
            fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
          }
          EOF
          
          # flake.nix anpassen für CI
          sed -i 's|/etc/nixos/hardware-configuration.nix|/tmp/etc/nixos/hardware-configuration.nix|g' flake.nix
          
          # Build testen
          nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

### .github/workflows/update-flake.yml
```yaml
name: Update Flake

on:
  schedule:
    - cron: '0 2 * * 1'  # Jeden Montag 2 Uhr
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Nix
        uses: cachix/install-nix-action@v24
        with:
          extra_nix_config: |
            experimental-features = nix-command flakes
      
      - name: Update Flake
        run: nix flake update
      
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          commit-message: "chore: update flake inputs"
          title: "Update Flake Inputs"
          body: "Automated flake.lock update"
          branch: flake-update
```

## 🎯 Vorteile der neuen Config

✅ **Vollständig reproduzierbar** - keine channel dependencies  
✅ **Versioniert** - flake.lock pinnt alle Inputs  
✅ **Portabel** - einfach auf anderen Systemen nutzbar  
✅ **CI-fähig** - automatische Syntax-Checks  
✅ **Team-ready** - andere können deine exakte Config nutzen  

## 🔧 Troubleshooting

### Fehler: "input 'home-manager' has an override"
```bash
cd /home/ll/nix
rm flake.lock
nix flake update
```

### Hardware-Config fehlt
```bash
sudo cp /etc/nixos/hardware-configuration.nix /home/ll/nix/hardware-configuration.nix
# In flake.nix: /etc/nixos/hardware-configuration.nix → ./hardware-configuration.nix
```

### Rollback zur alten Config
```bash
sudo nixos-rebuild switch --rollback
```

## 📝 Nächste Schritte

1. ✅ Teste die neue Flake-Config
2. 🔄 Pushe nach GitHub
3. 🤖 Richte GitHub Actions ein
4. 🎯 (Optional) Hardware-config auch ins Repo
5. 🌟 (Optional) Multi-Host Support (für mehrere Geräte)
