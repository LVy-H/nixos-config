{ pkgs, ... }:

{
  # Graphics
  hardware.graphics.enable = true;

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Input Method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-unikey
        fcitx5-gtk
        qt6Packages.fcitx5-configtool
      ];
    };
  };

  # Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Display Manager
  services.displayManager.sddm = {
    wayland.enable = true;
    enable = true;
  };
  services.displayManager.sessionPackages = [ pkgs.sway ];

  # Services
  services.libinput.enable = true;
  services.touchegg.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  # Fonts
  fonts.packages = with pkgs; [ 
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    material-design-icons
  ];

  # Security
  security.pam.services.swaylock = {};
  
  # System-wide programs
  programs.dconf.enable = true;
}
