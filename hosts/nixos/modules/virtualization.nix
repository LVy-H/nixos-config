{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["hoang"];

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.podman.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "8.8.8.8" "1.1.1.1" ];
      mtu = 1420; # Cloudflare WARP overhead is ~80 bytes (1500 - 80 = 1420)
    };
  };


  virtualisation.waydroid.enable = false;
  
}
