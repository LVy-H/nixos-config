{ config, pkgs, ... }:

{
  # Gaming
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false; # Fix login loop
  };
}
