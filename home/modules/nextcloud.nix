{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nextcloud-client
  ];

  # Systemd service für Nextcloud mit inhibit (läuft auch bei Lock)
  systemd.user.services.nextcloud-client = {
    Unit = {
      Description = "Nextcloud Client";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      Restart = "on-failure";
      # Verhindert Pausierung bei Lock/Sleep
      Type = "simple";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Entferne exec-once aus Hyprland (wird jetzt via systemd gestartet)
  wayland.windowManager.hyprland.settings = {
    exec-once = [ ];
  };
}
