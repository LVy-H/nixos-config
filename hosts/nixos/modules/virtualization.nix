{ pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.podman.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    OVMF
  ]; # Add distrobox if needed, though it's in home.nix usually
}
