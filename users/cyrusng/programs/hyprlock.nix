{ config, inputs, lib, pkgs, ... }:
let
  date= "${lib.getExe' pkgs.coreutils-full "date"}";
in
{
  imports = [
    inputs.hyprlock.homeManagerModules.default
  ];

  programs.hyprlock = {
    enable = true;
    general = {
      disable_loading_bar = true;
      grace = 180;
      hide_cursor = true;
      no_fade_in = true;
    };
    input-fields = [
      {
        size.width = 400;
        dots_size = 0.25;
        fade_timeout = 5000;
      }
    ];
    backgrounds = [
      {
        path = "${config.xdg.userDirs.pictures}/wallpapers/bluewater.png";
        blur_passes = 3;
        blur_size = 8;
      }
    ];
    labels = [
      {
        text = "<span size='68pt' weight='heavy'>$TIME</span>";
        font_family = "Source Code Pro for Powerline";
        color = "rgba(0, 0, 0, 1.0)";
        halign = "center";
        position.y = 200;
      }
      {
        text = "cmd[update:60000] echo \"<span size='100%' weight='heavy'>$(${date} +%F)</span>\"";
        font_family = "Source Code Pro for Powerline";
        color = "rgba(0, 0, 0, 1.0)";
        halign = "center";
        position.y = 100;
      }
      {
        text = "<span size='100%' weight='bold'>Hi there, $USER</span>";
        font_family = "Source Code Pro for Powerline";
        color = "rgba(0, 0, 0, 1.0)";
        halign = "center";
        position.y = 50;
      }
    ];
  };
}
