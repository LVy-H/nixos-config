{ config, pkgs, lib, ... }:

{
  home.username = "hoang";
  home.homeDirectory = "/home/hoang";
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    pavucontrol
    discord
    google-chrome
    antigravity-fhs
  ];

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
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
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

  programs.kitty = {
    enable = true;
    font = { name = "JetBrainsMono Nerd Font"; size = 10; };
    themeFile = "Catppuccin-Macchiato";
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
      input."type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
      };
      output."*" = {
        bg = "${~/Downloads/Konachan.com_-_376008_sample.jpg} fill";
      };
    };
  };

  programs.home-manager.enable = true;
}
