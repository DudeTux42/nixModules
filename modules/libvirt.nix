{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  # Wichtig für das Default-Netzwerk (NAT/DHCP via dnsmasq) unter NixOS
  networking.firewall.checkReversePath = "loose";
}
