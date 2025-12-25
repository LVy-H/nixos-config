{ pkgs, ... }:

let
  myAliases = {
    # NixOS shortcuts
    nos = "sudo nixos-rebuild switch --flake .#nixos";
    not = "sudo nixos-rebuild test --flake .#nixos";
    
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    
    # Modern CLI Replacements
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
    
    # New Fancy Tools
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
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    
    shellAliases = myAliases;
    
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "colored-man-pages" "command-not-found" ];
      theme = "robbyrussell"; # Overridden by Starship
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

  # Modern Core Tools
  programs.bat = {
    enable = true;
    config.theme = "Dracula";
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.yazi.enableZshIntegration = true;
}