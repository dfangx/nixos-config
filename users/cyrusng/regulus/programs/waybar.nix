{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    settings.bar = {
      modules-right = [
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
