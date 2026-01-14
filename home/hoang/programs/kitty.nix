{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
        window_padding_width = 4;
        shell_integration = "no-cursor";
    };
  };
}
