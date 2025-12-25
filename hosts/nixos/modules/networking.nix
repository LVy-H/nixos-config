{ pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 57621 ]; # Spotify Connect
    allowedUDPPorts = [ 5353 ];  # mDNS / Spotify Discovery
  };

  # Network tools
  environment.systemPackages = with pkgs; [
    openvpn
    networkmanager-openvpn
    wireguard-tools
  ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };
  services.blueman.enable = true;
}
