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
        height = 30;
        spacing = 2;
        
        modules-left = [ "custom/launcher" "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" "mpris" ];
        modules-right = [ "cpu" "memory" "disk" "custom/sep" "pulseaudio" "pulseaudio#microphone" "backlight" "custom/sep" "network" "bluetooth" "custom/vpn" "tray" "custom/sep" "battery" "clock" ];

        "custom/sep" = {
            format = "|";
            tooltip = false;
        };
        
        "mpris" = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} <i>{dynamic}</i>";
            player-icons = { 
                default = "▶"; 
                mpd = "🎵"; 
                spotify = "";
                firefox = "";
                chromium = "";
            };
            status-icons = {
                paused = "⏸";
                playing = "▶";
                stopped = "";
            };
            max-length = 30;
            on-click = "playerctl play-pause";
            on-click-right = "playerctl stop";
            on-scroll-up = "playerctl next";
            on-scroll-down = "playerctl previous";
            tooltip-format = "{player} ({status})\n{artist} - {title}\n{album}";
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
            max-length = 40;
            rewrite = {
                "(.*) - Mozilla Firefox" = "  $1";
                "(.*) - Visual Studio Code" = "󰨞  $1";
                "(.*) - Kitty" = "  [$1]";
                "(.*) - Thunar" = "  $1";
                "(.*) - Spotify" = "  $1";
                "(.*) - Discord" = "  $1";
                "^$" = "  Empty";
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
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          tooltip-format = "{ifname} via {gwaddr}\nDownload: {bandwidthDownBits}\nUpload: {bandwidthUpBits}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        "bluetooth" = {
            format = " {status}";
            format-disabled = "";
            format-connected = " {num_connections}";
            tooltip-format = "{controller_alias}\t{controller_address}";
            tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
            on-click = "blueman-manager";
        };
        
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = "";
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
            format-source-muted = "";
            on-click = "pavucontrol";
            on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +5%";
            on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -5%";
        };
        
        "cpu" = {
          interval = 2;
          format = " {usage}%";
          tooltip = true;
          tooltip-format = "Usage: {usage}%\nFreq: {avg_frequency}GHz";
          on-click = "kitty -e btop";
        };
        
        "memory" = {
          interval = 5;
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)\nSwap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB";
          on-click = "kitty -e btop";
        };

        "disk" = {
            interval = 30;
            format = " {percentage_used}%";
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
