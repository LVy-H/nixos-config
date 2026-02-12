{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = false;
  programs.virt-manager.enable = false;

  virtualisation.podman.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "8.8.8.8" "1.1.1.1" ];
      mtu = 1420; # Cloudflare WARP overhead is ~80 bytes (1500 - 80 = 1420)
    };
  };

  virtualisation.waydroid.enable = false;

  virtualisation.virtualbox.host.enable = false;
  
  environment.systemPackages = with pkgs; [
    qemu
    OVMF
  ];
}
