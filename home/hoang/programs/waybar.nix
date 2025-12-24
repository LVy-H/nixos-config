{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }
      window#waybar {
        background: transparent;
        color: #cad3f5;
      }
      #workspaces {
        background: #24273a;
        margin: 5px;
        border-radius: 10px;
      }
      #workspaces button {
        padding: 0 10px;
        color: #cad3f5;
      }
      #workspaces button.focused {
        color: #ed8796;
      }
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        background: #24273a;
        padding: 0 10px;
        margin: 5px;
        border-radius: 10px;
      }
      #clock { color: #8aadf4; }
      #battery { color: #a6da95; }
      #battery.charging { color: #eed49f; }
      #battery.warning:not(.charging) { color: #f5a97f; }
      #battery.critical:not(.charging) {
        color: #ed8796;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      #network { color: #f5bde6; }
      #pulseaudio { color: #c6a0f6; }
      #tray { background-color: #24273a; }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "clock" = {
          format = "{:%H:%M}  ";
          format-alt = "{:%A, %B %d, %Y} ({:%H:%M})  ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          on-click = "gsimplecal"; # <--- ADDED: Click for calendar popup
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
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          # ADDED: Launches a floating terminal with nmtui for network selection
          on-click = "kitty --title 'Floating Network Manager' -e nmtui";
        };
        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
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
      };
    };
  };
}
