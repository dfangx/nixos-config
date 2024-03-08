{ config, inputs, lib, pkgs, ... }:
let
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
    backgrounds = [
      {
        path = "${config.xdg.userDirs.pictures}/wallpapers/bluewater.png";
      }
    ];
    labels = [
      {
        text = "Hi there, $USER";
        font_family = "Source Code Pro for Powerline";
      }
    ];
  };
}

