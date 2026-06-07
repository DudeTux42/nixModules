#!/usr/bin/env bash
# Installiere Firefox Extensions via System-Policies
# Diese werden automatisch beim Firefox-Start installiert

set -euo pipefail

PROFILE_DIR="$HOME/.mozilla/firefox/default"
EXTENSIONS_DIR="$PROFILE_DIR/extensions"

# Stelle sicher dass das Verzeichnis existiert
mkdir -p "$EXTENSIONS_DIR"

echo "📦 Installiere Firefox Extensions..."
echo ""

# Extensions zum Installieren
declare -A EXTENSIONS=(
    ["uBlock0@raymondhill.net"]="https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
    ["addon@darkreader.org"]="https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi"
    ["tridactyl.vim@cmcaine.co.uk"]="https://addons.mozilla.org/firefox/downloads/latest/tridactyl/latest.xpi"
    ["sponsorBlocker@ajaxy"]="https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi"
    ["yt-nonstop@eai.me"]="https://addons.mozilla.org/firefox/downloads/latest/youtube-nonstop/latest.xpi"
)

for ext_id in "${!EXTENSIONS[@]}"; do
    url="${EXTENSIONS[$ext_id]}"
    filename="${ext_id}.xpi"
    
    # Prüfe ob Extension schon da ist
    if [[ -f "$EXTENSIONS_DIR/$filename" ]]; then
        echo "✓ $ext_id (bereits installiert)"
    else
        echo "🔄 Lade $ext_id herunter..."
        if curl -fsSL -o "$EXTENSIONS_DIR/$filename" "$url"; then
            echo "✓ $ext_id installiert"
        else
            echo "✗ $ext_id konnte nicht heruntergeladen werden"
        fi
    fi
done

echo ""
echo "✅ Extensions installiert!"
echo ""
echo "📝 Starte Firefox um die Extensions zu laden:"
echo "   firefox &"
