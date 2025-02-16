{ config, pkgs, lib, ... }:
{
  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      settings.bar = {
        modules-right = [
          "tray"
          "bluetooth"
          "custom/osk"
          "privacy"
          "wireplumber"
          "battery"
          "network"
          "group/group-hardware"
          "group/group-hub"
        ];
        "custom/osk" = {
          on-click = "${lib.getExe' pkgs.procps "pkill"} -SIGRTMIN wvkbd";
          format = "󰌌";
        };
      };
    };
  };
}


