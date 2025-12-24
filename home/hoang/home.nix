{ config, pkgs, lib, ... }:

{
  imports = [
    # Program configurations
    ./programs/waybar.nix
    ./programs/rofi.nix
    ./programs/kitty.nix
    ./programs/sway.nix
    ./programs/lock.nix
    ./programs/theme.nix
    ./programs/shell.nix
    ./programs/git.nix
    ./programs/mako.nix
    ./programs/nixvim.nix
    ./programs/yazi.nix
    ./programs/zellij.nix
  ];

  home = {
    username = "hoang";
    homeDirectory = "/home/hoang";
    stateVersion = "25.11";
  };

  # User Packages
  home.packages = with pkgs; [
    # GUI Apps
    google-chrome
    discord
    pavucontrol
    gsimplecal
    networkmanagerapplet
    
    # Utilities
    antigravity-fhs
    libnotify       # Notifications
    wev             # Input debugging
    btop            # System monitor
    brightnessctl   # Screen brightness control
    libinput        # Input debugging tools
    pulseaudio      # Provides pactl for volume control
    ncdu            # Disk usage analyzer
    
    # Modern CLI Tools
    dust            # dust (better du)
    duf             # duf (better df)
    procs           # procs (better ps)
    yazi            # Terminal file manager
    fastfetch       # System info
    zellij          # Terminal multiplexer
    glow            # Markdown reader

    # Archives
    zip
    xz
    unzip
    p7zip
    ouch            # Modern all-in-one archiver
    
    # JSON/YAML Tools
    jq
    yq-go
    
    # Clipboard & Recording
    cliphist        # Clipboard manager
    wl-clipboard    # Clipboard utils
    wf-recorder     # Screen recorder
    
    # Fonts
    font-awesome    # Icon font for Waybar
  ];

  # Services
  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  programs.home-manager.enable = true;
}