{ pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "rofi -show drun";
      workspaceAutoBackAndForth = true;
      bars = [];
      
      keybindings = let
        modifier = "Mod4";
      in lib.mkOptionDefault {
        # Audio Control
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        
        # Mic Volume Control (Ctrl + Volume Keys)
        "Control+XF86AudioRaiseVolume" = "exec pactl set-source-volume @DEFAULT_SOURCE@ +5%";
        "Control+XF86AudioLowerVolume" = "exec pactl set-source-volume @DEFAULT_SOURCE@ -5%";

        # Brightness Control
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

        # Screenshot (Full Screen) -> Clipboard
        "Print" = "exec grim - | wl-copy && notify-send 'Screenshot' 'Full screen copied to clipboard'";
        
        # Screenshot (Area) -> Clipboard
        "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";
        "XF86SelectiveScreenshot" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";
        "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'";

        # Screen Recording (Area) -> ~/Videos
        "Mod1+Print" = "exec wf-recorder -g \"$(slurp)\" -f $HOME/Videos/recording_$(date +'%Y%m%d_%H%M%S').mp4 && notify-send 'Recording' 'Started recording area'";
        
        # Stop Recording
        "Control+Print" = "exec pkill wf-recorder && notify-send 'Recording' 'Stopped recording'";
        "${modifier}+Shift+r" = "exec pkill wf-recorder && notify-send 'Recording' 'Stopped recording'";

        # Clipboard History (with large image previews)
        "${modifier}+v" = "exec cliphist list | cliphist-rofi-img | rofi -dmenu -show-icons -theme-str 'element-icon { size: 96px; }' -theme-str 'listview { lines: 6; }' | cliphist decode | wl-copy";

        # Manual Lock
        "${modifier}+l" = "exec swaylock -f";
      };

      startup = [
        { command = "udiskie &"; }
        { command = "nm-applet --indicator"; }
        { command = "blueman-applet"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
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
