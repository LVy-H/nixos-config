{ pkgs, lib, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      # menu = "rofi -show combi"; # Handled by bindsym

      
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
        
        # Media Control
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        
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

        # Clipboard History (with image thumbnails)
        "${modifier}+Shift+v" = "exec rofi-clipboard";
        "${modifier}+Shift+i" = "exec rofi-clipboard-images"; # Images only

        # Power Menu (wlogout)
        "${modifier}+Shift+e" = "exec wlogout";
        
        # Scratchpad
        # Scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";
        
        # Utilities
        "${modifier}+t" = "exec ocr"; # OCR On-Screen Text

        # Rofi Tools
        "${modifier}+c" = "exec rofi -show calc -modi calc -no-show-match -no-sort";
        "${modifier}+period" = "exec rofi -show emoji";

        # Layouts
        # Layouts
        "${modifier}+w" = "layout tabbed";
        "${modifier}+s" = "layout stacking";
        "${modifier}+e" = "layout toggle split";
        
        # Splits
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        
        # Manual Lock
        "${modifier}+l" = "exec swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033";

        # -- Keyboard Oriented Apps --
        "${modifier}+Shift+f" = "exec nautilus"; # Files (Shift+f)
        "${modifier}+d" = "exec rofi -show drun"; # Launcher
        "${modifier}+Shift+b" = "exec google-chrome-stable"; # Browser (Shift+b)
        "${modifier}+Shift+Escape" = "exec missioncenter"; # Task Manager
        
        # -- Window Management --
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+c" = "reload";
        
        # -- Resize Mode --
        "${modifier}+r" = "mode \"resize\"";
        
        # -- Notifications --
        "${modifier}+n" = "exec swaync-client -t -sw"; # Toggle Panel
        "${modifier}+Shift+n" = "exec swaync-client -d -sw"; # Toggle DND
        
        # -- Window Switching & Overview --
        "${modifier}+Tab" = "exec swayr switch-to-urgent-or-lru-window"; # Quick Switch (Toggle)
        "${modifier}+Shift+Tab" = "exec swayr switch-window"; # Select Window (Menu)
        "${modifier}+grave" = "exec rofi -show window"; # Toggle Overview
        "${modifier}+o" = "exec rofi -show window"; # Backup
        "${modifier}+Shift+w" = "exec rofi-wallpaper"; # Wallpaper Picker
      };

      startup = [
        # Polkit Agent
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        { command = "autotiling-rs"; }
        # swayrd is handled by systemd service
        
        # Sov (Overview) - Removed in favor of Rofi Window
        
        
        # Audio Idle Inhibit
        { command = "sway-audio-idle-inhibit"; }
      ];
      
      modes = {
        resize = {
          "h" = "resize shrink width 10px";
          "j" = "resize grow height 10px";
          "k" = "resize shrink height 10px";
          "l" = "resize grow width 10px";
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
          "Escape" = "mode \"default\"";
          "Return" = "mode \"default\"";
        };
      };

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
        {
          command = "floating enable, resize set 800 600, move position center";
          criteria = { app_id = "clipse"; };
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
      # Usability Focus
      focus_on_window_activation focus
      mouse_warping container
      popup_during_fullscreen smart
      
      # Visuals
      default_dim_inactive 0.1
      
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
