{ config, pkgs, lib, ... }:

{
  # --- Screen Locking ---

  programs.swaylock = { enable = true; package = pkgs.swaylock-effects; };
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033"; }
      { timeout = 600; command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'"; }
    ];
    events = {
      before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033";
      lock = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033";
    };
  };

  # --- Power Menu ---

  programs.wlogout.enable = true;

  # --- Notifications & Night Light ---

  services.swaync.enable = true;
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 21.0;
    longitude = 105.8;
  };
  services.swayosd.enable = true;

  # --- Clipboard ---

  services.cliphist = { enable = true; allowImages = true; };

  # --- System Tray Services ---

  services.udiskie.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
}
