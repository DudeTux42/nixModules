#!/usr/bin/env bash
# Migrate Firefox bookmarks from old profile to new one
# Usage: ./firefox-migrate-bookmarks.sh

set -euo pipefail

FIREFOX_DIR="$HOME/.config/mozilla/firefox"
OLD_PROFILE_DIR="$FIREFOX_DIR/default"

# Find the newest default profile created by Home Manager
NEW_PROFILE_DIR=$(ls -td "$FIREFOX_DIR"/*/ 2>/dev/null | head -1 | sed 's:/$::')

if [[ ! -d "$OLD_PROFILE_DIR" ]]; then
    echo "❌ Old Firefox profile not found at $OLD_PROFILE_DIR"
    exit 1
fi

if [[ ! -d "$NEW_PROFILE_DIR" ]]; then
    echo "❌ No Firefox profile found in $FIREFOX_DIR"
    exit 1
fi

if [[ "$OLD_PROFILE_DIR" == "$NEW_PROFILE_DIR" ]]; then
    echo "✓ Already on same profile, no migration needed"
    exit 0
fi

echo "🔄 Firefox Bookmark Migration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Old profile: $OLD_PROFILE_DIR"
echo "New profile: $NEW_PROFILE_DIR"
echo ""

# Firefox must be closed
if pgrep -x firefox >/dev/null; then
    echo "⚠️  Firefox is running. Please close it first."
    exit 1
fi

# Backup old places.sqlite
if [[ -f "$OLD_PROFILE_DIR/places.sqlite" ]]; then
    cp "$OLD_PROFILE_DIR/places.sqlite" "$OLD_PROFILE_DIR/places.sqlite.backup"
    echo "✓ Backed up old places.sqlite"
fi

# Backup new places.sqlite
if [[ -f "$NEW_PROFILE_DIR/places.sqlite" ]]; then
    cp "$NEW_PROFILE_DIR/places.sqlite" "$NEW_PROFILE_DIR/places.sqlite.backup"
    echo "✓ Backed up new places.sqlite"
fi

# Copy bookmarks from old to new
if [[ -f "$OLD_PROFILE_DIR/places.sqlite" ]]; then
    cp "$OLD_PROFILE_DIR/places.sqlite" "$NEW_PROFILE_DIR/places.sqlite"
    echo "✓ Restored bookmarks from old profile"
fi

# Copy bookmark backups
if [[ -d "$OLD_PROFILE_DIR/bookmarkbackups" ]]; then
    mkdir -p "$NEW_PROFILE_DIR/bookmarkbackups"
    cp "$OLD_PROFILE_DIR/bookmarkbackups"/*.jsonlz4 "$NEW_PROFILE_DIR/bookmarkbackups/" 2>/dev/null || true
    echo "✓ Copied bookmark backups"
fi

# Optionally copy extension state
if [[ -f "$OLD_PROFILE_DIR/extensions.json" ]]; then
    cp "$OLD_PROFILE_DIR/extensions.json" "$NEW_PROFILE_DIR/extensions.json.old"
    echo "✓ Backed up old extensions.json for reference"
fi

echo ""
echo "✅ Migration complete!"
echo ""
echo "📝 Notes:"
echo "  - New extensions from nix config are auto-managed"
echo "  - Your bookmarks should now be visible in Firefox"
echo "  - Open Firefox to verify everything is working"
