{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#24273a"; # Base
      border-color = "#c6a0f6";     # Mauve
      border-radius = 10;
      border-size = 2;
      text-color = "#cad3f5";       # Text
      default-timeout = 5000;
      layer = "overlay";
      font = "JetBrainsMono Nerd Font 11";
    };
  };
}