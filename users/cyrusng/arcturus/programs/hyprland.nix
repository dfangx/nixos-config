{ config, pkgs, lib, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        ",preferred,auto,1"
      ];
    };
  };
}

