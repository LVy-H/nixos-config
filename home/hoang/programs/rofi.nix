{ pkgs, ... }:

let
  manix-rofi = pkgs.writeShellScriptBin "manix-rofi" ''
    #!/usr/bin/env bash
    
    # 1. Get Query
    QUERY=$(echo "" | ${pkgs.rofi}/bin/rofi -dmenu -p "Search Nix Docs" -lines 0 -theme-str 'listview {enabled: false;}')
    [ -z "$QUERY" ] && exit 0

    # 2. Get Results
    RESULTS=$(${pkgs.manix}/bin/manix "$QUERY" | grep '^# ' | sed 's/^# //')
    
    if [ -z "$RESULTS" ]; then
        ${pkgs.libnotify}/bin/notify-send "Manix" "No results found for '$QUERY'"
        exit 1
    fi

    # 3. Select Result
    SELECTED=$(echo "$RESULTS" | ${pkgs.rofi}/bin/rofi -dmenu -p "Select Option" -i)
    [ -z "$SELECTED" ] && exit 0

    # 4. Show Detail
    DETAIL=$(${pkgs.manix}/bin/manix "$SELECTED" | grep -v '^Here.s what I found' | grep -v '^Source' | grep -v '^─')
    
    echo "$DETAIL" | ${pkgs.rofi}/bin/rofi -dmenu -p "Detail" -mesg "$DETAIL" -theme-str 'listview {enabled: false;} window {width: 800px;}'
  '';
in
{
  home.packages = [ manix-rofi ];
  
  xdg.desktopEntries.manix = {
    name = "Manix Search";
    genericName = "Nix Documentation Search";
    exec = "${manix-rofi}/bin/manix-rofi";
    terminal = false;
    categories = [ "System" "Documentation" ];
    icon = "nix-snowflake";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    location = "center";
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "JetBrainsMono Nerd Font 11";
    theme = ./rofi-theme.rasi;
    extraConfig = {
      show-icons = true;
      modi = "drun,run,window,calc,emoji";
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
      display-calc = "Calc";
      display-emoji = "Emoji";
      drun-display-format = "{icon} {name}";
    };
  };
}
