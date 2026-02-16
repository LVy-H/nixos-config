{ config, pkgs, lib, ... }:

let
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
  # --- Terminal Emulators ---
  # kitty = primary, ghostty = fallback

  programs.kitty = {
    enable = true;
    settings = {
        window_padding_width = 4;
        shell_integration = "no-cursor";
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      window-decoration = false;
    };
  };

  # --- Shell ---

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

  # --- Git ---

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
      # Let Stylix handle theming (was Dracula, now matches Catppuccin Mocha system theme)
    };
  };

  # --- Modern CLI Tools ---

  programs.bat.enable = true;
  programs.eza = { enable = true; enableBashIntegration = false; enableZshIntegration = false; };
  programs.zoxide = { enable = true; enableBashIntegration = false; enableZshIntegration = false; };
  programs.atuin = { enable = true; enableBashIntegration = true; enableZshIntegration = true; settings.style = "compact"; settings.auto_sync = false; };
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.tealdeer = { enable = true; settings.updates.auto_update = true; };
  programs.fzf = { enable = true; enableBashIntegration = true; enableZshIntegration = true; };
  programs.btop = { enable = true; settings = { color_theme = "catppuccin_mocha"; }; };
  programs.fastfetch.enable = true;

  # --- File Manager & Multiplexer ---

  programs.yazi = { enable = true; enableBashIntegration = true; enableZshIntegration = true; settings.manager = { show_hidden = true; sort_dir_first = true; }; };
  programs.zellij = { enable = true; enableBashIntegration = false; };

  # --- Extra CLI Tools ---
  home.packages = with pkgs; [
    distrobox boxbuddy gemini-cli dust duf procs glow
    zip xz unzip p7zip ouch
    jq yq-go
    (azure-cli.withExtensions [ azure-cli-extensions.ssh ])
  ];
}
