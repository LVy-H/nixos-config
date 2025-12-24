{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
        font-size: 14px;
        font-weight: bold;
      }

      window#waybar {
        background: transparent; /* Transparent background for floating look */
        color: #cad3f5;
      }

      /* Workspaces */
      #workspaces {
        background: #24273a;
        margin-top: 5px;
        margin-bottom: 5px;
        margin-left: 10px;
        border-radius: 15px;
        padding-left: 10px;
        padding-right: 10px;
      }

      #workspaces button {
        padding: 0 5px;
        color: #6e738d;
      }

      #workspaces button.focused {
        color: #c6a0f6; /* Mauve */
      }

      #workspaces button.urgent {
        color: #ed8796; /* Red */
      }

      /* Modules */
      .modules-right {
        margin-right: 10px;
      }
      
      .modules-left {
        margin-left: 10px;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #backlight, #custom-launcher {
        background: #24273a;
        padding: 0 15px;
        margin-top: 5px;
        margin-bottom: 5px;
        margin-left: 5px;
        margin-right: 5px;
        border-radius: 15px;
        color: #cad3f5;
      }

      /* Specific Module Colors */
      #clock {
        color: #8aadf4; /* Blue */
      }

      #battery {
        color: #a6da95; /* Green */
      }

      #battery.charging {
        color: #eed49f; /* Yellow */
      }

      #battery.warning:not(.charging) {
        color: #f5a97f; /* Peach */
      }

      #battery.critical:not(.charging) {
        color: #ed8796; /* Red */
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #network {
        color: #f5bde6; /* Pink */
      }

      #pulseaudio {
        color: #c6a0f6; /* Mauve */
      }
      
      #backlight {
        color: #f5a97f; /* Peach */
      }
      
      #cpu {
        color: #8bd5ca; /* Teal */
      }
      
      #memory {
        color: #eed49f; /* Yellow */
      }

      #custom-launcher {
        color: #8aadf4;
        padding-right: 15px; /* Adjust for icon visual balance */
      }

      #tray {
        background-color: #24273a;
      }
      
      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        
        modules-left = [ "custom/launcher" "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "backlight" "cpu" "memory" "network" "battery" "tray" ];
        
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
          format-charging = "{capacity}% ";
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
          on-click = "kitty --title 'Floating Network Manager' -e nmtui";
        };
        
        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "";
          format-source-muted = "";
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