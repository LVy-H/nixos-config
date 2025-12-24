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
        modules-right = [ "pulseaudio" "pulseaudio#microphone" "backlight" "cpu" "memory" "disk" "network" "battery" "tray" ];
        
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
          interval = 30;
          states = { warning = 30; critical = 15; };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        "network" = {
          interval = 3;
          format-wifi = "";
          format-ethernet = "";
          tooltip-format = "{ifname} via {gwaddr}\nDownload: {bandwidthDownBits}\nUpload: {bandwidthUpBits}";
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
          interval = 2;
          format = "{usage}% ";
          tooltip = true;
          tooltip-format = "Usage: {usage}%\nFreq: {avg_frequency}GHz";
          on-click = "kitty -e btop";
        };
        
        "memory" = {
          interval = 5;
          format = "{}% ";
          tooltip-format = "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB";
          on-click = "kitty -e btop";
        };

        "disk" = {
            interval = 30;
            format = "{percentage_used}% ";
            path = "/";
            tooltip-format = "Root: {used} / {total} ({percentage_used}%)\nFree: {free}";
            on-click = "kitty -e ncdu";
        };
        
        "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
        };
      };
    };
  };
}
