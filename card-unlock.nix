{ config, pkgs, lib, ... }:

let
  cardUnlockDir = "/home/ll/card-unlock";
  
  # Card Check Script
  checkCardScript = pkgs.writeShellScript "check-card.sh" ''
    #!${pkgs.bash}/bin/bash
    ${cardUnlockDir}/check_card_v2.py
  '';
  
  # Hyprlock Monitor Script
  hyprlockMonitorScript = pkgs.writeShellScript "hyprlock-card-monitor.sh" ''
    #!${pkgs.bash}/bin/bash
    
    CARD_CHECK="${checkCardScript}"
    CHECK_INTERVAL=1
    LOCKED=false
    
    echo "🔐 Hyprlock Card Monitor gestartet"
    echo "   Karte auflegen = Unlock"
    echo "   Karte entfernen = Lock"
    
    # Initiale Prüfung
    if "$CARD_CHECK" >/dev/null 2>&1; then
      echo "✓ Autorisierte Karte erkannt"
      LOCKED=false
    else
      echo "⚠ Keine Karte - Sperre Bildschirm"
      ${pkgs.hyprlock}/bin/hyprlock &
      LOCKED=true
    fi
    
    # Monitoring Loop
    while true; do
      sleep $CHECK_INTERVAL
      
      if "$CARD_CHECK" >/dev/null 2>&1; then
        # Karte ist da
        if [ "$LOCKED" = true ]; then
          echo "$(date '+%H:%M:%S') 🔓 Karte erkannt - Entsperre!"
          
          # Hyprlock beenden
          ${pkgs.procps}/bin/pkill -9 hyprlock 2>/dev/null || true
          
          # Notification
          ${pkgs.libnotify}/bin/notify-send -u low "🔓 Unlocked" "Sparkassen-Karte erkannt" 2>/dev/null || true
          
          LOCKED=false
        fi
      else
        # Keine Karte
        if [ "$LOCKED" = false ]; then
          echo "$(date '+%H:%M:%S') 🔒 Karte entfernt - Sperre!"
          
          # Hyprlock starten
          ${pkgs.hyprlock}/bin/hyprlock &
          
          # Notification
          ${pkgs.libnotify}/bin/notify-send -u critical "🔒 Locked" "Karte entfernt" 2>/dev/null || true
          
          LOCKED=true
        fi
      fi
    done
  '';
  
in {
  # Systemd Service für Card Monitor
  systemd.user.services.hyprlock-card-monitor = {
    Unit = {
      Description = "Hyprlock Card Monitor - Auto Lock/Unlock mit Sparkassen-Karte";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${hyprlockMonitorScript}";
      Restart = "always";
      RestartSec = 3;
    };
    
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  
  # Python packages für Card-Check
  home.packages = with pkgs; [
    python3Packages.pyscard
    pcsclite
    pcsc-tools
    libnotify  # Für Notifications
  ];
  
  # Info-Message beim rebuild
  home.activation.cardUnlockInfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo ""
    echo "🔐 Card Unlock System konfiguriert!"
    echo ""
    echo "Setup:"
    echo "  1. Karte registrieren:"
    echo "     cd ${cardUnlockDir}"
    echo "     ./ultimate_fingerprint.py"
    echo ""
    echo "  2. Service aktivieren:"
    echo "     systemctl --user enable --now hyprlock-card-monitor"
    echo ""
    echo "  3. Logs anzeigen:"
    echo "     journalctl --user -u hyprlock-card-monitor -f"
    echo ""
    echo "  4. Status prüfen:"
    echo "     systemctl --user status hyprlock-card-monitor"
    echo ""
  '';
}
