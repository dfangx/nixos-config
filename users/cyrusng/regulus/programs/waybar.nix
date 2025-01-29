{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    settings.bar = {
      modules-right = [
        "mpris"
        "tray"
        "bluetooth"
        "privacy"
        "wireplumber"
        "network"
        "group/group-hardware"
        "group/group-hub"
      ];
    };
  };
}
