{ config, pkgs, lib, ... }:

# ════════════════════════════════════════════════════════════════
# Lenovo ThinkPad T480s – hardware-spezifische Einstellungen
#
# Alles was NUR auf diesem Gerät gilt:
#   - Intel-Grafik (i915, VA-API)
#   - LTE-Modem (Fibocom L850-GL)
#   - Logitech-Maus
#   - TLP / thermald (Laptop-Energieverwaltung)
#   - Drucker im Büro (konkrete IP-Adressen)
# ════════════════════════════════════════════════════════════════
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/vbox.nix
  ];

  networking.hostName = "t480s";

  # ─────────────────────────────────────────
  # Intel-Kernel (i915)
  # ─────────────────────────────────────────
  boot = {
    kernelParams = [
      "i915.enable_fbc=1"   # Framebuffer Compression → weniger GPU-Watt
      "i915.enable_psr=1"   # Panel Self Refresh → weniger Display-Watt
    ];
    kernelModules = [ "qmi_wwan" "cdc_wdm" "usbnet" ]; # LTE-Modem
    initrd.availableKernelModules = [ "qmi_wwan" "cdc_wdm" ];
  };

  # ─────────────────────────────────────────
  # Intel-Hardware
  # ─────────────────────────────────────────
  hardware = {
    cpu.intel.updateMicrocode = true;

    graphics.extraPackages = with pkgs; [
      intel-media-driver      # VAAPI für Whiskey Lake (T480s)
      intel-vaapi-driver      # Fallback
      libvdpau-va-gl          # VDPAU → VA-API Bridge
      intel-compute-runtime   # OpenCL
    ];

    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;
  };

  # Intel VA-API Treiber (AMD-Rechner würde hier "radeonsi" stehen)
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # ─────────────────────────────────────────
  # LTE-Modem (Fibocom L850-GL via USB)
  # ─────────────────────────────────────────
  systemd.services.ModemManager.serviceConfig = {
    ExecStart = [ "" "${pkgs.modemmanager}/bin/ModemManager --debug" ];
    Restart = "always";
    RestartSec = "5s";
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="2cb7", ATTR{idProduct}=="0210", \
      RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 0x2cb7 -p 0x0210 -R"
  '';

  # ─────────────────────────────────────────
  # Energieverwaltung (Laptop-spezifisch)
  # ─────────────────────────────────────────
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false; # Konflikt mit TLP

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC  = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_BOOST_ON_AC  = 1;
        CPU_BOOST_ON_BAT = 0;
      };
    };
  };

  # ─────────────────────────────────────────
  # Drucker (Büro – konkrete IPs)
  #
  # browsedConf ergänzt services.printing aus desktop.nix.
  # hardware.printers legt die Dymo-Drucker dauerhaft an.
  # ─────────────────────────────────────────
  services.printing.browsedConf = ''
    BrowsePoll 192.168.1.217:631
    BrowsePoll 192.168.1.186:631
    BrowseInterval 30
    BrowseTimeout 3600
    CreateIPPPrinterQueues All
  '';

  hardware.printers = {
    ensureDefaultPrinter = "Dymo_LabelWriter_450";
    ensurePrinters = [
      {
        name      = "Dymo_LabelWriter_450";
        location  = "Office";
        deviceUri = "socket://192.168.1.186";
        model     = "lw450t.ppd";
      }
      {
        name      = "Dymo_LabelWriter_Trainee";
        location  = "Office";
        deviceUri = "socket://192.168.1.186:9100";
        model     = "lw450t.ppd";
      }
    ];
  };
}
