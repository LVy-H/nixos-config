{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = false;
  programs.virt-manager.enable = false;

  virtualisation.podman.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "8.8.8.8" "1.1.1.1" ];
      mtu = 1280;
    };
  };

  virtualisation.waydroid.enable = false;

  virtualisation.virtualbox.host.enable = false;
  
  # Kubernetes (k3s)
  services.k3s = {
    enable = false;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode 644" # Allow non-root access to kubeconfig
    ];
  };

  environment.systemPackages = with pkgs; [
    
    qemu
    OVMF
  ]; # Add distrobox if needed, though it's in home.nix usually
}
