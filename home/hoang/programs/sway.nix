{ pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "rofi -show combi";
      
      assigns = {
        "9" = [{ class = "Spotify"; }];
        "8" = [{ class = "discord"; } { class = "WebCord"; }];
      };
      workspaceAutoBackAndForth = true;
      bars = [];
      
      keybindings = let
        modifier = "Mod4";
      in lib.mkOptionDefault {
        # Audio Control
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";
        
        # Mic Volume Control (Ctrl + Volume Keys)
        "Control+XF86AudioRaiseVolume" = "exec swayosd-client --input-volume raise";
        "Control+XF86AudioLowerVolume" = "exec swayosd-client --input-volume lower";

        # Brightness Control
        "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";

        # Screenshot (Full Screen) -> Clipboard
        "Print" = "exec grim - | wl-copy && notify-send 'Screenshot' 'Full screen copied to clipboard'";
        
        # Screenshot (Area) -> Clipboard
        "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";
        "${modifier}+Shift+p" = "exec grim -g \"$(slurp)\" - | swappy -f -"; # Edit Screenshot
        "XF86SelectiveScreenshot" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";
        "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";

        # Screen Recording (Area) -> ~/Videos
        "Mod1+Print" = "exec wf-recorder -g \"$(slurp)\" -f $HOME/Videos/recording_$(date +'%Y%m%d_%H%M%S').mp4 && notify-send 'Recording' 'Started recording area'";
        
        # Stop Recording
        "Control+Print" = "exec pkill wf-recorder && notify-send 'Recording' 'Stopped recording'";
        "${modifier}+Shift+r" = "exec pkill wf-recorder && notify-send 'Recording' 'Stopped recording'";

        # Clipboard History (with large image previews)
        # Clipboard History
        "${modifier}+v" = "exec cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy";

        # Power Menu (wlogout)
        "${modifier}+Shift+e" = "exec wlogout";
        
        # Scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        # Rofi Tools
        "${modifier}+c" = "exec rofi -show calc -modi calc -no-show-match -no-sort";
        "${modifier}+period" = "exec rofi -show emoji";

        # Layouts
        "${modifier}+w" = "layout tabbed";
        "${modifier}+s" = "layout stacking";
        "${modifier}+e" = "layout toggle split";
        
        # Manual Lock
        "${modifier}+l" = "exec swaylock -f";
      };

      startup = [
        # Polkit Agent (Manual start required for Wayland usually)
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "autotiling-rs"; }
      ];

      floating.criteria = [
        { class = "gsimplecal"; }
        { title = "Floating Network Manager"; }
        { app_id = "blueman-manager"; }
        { app_id = ".blueman-manager-wrapped"; }
        { class = ".blueman-manager-wrapped"; }
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

      # Window borders
      window.border = 0; # Handled via extraConfig for precision
      window.titlebar = false;
    };
    
    extraConfig = ''
      default_border pixel 2
      default_floating_border pixel 2
      
      # Gestures
      bindgesture swipe:3:right workspace prev
      bindgesture swipe:3:left workspace next
      bindgesture swipe:3:up focus up
      bindgesture swipe:3:down focus down

      # SwayFX Visuals
      corner_radius 6
      shadows enable
      shadow_blur_radius 10
      shadow_color #00000080
      
      # Blur
      blur enable
      blur_passes 2
      blur_radius 3
      layer_effects "waybar" blur enable
      layer_effects "waybar" shadows enable
    '';
  };
}
