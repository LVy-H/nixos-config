{ config, pkgs, lib, ... }:

{
  # --- Launcher ---

  stylix.targets.rofi.enable = false;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = ./rofi-spotlight.rasi;
    plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "combi,calc,emoji"; 
      combi-modi = "drun,window";
      show-icons = true; 
      drun-display-format = "{icon} {name}";
      display-combi = "Go";
    };
  };

  # --- Window Switcher ---

  programs.swayr = {
    enable = true;
    systemd.enable = true;
    settings = {
      format = {
        icon_dirs = [
          "/run/current-system/sw/share/icons"
          "/run/current-system/sw/share/icons/hicolor/scalable/apps"
          "/run/current-system/sw/share/icons/hicolor/48x48/apps"
          "${pkgs.adwaita-icon-theme}/share/icons" 
          "${pkgs.papirus-icon-theme}/share/icons/Papirus/48x48/apps"
          "/home/hoang/.local/share/icons"
        ];
      };
      menu = {
        executable = "${pkgs.rofi}/bin/rofi";
        args = [ "-dmenu" "-p" "Window" "-markup-rows" "-no-show-icons" ]; 
      };
    };
  };

  # --- XDG Icons ---

  xdg.dataFile = {
    "icons/network.cycles.wdisplays.svg".source = "${pkgs.wdisplays}/share/icons/hicolor/scalable/apps/network.cycles.wdisplays.svg";
    "icons/swappy.svg".source = "${pkgs.swappy}/share/icons/hicolor/scalable/apps/swappy.svg";
    "icons/antigravity.svg".source = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    "icons/rofi.svg".source = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"; 
    "icons/yazi.svg".source = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  };

  # --- Custom Scripts ---

  home.packages = with pkgs; [
    swayr

    (pkgs.writeShellScriptBin "ocr" ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.tesseract}/bin/tesseract - - -l eng+vie+chi_sim+chi_tra+jpn | ${pkgs.wl-clipboard}/bin/wl-copy
      ${pkgs.libnotify}/bin/notify-send "OCR" "Text copied to clipboard"
    '')

    (pkgs.writeShellScriptBin "rofi-wallpaper" ''
      WALL_DIR="$HOME/Pictures/Wallpapers"
      mkdir -p "$WALL_DIR"
      
      # Recursive image scan with previews
      find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort | while read -r img_path; do
        img_name=$(basename "$img_path")
        echo -en "$img_name\0icon\x1f$img_path\n"
      done | ${pkgs.rofi}/bin/rofi -dmenu -theme ${./rofi-wallpaper.rasi} -p "Wallpaper" | while read -r selected; do
        if [ -n "$selected" ]; then
           full_path=$(find "$WALL_DIR" -name "$selected" | head -n 1)
           if [ -n "$full_path" ]; then
             ${pkgs.sway}/bin/swaymsg "output * bg $full_path fill"
           fi
        fi
      done
    '')

    (pkgs.writeShellScriptBin "rofi-clipboard" ''
      CACHE_DIR="/tmp/cliphist-thumbs"
      mkdir -p "$CACHE_DIR"
      
      # Build rofi input with image thumbnails
      ${pkgs.cliphist}/bin/cliphist list | while IFS= read -r line; do
        id="''${line%% *}"
        
        # Check if this is an image entry (cliphist stores images with specific format)
        if ${pkgs.cliphist}/bin/cliphist decode "$id" 2>/dev/null | file - | grep -q "image"; then
          thumb="$CACHE_DIR/$id.png"
          if [ ! -f "$thumb" ]; then
            ${pkgs.cliphist}/bin/cliphist decode "$id" 2>/dev/null | ${pkgs.imagemagick}/bin/convert - -resize 128x128 "$thumb" 2>/dev/null
          fi
          if [ -f "$thumb" ]; then
            echo -en "$line\0icon\x1f$thumb\n"
          else
            echo "$line"
          fi
        else
          echo "$line"
        fi
      done | ${pkgs.rofi}/bin/rofi -dmenu -theme ${./rofi-clipboard.rasi} -p "Clipboard" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
    '')

    # Image-only clipboard viewer with large previews
    (pkgs.writeShellScriptBin "rofi-clipboard-images" ''
      CACHE_DIR="/tmp/cliphist-images"
      mkdir -p "$CACHE_DIR"
      
      # Extract images from clipboard history (cliphist marks them as "binary data ... png/jpg")
      ${pkgs.cliphist}/bin/cliphist list | grep -E "\[\[ binary data.*\]\]" | while IFS= read -r line; do
        id="''${line%% *}"
        img_file="$CACHE_DIR/$id.png"
        
        # Decode and cache the image
        if [ ! -f "$img_file" ]; then
          ${pkgs.cliphist}/bin/cliphist decode "$id" 2>/dev/null > "$img_file"
        fi
        
        # Only output if file exists and has content
        if [ -s "$img_file" ]; then
          echo -en "$id\0icon\x1f$img_file\n"
        fi
      done | ${pkgs.rofi}/bin/rofi -dmenu -theme ${./rofi-wallpaper.rasi} -p "Images" | while read -r selected_id; do
        if [ -n "$selected_id" ]; then
          ${pkgs.cliphist}/bin/cliphist decode "$selected_id" | ${pkgs.wl-clipboard}/bin/wl-copy
          ${pkgs.libnotify}/bin/notify-send "Clipboard" "Image copied!"
        fi
      done
    '')
  ];
}
