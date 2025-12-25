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
        modules-center = [ "sway/window" "mpris" ];
        modules-right = [ "clock" "pulseaudio" "pulseaudio#microphone" "backlight" "cpu" "memory" "disk" "network" "custom/vpn" "bluetooth" "battery" "tray" ];
        
        "mpris" = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} <i>{dynamic}</i>";
            player-icons = { 
                default = "▶"; 
                mpd = "🎵"; 
            };
            status-icons = {
                paused = "⏸";
            };
            max-length = 40;
            on-click = "playerctl play-pause";
            on-scroll-up = "playerctl next";
            on-scroll-down = "playerctl previous";
        };

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

        "sway/window" = {
            format = "{title}";
            max-length = 50;
            rewrite = {
                "(.*) - Mozilla Firefox" = "Firefox";
                "(.*) - Visual Studio Code" = "VSCode";
            };
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
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "  {ipaddr}";
          tooltip-format = "{ifname} via {gwaddr}\nDownload: {bandwidthDownBits}\nUpload: {bandwidthUpBits}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        "bluetooth" = {
            format = " {status}";
            format-disabled = "";
            format-connected = " {num_connections} connected";
            tooltip-format = "{controller_alias}\t{controller_address}";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            on-click = "blueman-manager";
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
          format = " {usage}% ({avg_frequency}GHz)";
          tooltip = true;
          tooltip-format = "Usage: {usage}%\nFreq: {avg_frequency}GHz";
          on-click = "kitty -e btop";
        };
        
        "memory" = {
          interval = 5;
          format = " {used:0.1f}G/{total:0.1f}G";
          tooltip-format = "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB";
          on-click = "kitty -e btop";
        };

        "disk" = {
            interval = 30;
            format = " {free} free";
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
