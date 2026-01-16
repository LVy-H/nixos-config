{ config, pkgs, lib, inputs, ... }:

let
  # Shell Aliases
  myAliases = {
    # NixOS
    nos = "sudo nixos-rebuild switch --flake .#nixos";
    not = "sudo nixos-rebuild test --flake .#nixos";
    
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    
    # Modern CLI
    cat = "bat";
    ls = "eza --icons --group-directories-first";
    ll = "eza -lh --icons --group-directories-first --git";
    la = "eza -lah --icons --group-directories-first --git";
    tree = "eza --tree --icons";
    find = "fd";
    grep = "rg";
    du = "dust";
    ps = "procs";
    df = "duf";
    ff = "fastfetch";
    md = "glow";
    ra = "yazi";
    ze = "zellij";
    
    # Archives
    x = "ouch decompress";
    xx = "ouch compress";
    
    # Git
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
  };
in
{
  imports = [
    ./programs/waybar.nix
    ./programs/sway.nix
    ./programs/nixvim.nix
  ];

  home = {
    username = "hoang";
    homeDirectory = "/home/hoang";
    stateVersion = "25.11";

    sessionVariables = {
      ANDROID_HOME = "$HOME/Android/Sdk";
      ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    };

    sessionPath = [
      "$HOME/Android/Sdk/platform-tools"
      "$HOME/Android/Sdk/tools/bin"
    ];
  };

  # --- Core Programs ---

  # Terminal
  programs.kitty = {
    enable = true;
    settings = {
        window_padding_width = 4;
        shell_integration = "no-cursor";
    };
  };

  # Shell context
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    initExtra = ''
      if command -v zoxide &> /dev/null; then eval "$(zoxide init bash --cmd cd)"; fi
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    shellAliases = myAliases;
    initContent = ''
      if command -v zoxide &> /dev/null; then eval "$(zoxide init zsh --cmd cd)"; fi
    '';
    history = {
        size = 10000;
        path = "$HOME/.zsh_history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "colored-man-pages" "command-not-found" ];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = "$all";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Hoang";
        email = "hoang@example.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      safe.directory = "/etc/nixos";
    };
  };
  programs.gh.enable = true;
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      theme = "Dracula"; 
    };
  };

  # Modern CLI Tools
  programs.bat.enable = true;
  programs.eza = { enable = true; enableBashIntegration = false; enableZshIntegration = false; };
  programs.zoxide = { enable = true; enableBashIntegration = false; enableZshIntegration = false; };
  programs.atuin = { enable = true; enableBashIntegration = true; enableZshIntegration = true; settings.style = "compact"; settings.auto_sync = false; };
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.tealdeer = { enable = true; settings.updates.auto_update = true; };
  programs.fzf = { enable = true; enableBashIntegration = true; enableZshIntegration = true; };
  
  # File Manager & Multiplexer
  programs.yazi = { enable = true; enableBashIntegration = true; enableZshIntegration = true; settings.manager = { show_hidden = true; sort_dir_first = true; }; };
  programs.zellij = { enable = true; enableBashIntegration = false; };

  xdg.dataFile = {
    "icons/network.cycles.wdisplays.svg".source = "${pkgs.wdisplays}/share/icons/hicolor/scalable/apps/network.cycles.wdisplays.svg";
    "icons/swappy.svg".source = "${pkgs.swappy}/share/icons/hicolor/scalable/apps/swappy.svg";
    "icons/antigravity.svg".source = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    "icons/rofi.svg".source = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg"; 
    "icons/yazi.svg".source = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  };

  # Launcher
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

  # programs.wofi is removed in favor of rofi

  # --- Services ---

  # Screen Locking (Declarative)
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

  # Power Menu
  programs.wlogout.enable = true;

  # Notifications & Night Light
  services.swaync.enable = true;
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 21.0;
    longitude = 105.8;
  };
  services.swayosd.enable = true;

  # Clipboard
  services.cliphist = { enable = true; allowImages = true; };
  
  # Utilities (Declarative Services)
  services.udiskie.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  # --- System & Packages ---

  programs.home-manager.enable = true;
  programs.direnv = { enable = true; nix-direnv.enable = true; };
  programs.wardex = { enable = true; settings.paths.workspace = "/mnt/Data/Workspace"; };

  home.packages = with pkgs; [
    swappy autotiling-rs wdisplays swayr
    nautilus mission-center easyeffects swayosd
  
    # Apps
    google-chrome firefox discord spotify wpsoffice telegram-desktop burpsuite obsidian
    pavucontrol
    
    # Utils
    playerctl antigravity-fhs vscode-fhs libnotify wev btop brightnessctl
    libinput pulseaudio ncdu scrcpy sway-audio-idle-inhibit
    sway-audio-idle-inhibit
    (pkgs.tesseract.override { enableLanguages = [ "eng" "vie" "chi_sim" "chi_tra" "jpn" ]; })
    imagemagick
    swaybg

    # Custom Scripts
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
    
    # CLI
    distrobox gemini-cli dust duf procs fastfetch glow
    zip xz unzip p7zip ouch
    jq yq-go
    wl-clipboard wf-recorder grim slurp
    polkit_gnome font-awesome
    (azure-cli.withExtensions [ azure-cli-extensions.ssh ])
  ];
}