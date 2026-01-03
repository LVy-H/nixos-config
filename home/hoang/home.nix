{ config, pkgs, lib, inputs, ... }:

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

    sessionVariables = {
      ANDROID_HOME = "$HOME/Android/Sdk";
      ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    };

    sessionPath = [
      "$HOME/Android/Sdk/platform-tools"
      "$HOME/Android/Sdk/tools/bin"
    ];
  };

  # User Packages
  home.packages = with pkgs; [
    inputs.foldermanager.packages.${pkgs.stdenv.hostPlatform.system}.default
    # GUI Apps
    google-chrome
    firefox
    discord
    spotify         # Music Player
    telegram-desktop
    burpsuite
    obsidian
    pavucontrol
    gsimplecal
    networkmanagerapplet
    
    # Utilities
    playerctl       # Media controller
    antigravity-fhs
    vscode-fhs
    libnotify       # Notifications
    wev             # Input debugging
    btop            # System monitor
    brightnessctl   # Screen brightness control
    libinput        # Input debugging tools
    pulseaudio      # Provides pactl for volume control
    ncdu            # Disk usage analyzer
    
    # Modern CLI Tools
    distrobox       # Container tool
    nodejs_22
    corepack_22
    dust            # dust (better du)
    duf             # duf (better df)
    procs           # procs (better ps)
    yazi            # Terminal file manager
    fastfetch       # System info
    zellij          # Terminal multiplexer
    tmux            # Terminal multiplexer
    glow            # Markdown reader
    eza             # Modern ls replacement
    manix           # Nix documentation searcher

    # Cloud
    (azure-cli.withExtensions [ azure-cli-extensions.ssh ])

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
    grim            # Screenshot tool
    slurp           # Region selector
    
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
