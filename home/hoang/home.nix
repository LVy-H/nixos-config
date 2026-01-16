{ config, pkgs, lib, inputs, ... }:

let
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

  # Launcher
  stylix.targets.rofi.enable = false;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = "sidebar";
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

  xdg.desktopEntries.manix = {
    name = "Manix Search";
    exec = "${manix-rofi}/bin/manix-rofi";
    icon = "nix-snowflake";
    terminal = false;
  };

  # --- Services ---

  # Screen Locking (Declarative)
  programs.swaylock = { enable = true; package = pkgs.swaylock; };
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { timeout = 600; command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'"; }
    ];
    events = { before-sleep = "${pkgs.swaylock}/bin/swaylock -f"; lock = "${pkgs.swaylock}/bin/swaylock -f"; };
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
    manix-rofi
    swappy autotiling-rs wdisplays
    nautilus mission-center easyeffects swayosd
  
    # Apps
    google-chrome firefox discord spotify wpsoffice telegram-desktop burpsuite obsidian
    pavucontrol
    
    # Utils
    playerctl antigravity-fhs vscode-fhs libnotify wev btop brightnessctl
    libinput pulseaudio ncdu
    
    # CLI
    distrobox gemini-cli dust duf procs fastfetch glow
    zip xz unzip p7zip ouch
    jq yq-go
    wl-clipboard wf-recorder grim slurp
    polkit_gnome font-awesome
    (azure-cli.withExtensions [ azure-cli-extensions.ssh ])
  ];
}