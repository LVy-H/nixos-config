{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    # user.name and user.email configured via settings to avoid warnings
    settings = {
      user = {
        name = "Hoang";
        email = "hoang@example.com"; # Please update this!
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
