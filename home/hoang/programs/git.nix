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

  programs.gh = {
    enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      theme = "Dracula";
    };
  };
}
