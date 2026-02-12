{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./programs/waybar.nix
    ./programs/sway.nix
    ./programs/nixvim.nix
    ./programs/shell.nix
    ./programs/rofi.nix
    ./programs/services.nix
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

  # --- Core Programs ---

  programs.home-manager.enable = true;
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  programs.wardex = { enable = true; settings.paths.workspace = "/mnt/Data/Workspace"; };

  # --- Packages ---

  home.packages = with pkgs; [
    # Sway Tools
    swappy autotiling-rs wdisplays swaybg

    # GUI Apps
    nautilus mission-center easyeffects
    google-chrome firefox discord spotify telegram-desktop obsidian
    pavucontrol

    # Utils
    playerctl antigravity-fhs libnotify wev btop brightnessctl
    libinput pulseaudio ncdu scrcpy sway-audio-idle-inhibit
    (pkgs.tesseract.override { enableLanguages = [ "eng" "vie" "chi_sim" "chi_tra" "jpn" ]; })
    imagemagick

    # CLI
    distrobox boxbuddy gemini-cli dust duf procs fastfetch glow
    zip xz unzip p7zip ouch
    jq yq-go
    wl-clipboard wf-recorder grim slurp
    polkit_gnome font-awesome
    (azure-cli.withExtensions [ azure-cli-extensions.ssh ])
  ];
}
