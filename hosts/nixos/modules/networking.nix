{ pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      57621 # Spotify Connect
      6443  # k3s: Kubernetes API Server
    ];
    allowedUDPPorts = [ 
      5353  # mDNS / Spotify Discovery
      8472  # k3s: Flannel VXLAN
    ];
  };

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
  
  # Fix for Intel Bluetooth/WiFi coexistence
  boot.extraModprobeConfig = ''
    options iwlwifi bt_coex_active=0
  '';
}
