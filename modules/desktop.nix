{ config, pkgs, lib, ... }:

# ════════════════════════════════════════════════════════════════
# desktop.nix – grafischer Desktop-Stack
#
# Enthält: Wayland, Plasma 6, Hyprland, Pipewire, SDDM,
#          Avahi, Drucker-Basis, XDG-Portals
#
# Was NICHT hier ist:
#   - GPU-spezifische extraPackages → hosts/<name>/default.nix
#   - LIBVA_DRIVER_NAME             → hosts/<name>/default.nix
#   - browsedConf / hardware.printers → hosts/<name>/default.nix
# ════════════════════════════════════════════════════════════════
{
  # ─────────────────────────────────────────
  # Grafik (Basis)
  # ─────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # extraPackages kommt aus dem Host (Intel / AMD / Nvidia)
  };

  # ─────────────────────────────────────────
  # Display Manager & Desktop
  # ─────────────────────────────────────────
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
      xkb = {
        layout  = "de";
        variant = "";
        options = "caps:swapescape";
      };
    };

    displayManager = {
      sddm = {
        enable          = true;
        wayland.enable  = true;
      };
      defaultSession = "plasma";
    };

    desktopManager.plasma6.enable = true;

    # ─────────────────────────────────────────
    # Audio
    # ─────────────────────────────────────────
    pulseaudio.enable = false; # Pipewire übernimmt

    pipewire = {
      enable            = lib.mkForce true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
      jack.enable       = true;
      wireplumber.enable = true;
    };

    # ─────────────────────────────────────────
    # Drucker (Basis – IPs kommen aus dem Host)
    # ─────────────────────────────────────────
    printing = {
      enable          = true;
      browsing        = true;
      listenAddresses = [ "localhost:631" ];
      allowFrom       = [ "localhost" "192.168.1.*" "192.168.151.*" ];
      defaultShared   = true;
      drivers         = with pkgs; [ gutenprint hplip cups-dymo ];
      # browsedConf kommt aus hosts/<name>/default.nix
    };

    # ─────────────────────────────────────────
    # Netzwerk-Discovery
    # ─────────────────────────────────────────
    avahi = {
      enable    = true;
      nssmdns4  = true;
      openFirewall = true;
    };

    blueman.enable = true;
  };

  # ─────────────────────────────────────────
  # Programme (Desktop)
  # ─────────────────────────────────────────
  programs.hyprland.enable = true;

  # ─────────────────────────────────────────
  # XDG Portals (Wayland file-picker etc.)
  # ─────────────────────────────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # ─────────────────────────────────────────
  # Wayland / Session-Variablen
  # ─────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron-Apps nativ Wayland
    # LIBVA_DRIVER_NAME kommt aus dem Host
  };
}
