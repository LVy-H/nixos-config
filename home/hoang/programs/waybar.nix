{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.readFile ./waybar-style.css;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        
        modules-left = [ "custom/launcher" "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "pulseaudio#microphone" "backlight" "cpu" "memory" "network" "battery" "tray" ];
        
        "custom/launcher" = {
            format = "";
            on-click = "rofi -show drun";
            tooltip = false;
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };
        
        "clock" = {
          format = "{:%H:%M}  ";
          format-alt = "{:%A, %B %d, %Y} ({:%H:%M})  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          on-click = "gsimplecal"; 
        };
        
        "battery" = {
          states = { warning = 30; critical = 15; };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        "network" = {
          format-wifi = "";
          format-ethernet = "";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "⚠";
          format-alt = "{essid} ({signalStrength}%) | {ipaddr}/{cidr}";
        };
        
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        "pulseaudio#microphone" = {
            format = "{format_source}";
            format-source = " {volume}%";
            format-source-muted = " Muted";
            on-click = "pavucontrol";
            on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +5%";
            on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -5%";
        };
        
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
          on-click = "kitty -e btop";
        };
        
        "memory" = {
          format = "{}% ";
          on-click = "kitty -e btop";
        };
        
        "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
        };
      };
    };
  };
}
