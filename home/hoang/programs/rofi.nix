{ pkgs, config, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  
  # Import custom theme template
  themeFile = pkgs.writeText "rofi-theme.rasi" (import ./rofi-theme.nix {
    inherit colors;
    # You can pass font overrides here if needed, otherwise it defaults
  });

  # Manix Search Script
  manix-rofi = pkgs.writeShellScriptBin "manix-rofi" ''
    #!/usr/bin/env bash
    QUERY=$(echo "" | ${pkgs.rofi}/bin/rofi -dmenu -p "Search Nix Docs" -lines 0 -theme-str 'listview {enabled: false;}')
    [ -z "$QUERY" ] && exit 0
    RESULTS=$(${pkgs.manix}/bin/manix "$QUERY" | grep '^# ' | sed 's/^# //')
    [ -z "$RESULTS" ] && exit 1
    SELECTED=$(echo "$RESULTS" | ${pkgs.rofi}/bin/rofi -dmenu -p "Select Option" -i)
    [ -z "$SELECTED" ] && exit 0
    DETAIL=$(${pkgs.manix}/bin/manix "$SELECTED" | grep -v '^Here.s what I found' | grep -v '^Source' | grep -v '^─')
    echo "$DETAIL" | ${pkgs.rofi}/bin/rofi -dmenu -p "Detail" -mesg "$DETAIL" -theme-str 'listview {enabled: false;} window {width: 800px;}'
  '';
in
{
  home.packages = [ manix-rofi ];
  
  # Disable Stylix for Rofi to use our custom "solid" layout
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    theme = "${themeFile}";
    terminal = "${pkgs.kitty}/bin/kitty";
    
    extraConfig = {
      modi = "drun,run,window,calc,emoji";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
      display-calc = "Calc";
      display-emoji = "Emoji";
    };
  };
  
  xdg.desktopEntries.manix = {
    name = "Manix Search";
    exec = "${manix-rofi}/bin/manix-rofi";
    icon = "nix-snowflake";
    terminal = false;
  };
}