{ pkgs, ... }:

{
  users.users.hoang = {
    isNormalUser = true;
    description = "hoang";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "libvirtd" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Move non-essential system apps to Home Manager later, but keep basic dev tools here if preferred
  environment.systemPackages = with pkgs; [
    distrobox
    go
    python3
    openjdk21
    
    # Kubernetes
    kubectl
    minikube
    kubernetes-helm
    k9s
  ];
}
