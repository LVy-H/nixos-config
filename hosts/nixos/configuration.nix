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

  ];

  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/08EF8110170932EF";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/8e58b41c-e942-407a-9bb5-64e3b8c343b2"; }
  ];

  # Performance Optimizations
  zramSwap.enable = true;
  services.fstrim.enable = true;
  
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment.variables.FLAKE = "/etc/nixos";
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/etc/nixos";
  };

  # OpenSSH
  services.openssh.enable = true;

  # Gaming
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false; # Fix login loop
  };
  
  services.tlp.enable = true;

  # Android / Mobile - ADB is handled by systemd 258+ uaccess, just need the package


  # Stylix Theming
  stylix = {
    enable = true;
    image = ./assets/background.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    opacity = {
      applications = 1.0;
      terminal = 0.9;
      desktop = 1.0;
      popups = 1.0;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    icons = {
      enable = true;
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "mauve";
        flavor = "mocha";
      };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

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
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };
  };

  system.stateVersion = "25.11";
}
