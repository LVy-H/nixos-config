{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    location = "center";
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "JetBrainsMono Nerd Font 10";
    theme = "gruvbox-dark-hard";
    extraConfig = {
      show-icons = true;
      modi = "drun,run,window";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
    };
  };
}
