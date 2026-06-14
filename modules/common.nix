{ config, pkgs, lib, ... }:

# ════════════════════════════════════════════════════════════════
# common.nix – gilt auf JEDEM Rechner
#
# Enthält: Bootloader, Locale, User, Shell, Pakete,
#          Virtualisierung, Nix-Settings, Security, Services
#          die nicht vom Desktop-Stack abhängen.
# ════════════════════════════════════════════════════════════════
{
  # ─────────────────────────────────────────
  # Boot
  # ─────────────────────────────────────────
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    binfmt.emulatedSystems = [ "aarch64-linux" ]; # Cross-Compile für ARM
  };

  # ─────────────────────────────────────────
  # Hardware (Basis)
  # ─────────────────────────────────────────
  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    alsa.enable = true;
  };

  # ─────────────────────────────────────────
  # Netzwerk
  # ─────────────────────────────────────────
  networking = {
    # hostName kommt aus hosts/<name>/default.nix
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    firewall = {
      allowedTCPPorts = [ 631 ]; # CUPS
      allowedUDPPorts = [ 631 ];
    };
  };

  # ─────────────────────────────────────────
  # Lokalisierung
  # ─────────────────────────────────────────
  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT    = "de_DE.UTF-8";
      LC_MONETARY       = "de_DE.UTF-8";
      LC_NAME           = "de_DE.UTF-8";
      LC_NUMERIC        = "de_DE.UTF-8";
      LC_PAPER          = "de_DE.UTF-8";
      LC_TELEPHONE      = "de_DE.UTF-8";
      LC_TIME           = "de_DE.UTF-8";
    };
  };

  console.keyMap = "de";

  # ─────────────────────────────────────────
  # User
  # ─────────────────────────────────────────
  users = {
    defaultUserShell = pkgs.zsh;
    users.ll = {
      isNormalUser = true;
      description  = "ll";
      home         = "/home/ll";
      extraGroups  = [
        "networkmanager" "wheel" "audio" "video"
        "input" "seat" "docker" "libvirtd"
      ];
      packages = with pkgs; [ kdePackages.kate ];
    };
  };

  system.userActivationScripts.zshrc = "touch .zshrc";

  # ─────────────────────────────────────────
  # Security
  # ─────────────────────────────────────────
  security = {
    rtkit.enable  = true;
    polkit.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  # ─────────────────────────────────────────
  # Shell & Tools
  # ─────────────────────────────────────────
  programs = {
    direnv.enable            = true;
    direnv.nix-direnv.enable = true;
    # firefox.enable           = true;
    virt-manager.enable      = true;
    ssh.startAgent           = false; # gnome-keyring übernimmt

    zsh = {
      enable              = true;
      enableCompletion    = true;
      enableBashCompletion = true;
      autosuggestions.enable    = true;
      syntaxHighlighting.enable = true;
      histSize   = 10000;
      setOptions = [ "AUTO_CD" ];

      shellAliases = {
        ll      = "lsd -la";
        la      = "lsd -a";
        ls      = "lsd";
        cat     = "bat";
        rebuild = "sudo nixos-rebuild switch --flake /home/ll/nix#$(hostname)";
        update  = "cd /home/ll/nix && nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)";
      };

      promptInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';

      ohMyZsh = {
        enable  = true;
        plugins = [ "git" "dirhistory" "history" ];
      };
    };
  };

  environment.shells = with pkgs; [ zsh ];

  # ─────────────────────────────────────────
  # Virtualisierung
  # ─────────────────────────────────────────
  virtualisation = {
    docker.enable  = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # ─────────────────────────────────────────
  # Services
  # ─────────────────────────────────────────
  services = {
    pcscd.enable   = true;
    flatpak.enable = true;
    tailscale.enable = true;
    fwupd.enable     = true;
    hardware.bolt.enable = true; # Thunderbolt
    seatd.enable = false;
  };

  # ─────────────────────────────────────────
  # Nix
  # ─────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
  powerManagement.enable = true;

  # ─────────────────────────────────────────
  # System-Pakete
  # ─────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # System & Utilities
    git home-manager curl wget file wl-clipboard xclip fzf gnupg
    lshw lsd bat tree-sitter fastfetch nerdfetch unzip ripgrep fd
    superfile tmux bottom ouch

    # Netzwerk & VPN
    wg-netmanager wireguard-tools modemmanager
    networkmanagerapplet gnome-keyring libsecret
    tailscale zenmap polkit_gnome

    # Hardware & Diagnose
    usbutils pciutils mesa-demos libva-utils intel-gpu-tools solaar

    # Disk & Boot
    woeusb gparted

    # Tauri-Dependencies
    webkitgtk_4_1 gtk3 glib glib-networking cairo pango atk gdk-pixbuf
    librsvg libappindicator-gtk3 libdbusmenu-gtk3 libsoup_3
    pkg-config openssl xdotool ydotool

    # Entwicklung – Sprachen & Toolchains
    gcc gnumake cmake python3 python313Packages.pip nodejs
    rustc cargo rustup rustfmt clippy dioxus-cli wasm-bindgen-cli
    pwgen mise up

    # Entwicklung – Tools
    lazygit zed-editor binsider bandwhich github-copilot-cli
    jq swaks subversion unstable.lazyssh

    # LaTeX & Dokumentation
    texlive.combined.scheme-full sioyek

    # Produktivität
    notesnook pay-respects caligula teams-for-linux zsh-powerlevel10k
    libreoffice anytype logseq

    # Sicherheit & Auth
    pam_u2f yubico-pam keepass

    # Audio / Multimedia
    alsa-utils pipewire wireplumber pavucontrol
    gimp flameshot inkscape grim slurp swappy

    # Browser & Kommunikation
    chromium qutebrowser discord telegram-desktop aerc

    # Bluetooth
    blueman bluez

    # Spiele
    assaultcube luanti

    # Man-Page: man nixos-config
    (pkgs.runCommand "nixos-config-man" {} ''
      mkdir -p $out/share/man/man1
      cp ${../nixos-config.1} $out/share/man/man1/nixos-config.1
      ${pkgs.gzip}/bin/gzip $out/share/man/man1/nixos-config.1
    '')
  ];

  # ─────────────────────────────────────────
  # Firefox Policies (system-weit)
  # ─────────────────────────────────────────
  # environment.etc."firefox/policies/policies.json" = lib.mkForce {
  #   text = builtins.toJSON {
  #     policies = {
  #       DisableTelemetry        = true;
  #       DisableFirefoxStudies   = true;
  #       DisablePocket           = true;
  #       DisableFirefoxAccounts  = false;
  #       DisableAccounts         = false;
  #       DisableFirefoxScreenshots = false;
  #       DontCheckDefaultBrowser = true;
  #       DisplayBookmarksToolbar = "always";
  #       DisplayMenuBar          = "default-off";
  #       SearchBar               = "unified";
  #
  #       EnableTrackingProtection = {
  #         Value         = true;
  #         Locked        = false;
  #         Cryptomining  = true;
  #         Fingerprinting = true;
  #       };
  #
  #       ExtensionSettings = {
  #         "uBlock0@raymondhill.net" = {
  #           install_url       = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
  #           installation_mode = "force_installed";
  #         };
  #         "addon@darkreader.org" = {
  #           install_url       = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
  #           installation_mode = "force_installed";
  #         };
  #         "tridactyl.vim@cmcaine.co.uk" = {
  #           install_url       = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl/latest.xpi";
  #           installation_mode = "force_installed";
  #         };
  #         "sponsorBlocker@ajaxy" = {
  #           install_url       = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
  #           installation_mode = "force_installed";
  #         };
  #         "yt-nonstop@eai.me" = {
  #           install_url       = "https://addons.mozilla.org/firefox/downloads/latest/youtube-nonstop/latest.xpi";
  #           installation_mode = "force_installed";
  #         };
  #       };
  #     };
  #   };
  # };

  # ─────────────────────────────────────────
  # State Version
  # ─────────────────────────────────────────
  system.stateVersion = "25.05";
}
