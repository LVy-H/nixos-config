{ config, pkgs, ... }:

{
  # Fix for Acer Aspire Mic Mute Key
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svnAcer*:pn*:*
     KEYBOARD_KEY_66=micmute
  '';

  fileSystems."/mnt/Data" = {
    device = "/dev/disk/by-uuid/08EF8110170932EF";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };

  # Performance Optimizations
  zramSwap.enable = true;
  services.fstrim.enable = true;
}