{ pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  networking.nftables.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [
      "docker0"
      "incusbr0"
      "virbr0"
      "virbr1"
      "virbr2"
    ];
    allowedTCPPorts = [
      57621 # Spotify Connect
    ];
    allowedUDPPorts = [
      5353 # mDNS / Spotify Discovery
    ];
  };

  # NAT
  networking.nat = {
    enable = true;
    externalInterface = "wlp0s20f3"; # Primary Wi-Fi
    internalInterfaces = [ "docker0" ];
  };

  networking.extraHosts = "10.171.242.4 ceph1";

  # Network tools
  environment.systemPackages = with pkgs; [
    openvpn
    networkmanager-openvpn
    wireguard-tools
    cloudflare-warp
    bluez
    bluez-tools
  ];

  services.cloudflare-warp.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
      FastConnectable = true;
      JustWorksRepairing = "always";
      MultiProfile = "multiple";
    };
    Policy = {
      AutoEnable = true;
    };
  };
  services.blueman.enable = true;
}
