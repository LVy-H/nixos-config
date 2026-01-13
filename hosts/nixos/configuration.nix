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
    ./modules/nvidia.nix
  ];

  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/08EF8110170932EF";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/8e58b41c-e942-407a-9bb5-64e3b8c343b2"; }
  ];

  # OpenSSH
  services.openssh.enable = true;

  # Stylix Theming
  stylix = {
    enable = true;
    image = ./assets/background.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
    };
  };

  system.stateVersion = "25.11";
}