{ pkgs, config, lib, ... }:

let
  inherit (config.lib.stylix) colors;
  
  # Custom Rofi Theme using Stylix Colors
  rofiTheme = pkgs.writeText "rofi-theme.rasi" ''
    * {
        bg-col:  #${colors.base00};
        bg-col-light: #${colors.base01};
        border-col: #${colors.base0E};
        selected-col: #${colors.base01};
        blue: #${colors.base0D};
        fg-col: #${colors.base05};
        fg-col2: #${colors.base08};
        grey: #${colors.base04};

        width: 600;
        font: "JetBrainsMono Nerd Font 12";
    }

    element-text, element-icon , mode-switcher {
        background-color: inherit;
        text-color:       inherit;
    }

    window {
        height: 360px;
        border: 2px;
        border-color: @border-col;
        background-color: @bg-col;
        border-radius: 10px;
    }

    mainbox {
        background-color: @bg-col;
    }

    inputbar {
        children: [prompt,entry];
        background-color: @bg-col;
        border-radius: 5px;
        padding: 2px;
    }

    prompt {
        background-color: @blue;
        padding: 6px;
        text-color: @bg-col;
        border-radius: 3px;
        margin: 20px 0px 0px 20px;
    }

    textbox-prompt-colon {
        expand: false;
        str: ":";
    }

    entry {
        padding: 6px;
        margin: 20px 0px 0px 10px;
        text-color: @fg-col;
        background-color: @bg-col;
    }

    listview {
        border: 0px 0px 0px;
        padding: 6px 0px 0px;
        margin: 10px 0px 0px 20px;
        columns: 1;
        lines: 6;
        background-color: @bg-col;
    }

    element {
        padding: 5px;
        background-color: @bg-col;
        text-color: @fg-col;
    }

    element-icon {
        size: 25px;
    }

    element selected {
        background-color:  @selected-col;
        text-color: @blue;
    }

    mode-switcher {
        spacing: 0;
    }

    button {
        padding: 10px;
        background-color: @bg-col-light;
        text-color: @grey;
        vertical-align: 0.5; 
        horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @blue;
    }

    message {
        background-color: @bg-col;
        margin: 2px;
        padding: 2px;
        border-radius: 5px;
    }

    textbox {
        padding: 6px;
        margin: 20px 0px 0px 20px;
        text-color: @blue;
        background-color: @bg-col;
    }
  '';

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

  # Disable Stylix for Rofi so we can use our custom theme
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    location = "center";
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "${rofiTheme}";
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
