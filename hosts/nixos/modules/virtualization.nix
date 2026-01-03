{ pkgs, ... }:

{
  programs.adb.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.podman.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.waydroid.enable = true;

  virtualisation.virtualbox.host.enable = true;

  environment.systemPackages = with pkgs; [
    genymotion
    android-studio
    android-tools
    qemu
    OVMF
  ]; # Add distrobox if needed, though it's in home.nix usually
}
