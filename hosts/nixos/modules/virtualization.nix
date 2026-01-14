{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.podman.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.waydroid.enable = true;

  virtualisation.virtualbox.host.enable = true;
  
  # Kubernetes (k3s)
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode 644" # Allow non-root access to kubeconfig
    ];
  };

  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    qemu
    OVMF
  ]; # Add distrobox if needed, though it's in home.nix usually
}
