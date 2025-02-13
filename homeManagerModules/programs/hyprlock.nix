{ config, inputs, lib, pkgs, ... }:
let
  date= "${lib.getExe' pkgs.coreutils-full "date"}";
in
{
  options.hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 180;
          hide_cursor = true;
          no_fade_in = true;
        };
        input-field = [
          {
            size= "400, 50";
            dots_size = 0.25;
            fade_timeout = 5000;
          }
        ];
        background = [
          {
            path = "${config.xdg.userDirs.pictures}/wallpapers/bluewater.png";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        label = [
          {
            text = "<span size='68pt' weight='heavy'>$TIME</span>";
            font_family = "Source Code Pro for Powerline";
            color = "rgba(0, 0, 0, 1.0)";
            halign = "center";
            valign = "center";
            position = "0, 200";
          }
          {
            text = "cmd[update:60000] echo \"<span size='100%' weight='heavy'>$(${date} +%F)</span>\"";
            font_family = "Source Code Pro for Powerline";
            color = "rgba(0, 0, 0, 1.0)";
            halign = "center";
            valign = "center";
            position = "0, 100";
          }
          {
            text = "<span size='100%' weight='bold'>Hi there, $USER</span>";
            font_family = "Source Code Pro for Powerline";
            color = "rgba(0, 0, 0, 1.0)";
            halign = "center";
            valign = "center";
            position = "0, 50";
          }
        ];
      };
    };
  };
}
