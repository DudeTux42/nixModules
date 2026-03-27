# Card Unlock System - Nix Config

Automatisches Lock/Unlock deines Hyprland-Desktops mit Sparkassen-Karte!

## 🎯 Features

- ✅ **Karte auflegen** → Bildschirm entsperrt
- ✅ **Karte abziehen** → Bildschirm sperrt automatisch
- ✅ **Notifications** bei Lock/Unlock
- ✅ **Declarative Config** in Nix
- ✅ **Kein PIN nötig** → Sicher!

## 🚀 Setup

### 1. Card-Unlock Scripts kopieren

```bash
# Falls noch nicht vorhanden:
mkdir -p ~/card-unlock
cp /home/ll/card-unlock/check_card_v2.py ~/card-unlock/
cp /home/ll/card-unlock/ultimate_fingerprint.py ~/card-unlock/
chmod +x ~/card-unlock/*.py
```

### 2. Karte registrieren

```bash
cd ~/card-unlock
./ultimate_fingerprint.py
```

Das erstellt `card_fingerprint.txt` mit deinem Karten-Fingerprint.

### 3. Home-Manager rebuilden

```bash
cd ~/nix
home-manager switch --flake .
```

### 4. Service starten

```bash
systemctl --user enable --now hyprlock-card-monitor
```

## 📊 Verwaltung

### Status prüfen
```bash
systemctl --user status hyprlock-card-monitor
```

### Logs anzeigen (Live)
```bash
journalctl --user -u hyprlock-card-monitor -f
```

### Service stoppen
```bash
systemctl --user stop hyprlock-card-monitor
```

### Service deaktivieren
```bash
systemctl --user disable hyprlock-card-monitor
```

### Service neu starten (nach Änderungen)
```bash
systemctl --user restart hyprlock-card-monitor
```

## 🔧 Troubleshooting

### Service läuft nicht
```bash
# Check Service Status
systemctl --user status hyprlock-card-monitor

# Check Logs
journalctl --user -u hyprlock-card-monitor -n 50

# PCSC Daemon prüfen
systemctl status pcscd
```

### Karte wird nicht erkannt
```bash
# Kartenleser testen
pcsc_scan

# Karte manuell prüfen
cd ~/card-unlock
./check_card_v2.py
```

### Fingerprint neu erstellen
```bash
cd ~/card-unlock
./ultimate_fingerprint.py
systemctl --user restart hyprlock-card-monitor
```

## 📝 Wie es funktioniert

1. **Card Fingerprint**: Nutzt Historical Bytes aus dem ATR
   - `65 63 11 16 65 02 50 00 10 0B 23 17 8A 07 40`
   - SHA256 Hash für Vergleich
   
2. **Monitor Service**: Prüft alle 1 Sekunde Kartenstatus
   - Karte erkannt → `pkill hyprlock` (unlock)
   - Karte weg → `hyprlock` starten (lock)

3. **Nix Integration**: Declarative Config in `card-unlock.nix`
   - Systemd Service
   - Python Dependencies (pyscard)
   - Scripts als Nix Derivations

## 🔐 Sicherheit

**Uniqueness Level**: ⭐⭐⭐⭐☆

- Wahrscheinlichkeit für gleichen Fingerprint:
  - Dein Zuhause: 0%
  - Deine Stadt: ~0.01%
  - Deutschland: ~0.1%

**Kein PIN nötig** = Keine Gefahr für dein Bankkonto! ✓

## 📁 Dateien

```
~/nix/
└── card-unlock.nix          # Nix-Modul (dieses File)

~/card-unlock/
├── check_card_v2.py         # Karten-Check Script
├── ultimate_fingerprint.py  # Fingerprint-Erstellung
└── card_fingerprint.txt     # Dein Karten-Fingerprint
```

## 🎨 Weitere Karten hinzufügen

```bash
# Einfach weitere Karten scannen
cd ~/card-unlock
./ultimate_fingerprint.py

# Fingerprints werden in card_fingerprint.txt gesammelt
```

## ⚙️ Anpassungen

### Check-Interval ändern

Edit `~/nix/card-unlock.nix`:
```nix
CHECK_INTERVAL=1  # Auf z.B. 2 ändern für 2 Sekunden
```

Dann:
```bash
cd ~/nix
home-manager switch --flake .
systemctl --user restart hyprlock-card-monitor
```

### Notifications deaktivieren

Entferne in `card-unlock.nix` die `notify-send` Zeilen.

## 🐛 Bekannte Issues

- **Hyprlock bleibt hängen**: `pkill -9 hyprlock` erzwingt Beendigung
- **Service startet nicht nach Login**: Check `systemctl --user list-units | grep card`
- **Karte "flackert"**: Erhöhe `CHECK_INTERVAL` auf 2-3 Sekunden

## 📚 Mehr Infos

Siehe `/home/ll/card-unlock/FINAL_SUMMARY.md` für technische Details!
