{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    location = "center";
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "JetBrainsMono Nerd Font 10";
    theme = "gruvbox-dark-hard";
    extraConfig = {
      show-icons = true;
      modi = "drun,run,window,calc,emoji";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
    };
  };
}
