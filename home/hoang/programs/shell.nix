{ pkgs, ... }:

let
  myAliases = {
    # NixOS shortcuts
    nos = "sudo nixos-rebuild switch --flake .#nixos";
    not = "sudo nixos-rebuild test --flake .#nixos";
    
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    
    # Modern CLI Replacements - Handled via initExtra for safety
    
    # New Fancy Tools - Handled via initExtra for safety
    
    # Archives
    x = "ouch decompress";
    xx = "ouch compress";
    
    # Git
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
  };
  
  # Safe alias generator for hybrid environments (Host vs Distrobox)
  safeAliases = ''
    # Only alias if the tool exists
    if command -v bat &> /dev/null; then alias cat="bat"; fi
    if command -v eza &> /dev/null; then 
      alias ls="eza --icons --group-directories-first"
      alias ll="eza -lh --icons --group-directories-first --git"
      alias la="eza -lah --icons --group-directories-first --git"
      alias tree="eza --tree --icons"
    fi
    if command -v fd &> /dev/null; then alias find="fd"; fi
    if command -v rg &> /dev/null; then alias grep="rg"; fi
    if command -v dust &> /dev/null; then alias du="dust"; fi
    if command -v procs &> /dev/null; then alias ps="procs"; fi
    if command -v duf &> /dev/null; then alias df="duf"; fi
    if command -v fastfetch &> /dev/null; then alias ff="fastfetch"; fi
    if command -v glow &> /dev/null; then alias md="glow"; fi
    if command -v yazi &> /dev/null; then alias ra="yazi"; fi
    if command -v zellij &> /dev/null; then alias ze="zellij"; fi
  '';
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = myAliases;
    initExtra = safeAliases + ''
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
    initContent = safeAliases + ''
      if command -v zoxide &> /dev/null; then eval "$(zoxide init zsh --cmd cd)"; fi
    '';
    
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
    enableBashIntegration = false;
    enableZshIntegration = false;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
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