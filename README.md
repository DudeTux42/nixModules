# NixOS Config

Flake-basierte NixOS-Konfiguration für mehrere Rechner.

## Struktur

```
nix/
├── flake.nix                       Einstiegspunkt, definiert alle Hosts
├── flake.lock                      Versions-Pin – immer committen
├── home.nix                        Home Manager (alle Hosts)
├── hosts/
│   └── t480s/
│       ├── default.nix             Hardware-spezifisch (Intel, LTE, Drucker)
│       └── hardware-configuration.nix
└── modules/
    ├── common.nix                  Gilt auf jedem Rechner
    └── desktop.nix                 Grafischer Desktop-Stack

Außerdem im Root (Home Manager Module):
hypr.nix  hyprlock.nix  waybar.nix  kitty.nix  nvim.nix
rofi.nix  zellij.nix  firefox.nix  fonts.nix  git.nix
zsh.nix  bottom.nix  card-unlock.nix  flameshot.nix
nextcloud.nix  vbox.nix
```

**Faustregel – welche Datei bearbeiten:**

| Was sich ändert | Datei |
|---|---|
| Paket für alle Rechner | `modules/common.nix` |
| Desktop-Einstellung | `modules/desktop.nix` |
| Nur T480s betrifft | `hosts/t480s/default.nix` |
| Shell, Editor, Fonts | `home.nix` + die jeweiligen Module |
| Neuer Rechner | `hosts/newmachine/default.nix` + Eintrag in `flake.nix` |

---

## Tägliche Nutzung

```bash
# Rebuilden (aktuelle Pakete, keine neuen Versionen)
rebuild

# Pakete updaten + rebuilden
update

# Nur testen, nicht aktivieren (beim Reboot wieder alte Config)
sudo nixos-rebuild test --flake .#$(hostname)

# Build prüfen ohne irgendwas zu aktivieren
sudo nixos-rebuild build --flake .#$(hostname)
```

**Änderung machen:**
```bash
nvim modules/common.nix   # oder welche Datei auch immer
rebuild
git add . && git commit -m "add: paketname"
git push
```

**Nach dem Bearbeiten von flake.nix selbst** (neuer Host, neuer Input):
```bash
git add .
sudo nixos-rebuild switch --flake .#$(hostname)
```
Flakes sehen nur Dateien die Git kennt – `git add` reicht, kein Commit nötig.

---

## Rollback

NixOS speichert bei jedem Switch automatisch eine Generation.

```bash
# Im laufenden System zurückrollen
sudo nixos-rebuild switch --rollback

# Generationen anzeigen
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Via Git: zu einem alten Commit zurück
git checkout abc1234
sudo nixos-rebuild switch --flake .#$(hostname)
git checkout main
```

Alternativ beim Booten in systemd-boot einfach den vorherigen Eintrag wählen,
dann im gestarteten System `sudo nixos-rebuild switch --rollback` um es dauerhaft
zu machen.

---

## flake.lock aktualisieren

```bash
# Alle Inputs auf neueste Version
nix flake update

# Nur einen Input updaten
nix flake lock --update-input home-manager

# Danach immer committen
git add flake.lock && git commit -m "flake: update inputs"
```

---

## Neuen Rechner einrichten

### 1 – NixOS vom USB booten

Partitionen anlegen und nach `/mnt` mounten (z.B. mit `gparted` oder `fdisk`).
Typisches Layout:

```bash
# EFI-Partition
mkfs.fat -F 32 /dev/sdXY
mount /dev/sdXY /mnt/boot

# Root-Partition
mkfs.ext4 /dev/sdXZ
mount /dev/sdXZ /mnt
```

### 2 – Hardware-Config generieren

```bash
nixos-generate-config --root /mnt
```

### 3 – Repo holen

```bash
# Mit Netz:
nix-shell -p git --run "git clone https://github.com/dein/nixconfig /mnt/home/ll/nix"

# Vom USB-Stick:
mkdir -p /mnt/home/ll
cp -r /mnt/usb/nix /mnt/home/ll/nix
```

### 4 – Host anlegen

```bash
mkdir -p /mnt/home/ll/nix/hosts/newmachine

cp /mnt/etc/nixos/hardware-configuration.nix \
   /mnt/home/ll/nix/hosts/newmachine/
```

### 5 – `hosts/newmachine/default.nix` erstellen

Nur rein was sich vom T480s unterscheidet. Alles andere kommt aus
`modules/common.nix` und `modules/desktop.nix` automatisch.

```nix
{ config, pkgs, lib, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "newmachine";

  # Beispiel AMD-Grafik:
  hardware.graphics.extraPackages = with pkgs; [ amdvlk ];
  environment.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";

  # Kein LTE-Modem → einfach weglassen
  # Desktop-Rechner, kein TLP nötig → weglassen
}
```

Für Intel (wie T480s) als Vorlage einfach `hosts/t480s/default.nix` kopieren
und hostName + ggf. Drucker-IPs anpassen.

### 6 – In `flake.nix` eintragen

```nix
nixosConfigurations = {
  t480s      = mkSystem "t480s"      "x86_64-linux";
  newmachine = mkSystem "newmachine" "x86_64-linux";  # ← neu
};
```

### 7 – Installieren

```bash
# Dateien für Nix sichtbar machen
git -C /mnt/home/ll/nix add .

nixos-install --flake /mnt/home/ll/nix#newmachine
```

Reboot. Fertig – System, Home Manager, alle dotfiles kommen aus dem Repo.

### 8 – Nach dem ersten Boot

```bash
# Hostname prüfen
hostname   # sollte "newmachine" ausgeben

# Wenn noch der alte Hostname angezeigt wird: neu einloggen oder
sudo hostname newmachine

# Ab jetzt funktioniert der Alias
rebuild
```

---

## Häufige Fehler

**`does not provide attribute nixosConfigurations."nixos"`**
Der `rebuild`-Alias nutzt `$(hostname)` – wenn der Hostname noch `nixos` ist
(vor dem ersten Switch), manuell ausführen:
```bash
sudo nixos-rebuild switch --flake .#t480s
```

**`Path 'xyz' is not tracked by Git`**
Neue Datei angelegt aber noch kein `git add`:
```bash
git add .
rebuild
```

**Build schlägt fehl, System ist noch gut**
`test` statt `switch` ändert nichts dauerhaft – einfach rebooten um
auf die letzte funktionierende Generation zurückzukommen.
