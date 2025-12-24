{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false; # Don't auto-start everywhere
    settings = {
      theme = "catppuccin-macchiato";
      default_layout = "compact";
    };
  };
}
