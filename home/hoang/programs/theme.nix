{ pkgs, ... }:

{
  # We let Stylix handle GTK, QT, and Cursors for a unified look.
  # If you want to customize icons specifically, you can do it here.
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        accent = "mauve";
        flavor = "mocha";
      };
    };
  };
}