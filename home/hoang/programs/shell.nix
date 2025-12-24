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
      
      # Better defaults
      ls = "ls --color=auto";
      ll = "ls -lh";
      la = "ls -lah";
      grep = "grep --color=auto";
      
      # Git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
    };
  };

  programs.starship = {
    enable = true;
    # Custom configuration can be added here
    settings = {
      add_newline = false;
      format = "$all"; # Default format
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
