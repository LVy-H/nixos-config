{ pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock;
    settings = {
      color = "24273a"; # Catppuccin Macchiato background
      ring-color = "c6a0f6"; # Mauve
      key-hl-color = "a6da95"; # Green
      line-color = "00000000";
      inside-color = "00000000";
      separator-color = "00000000";
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    # Updated syntax: events is now an attrset
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}