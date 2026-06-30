{ ... }:

{
  virtualisation.libvirtd = {
    enable = true;
  };

  # Beibehalten: Verhindert Routing-Probleme mit dem virtuellen Default-Netzwerk
  networking.firewall.checkReversePath = "loose";
}
