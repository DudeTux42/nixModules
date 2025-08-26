{ config, pkgs, ... }:

let
  # Helper for Preferences status: Value will be locked and user cannot change it
  # (Useful for enforcing specific settings)
  locked = val: { Value = val; Status = "locked"; };

  # Helper for Preferences status: Value is default and user can change it
  # (Good for explicitly defining standard settings for future modification)
  default = val: { Value = val; Status = "default"; };
in
{
  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "de" "en-US" ];

      # Define your default profile.
      # Home Manager will create this profile if it doesn't exist,
      # and apply settings to it.
      profiles.default = {
        # ---- about:config SETTINGS ----
        # These correspond to settings you can change in about:config.
        # They are generally user-modifiable unless locked by policies.
        # I've set these to their typical *default* values where applicable,
        # so you have a base to easily change them later.
        settings = {
          # General UI & Startup
          "browser.startup.page" = 1; # 0: Blank, 1: Home, 2: Last visited, 3: Resume (standard is 1)
          "browser.startup.homepage" = "about:home"; # Standard Firefox homepage
          "browser.toolbars.bookmarks.visibility" = "never"; # Can be "always", "never", "newtab"
          "browser.tabs.warnOnClose" = true; # Warn when closing multiple tabs

          # Privacy & Security (standard defaults)
          "browser.contentblocking.category" = "standard"; # Can be "standard", "strict", "custom"
          "browser.safeBrowse.malware.enabled" = true;
          "browser.safeBrowse.phishing.enabled" = true;
          "network.cookie.cookieBehavior" = 4; # 4 for cross-site tracking protection, 3 for all cookies
          "privacy.resistFingerprinting" = false; # Standard is false (true enables more strict fingerprinting resistance)

          # Search & URL bar (standard defaults)
          "browser.search.suggest.enabled" = true;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = true;
          "browser.urlbar.showSearchSuggestionsFirst" = true;

          # New Tab Page / Activity Stream (standard defaults)
          "browser.newtabpage.activity-stream.feeds.section.topstories" = true;
          "browser.newtabpage.activity-stream.feeds.snippets" = true;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = true;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = true;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = true;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = true;
          "browser.newtabpage.activity-stream.showSponsored" = true;
          "browser.newtabpage.activity-stream.system.showSponsored" = true;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = true;

          # Other features (standard defaults)
          "extensions.pocket.enabled" = true; # Pocket integrated by default
          "extensions.screenshots.disabled" = false; # Screenshots enabled by default
          "browser.topsites.contile.enabled" = true; # Top Sites on New Tab page
          "browser.formfill.enable" = true; # Auto-fill forms
          "browser.shell.checkDefaultBrowser" = true; # Ask to set as default browser
        };
      }; # End profiles.default

      # ---- POLICIES ----
      # These settings are often used in enterprise environments to enforce specific behaviors.
      # They can override 'settings' and make certain options unchangeable by the user if "Locked" is true.
      # I've set these to their typical *default* behavior, so you can easily modify them later
      # to enforce a different value if needed.
      policies = {
        # General Policies (default behavior)
        DisableTelemetry = false; # Standard ist false (Telemetrie aktiviert)
        DisableFirefoxStudies = false; # Standard ist false (Studies aktiviert)
        DisablePocket = false; # Standard ist false (Pocket ist aktiviert)
        DisableFirefoxAccounts = false; # Standard ist false (Firefox Accounts aktiviert)
        DisableAccounts = false; # Standard ist false (Accounts aktiviert)
        DisableFirefoxScreenshots = false; # Standard ist false (Screenshots aktiviert)
        DontCheckDefaultBrowser = false; # Standard ist false (Firefox fragt, ob es Standardbrowser sein soll)

        # UI Policies (default behavior, or what's typically "standard")
        OverrideFirstRunPage = ""; # Standard ist leer
        OverridePostUpdatePage = ""; # Standard ist leer
        DisplayBookmarksToolbar = "never"; # "never" is a common default for the toolbar's initial state
        DisplayMenuBar = "default-off"; # Typically off by default, toggleable by user
        SearchBar = "unified"; # Modern Firefox default is a unified search bar in the URL bar

        # Tracking Protection Policy (set to default behavior)
        # If you want to use the 'strict' content blocking you had before,
        # you would change Value = true; Locked = true; for Cryptomining/Fingerprinting.
        EnableTrackingProtection = {
          Value = true; # Standard is true (basic protection enabled)
          Locked = false; # User can change the level
          Cryptomining = false; # Standard is false
          Fingerprinting = false; # Standard is false
        };

        # ---- EXTENSIONS via Policies (your preferred method) ----
        # This section forces the installation of specific add-ons using their internal IDs.
        # This is robust if the add-ons are not in Nixpkgs or you need `force_installed`.
        # You correctly have the internal IDs and install_urls here.
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed"; # User cannot disable/remove
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # 1Password:
          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          # You can add Dark Reader here if you know its addon ID and install_url.
          # Example (replace with actual ID and URL):
          # "{darkreader-addon-id@mozilla.org}" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          #   installation_mode = "force_installed";
          # };
        };
      }; # End policies
    }; # End programs.firefox
  }; # End programs
}
