{ pkgs, ... }:

{
  users.users.hoang = {
    isNormalUser = true;
    description = "hoang";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "kvm" "adbusers" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    python3
  ];
}
