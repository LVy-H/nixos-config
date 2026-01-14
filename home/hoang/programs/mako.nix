{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      border-radius = 10;
      border-size = 2;
      default-timeout = 5000;
      layer = "overlay";
    };
  };
}