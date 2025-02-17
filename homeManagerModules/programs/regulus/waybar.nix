{ config, lib, ... }:
{
  config = lib.mkIf config.waybar.enable {
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
  };
}
