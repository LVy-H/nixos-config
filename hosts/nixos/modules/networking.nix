{ pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # Don't wait for network to be online at boot (speeds up startup significantly)
  systemd.services.NetworkManager-wait-online.enable = false;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "docker0" ];
    allowedTCPPorts = [ 
      57621 # Spotify Connect
      6443  # k3s: Kubernetes API Server
    ];
    allowedUDPPorts = [ 
      5353  # mDNS / Spotify Discovery
      8472  # k3s: Flannel VXLAN
    ];
  };

  # NAT
  networking.nat = {
    enable = true;
    externalInterface = "wlp0s20f3"; # Primary Wi-Fi
    internalInterfaces = [ "docker0" ];
  };

  # Fix MTU issues (MSS Clamping) & Allow NAT on other interfaces
  networking.firewall.extraCommands = ''
    iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    # Enable masquerading for other potential uplinks (Tethering, Warp)
    iptables -t nat -A POSTROUTING -o enp0s20f0u2 -j MASQUERADE
    iptables -t nat -A POSTROUTING -o CloudflareWARP -j MASQUERADE
  '';

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
