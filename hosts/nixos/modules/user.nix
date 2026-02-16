{ pkgs, ... }:

{
  users.users.hoang = {
    isNormalUser = true;
    description = "hoang";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "kvm" "adbusers" "libvirt" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    python3
  ];
}
