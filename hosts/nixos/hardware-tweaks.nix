{ config, pkgs, ... }:

{
  # Fix for Acer Aspire Mic Mute Key
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svnAcer*:pn*:*
     KEYBOARD_KEY_66=micmute
  '';
}
