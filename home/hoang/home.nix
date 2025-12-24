{ config, pkgs, lib, ... }:

{
  imports = [
    ./programs/waybar.nix
    # ./programs/nixvim.nix
  ];

  home.username = "hoang";
  home.homeDirectory = "/home/hoang";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    pavucontrol
    discord
    google-chrome
    antigravity-fhs
    networkmanagerapplet
    gsimplecal
    wofi # <--- ADDED: Modern app launcher
    wf-recorder # <--- ADDED: Screen recorder
    libnotify # <--- ADDED: For notify-send
    wev # <--- ADDED: To debug key codes
  ];

  programs.kitty = {
    enable = true;
    font = { name = "JetBrainsMono Nerd Font"; size = 10; };
    themeFile = "Catppuccin-Macchiato";
  };

  # ADDED: Wofi Configuration
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #c6a0f6;
        background-color: #24273a;
        border-radius: 10px;
      }

      #input {
        margin: 5px;
        border: none;
        color: #cad3f5;
        background-color: #363a4f;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #24273a;
        color: #cad3f5;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #24273a;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #cad3f5;
      }

      #entry:selected {
        background-color: #c6a0f6;
        color: #24273a;
        border-radius: 5px;
      }
    '';
  };

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "wofi --show drun"; # <--- CHANGED: Use wofi instead of dmenu
      bars = []; # <--- CHANGED: Waybar is started as a systemd service
      
      keybindings = let
        modifier = "Mod4";
      in lib.mkOptionDefault {
        # Screenshot (Full Screen) -> Clipboard
        "Print" = "exec grim - | wl-copy && notify-send 'Screenshot' 'Full screen copied to clipboard'";
        
        # Screenshot (Area) -> Clipboard
        # Supports: Shift+Print, specialized hardware keys, and the Acer 'Super+Shift+S' hardware button
        "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";
        "XF86SelectiveScreenshot" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";
        "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";

        # Screen Recording (Area) -> ~/Videos. (Alt + Print to start)
        "Mod1+Print" = "exec wf-recorder -g \"$(slurp)\" -f $HOME/Videos/recording_$(date +'%Y%m%d_%H%M%S').mp4 && notify-send 'Recording' 'Started recording area'";
        
        # Stop Recording (Control + Print to stop)
        "Control+Print" = "exec pkill wf-recorder && notify-send 'Recording' 'Stopped recording'";
        "${modifier}+Shift+r" = "exec pkill wf-recorder && notify-send 'Recording' 'Stopped recording'";
      };

      startup = [
        { command = "nm-applet --indicator"; }
      ];

      floating.criteria = [
        { class = "gsimplecal"; }
        { title = "Floating Network Manager"; }
      ];

      window.commands = [
        {
          command = "floating enable, resize set 600 400, move position center";
          criteria = { title = "Floating Network Manager"; };
        }
      ];

      input."type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
      };
      output."*" = {
        bg = "/home/hoang/Downloads/Konachan.com_-_376008_sample.jpg fill";
      };
    };
  };

  programs.home-manager.enable = true;
}
