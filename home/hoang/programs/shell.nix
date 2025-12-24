{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      # NixOS shortcuts
      nos = "sudo nixos-rebuild switch --flake .#nixos";
      not = "sudo nixos-rebuild test --flake .#nixos";
      
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Modern CLI Replacements
      cat = "bat";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -la";
      tree = "lsd --tree";
      find = "fd";
      grep = "rg";
      du = "dust";
      ps = "procs";
      df = "duf";
      
      # Archives
      x = "ouch decompress";
      xx = "ouch compress";
      
      # Git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };
  };

  programs.starship = {
    enable = true;
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
    config.theme = "Dracula"; # Good fallback, or Catppuccin if available
  };

  programs.lsd = {
    enable = true;
    enableBashIntegration = false; # We manually set aliases above
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ]; # Replace 'cd' with 'z'
  };

  programs.ripgrep.enable = true; # grep replacement
  programs.fd.enable = true;      # find replacement
  
  programs.tealdeer = {           # tldr (man replacement)
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.fzf = {                # Fuzzy finder
    enable = true;
    enableBashIntegration = true;
  };
}
