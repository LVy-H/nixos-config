{ pkgs, ... }:

{
  users.users.hoang = {
    isNormalUser = true;
    description = "hoang";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "libvirtd" "kvm" "adbusers" "vboxusers" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Move non-essential system apps to Home Manager later, but keep basic dev tools here if preferred
  environment.systemPackages = with pkgs; [
    go
    python3
    openjdk21
    
    # Kubernetes
    kubectl
    minikube
    kubernetes-helm
    k9s
    kubectx
    
    # Mobile
    
  ];
}
