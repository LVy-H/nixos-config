{ pkgs, ... }:

let
  astronaut = pkgs.sddm-astronaut.override {
    themeConfig = {
      Background = "${../assets/background.png}";
      # Additional beautiful defaults for astronaut if desired
      Font = "JetBrainsMono Nerd Font";
      PartialBlur = "true";
    };
  };
in
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
    wireplumber.extraConfig = {
      "10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
  };

  # Input Method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-unikey
        fcitx5-mozc
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
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [
      qtsvg
      qtmultimedia
      qtvirtualkeyboard
    ];
  };
  services.displayManager.sessionPackages = [ pkgs.swayfx ];

  # Services
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  services.udisks2.enable = true; # Storage management
  
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  programs.xfconf.enable = true; # Thunar settings storage
  
  services.libinput.enable = true;
  services.touchegg.enable = true;
  services.gnome.gnome-keyring.enable = true;
  
  # Fonts
  fonts.packages = with pkgs; [ 
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    material-design-icons
  ];

  # Security
  security.pam.services.swaylock = {};
  
  # System-wide programs
  programs.dconf.enable = true;
  
  environment.systemPackages = [
    astronaut
  ];
}
