{ config, pkgs, lib, ... }:

# ════════════════════════════════════════════════════════════════
# firefox.nix – Home Manager Firefox-Konfiguration
#
# User-spezifische Einstellungen: Sprache, Native Messaging.
# System-weite Policies und Extensions → modules/firefox.nix
# ════════════════════════════════════════════════════════════════
{
  programs.firefox = {
    enable       = true;
    languagePacks = [ "de" "en-US" ];
    configPath    = ".mozilla/firefox";
  };

  # Tridactyl native messaging host
  home.file.".mozilla/native-messaging-hosts/tridactyl.json".text =
    builtins.toJSON {
      name        = "tridactyl";
      description = "Tridactyl native command handler";
      path        = "${pkgs.tridactyl-native}/bin/native_main";
      type        = "stdio";
      allowed_extensions = [
        "tridactyl.vim@cmcaine.co.uk"
        "tridactyl.vim.betas@cmcaine.co.uk"
        "tridactyl.vim.betas.nonewtab@cmcaine.co.uk"
      ];
    };
}
