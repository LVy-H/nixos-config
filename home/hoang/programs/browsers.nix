{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = false;
      DisableAccounts = false;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # stylized
      DisplayMenuBar = "default-off"; # stylized
      SearchBar = "unified";
    };

    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
      settings = {
        "browser.startup.homepage" = "about:blank";
        "browser.search.defaultenginename" = "Google";
        "browser.search.order.1" = "Google";
        
        "signon.rememberSignons" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.cache.disk.enable" = false; # Be kind to SSD?
        
        # Look and feel
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "sidebar.verticalTabs" = true; # firefox 134+ feature
        "sidebar.main.tools" = "history,bookmarks";
        "sidebar.visibility" = "always";
      };
    };
  };

  home.packages = with pkgs; [
    google-chrome
  ];
}
