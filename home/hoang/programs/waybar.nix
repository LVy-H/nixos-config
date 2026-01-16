{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    # style is handled by Stylix automatically
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [ "sway/workspaces" "sway/mode" "mpris" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "custom/notification" "tray" "clock" "custom/power" ];

        "sway/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
        };

        "mpris" = {
            format = "{player_icon} {dynamic}";
            format-paused = "{status_icon} <i>{dynamic}</i>";
            player-icons = { 
                default = "▶"; 
                mpd = "🎵"; 
                spotify = "";
                firefox = "";
            };
            status-icons = {
                paused = "⏸";
                playing = "▶";
                stopped = "";
            };
            max-length = 30;
        };
        
        "clock" = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%H:%M}  ";
            format-alt = "{:%Y-%m-%d}";
        };
        
        "battery" = {
          states = { warning = 30; critical = 15; };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = ["" "" "" "" ""];
        };
        
        "network" = {
          format-wifi = " {essid}";
          format-ethernet = "";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "⚠";
          format-alt = "{ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
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
        
        "cpu" = {
          format = " {usage}%";
          tooltip = true;
        };
        
        "memory" = {
          format = " {percentage}%";
        };

        "tray" = {
            spacing = 10;
        };

        "custom/power" = {
            format = " ";
            tooltip = false;
            on-click = "wlogout";
        };

        "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
        };
      };
    };
  };
}
