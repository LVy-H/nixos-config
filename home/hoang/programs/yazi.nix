{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    # enableZshIntegration = true; # If you switch later
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_symlink = true;
      };
    };
  };
}
