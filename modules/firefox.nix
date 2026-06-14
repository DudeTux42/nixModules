{ config, pkgs, lib, ... }:

# ════════════════════════════════════════════════════════════════
# modules/firefox.nix – System-weite Firefox-Konfiguration
#
# Policies und Extensions werden system-weit erzwungen.
# User-spezifische Einstellungen (Profile, Native Messaging)
# liegen in firefox.nix (Home Manager).
# ════════════════════════════════════════════════════════════════
{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry        = true;
      DisableFirefoxStudies   = true;
      DisablePocket           = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar          = "default-off";
      SearchBar               = "unified";

      EnableTrackingProtection = {
        Value          = true;
        Locked         = false;
        Cryptomining   = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
          installation_mode = "force_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        "yt-nonstop@eai.me" = {
          install_url       = "https://addons.mozilla.org/firefox/downloads/latest/youtube-nonstop/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
