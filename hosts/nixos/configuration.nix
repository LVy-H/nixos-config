{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware-tweaks.nix
    
    # Custom Modules
    ./modules/core.nix
    ./modules/networking.nix
    ./modules/desktop.nix
    ./modules/virtualization.nix
    ./modules/user.nix
    ./modules/theme.nix
    ./modules/gaming.nix
  ];

  environment.variables.FLAKE = "/etc/nixos";
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/etc/nixos";
  };

  # OpenSSH
  services.openssh.enable = true;

  # Android / Mobile - ADB is handled by systemd 258+ uaccess, just need the package

  system.stateVersion = "25.11";
}