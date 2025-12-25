{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = { name = "JetBrainsMono Nerd Font"; size = 10; };
    themeFile = "Catppuccin-Macchiato";
    settings = {
        window_padding_width = 4;
        shell_integration = "no-cursor";
    };
  };
}
