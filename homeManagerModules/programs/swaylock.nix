{ config, lib, pkgs, ... }:
let
in
{
  options.swaylock.enable = lib.mkEnableOption "Enable swaylock";
  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = {
      package = pkgs.callPackage ../../../pkgs/swaylock-fprintd { };
      settings = {
        # clock = true;
        # indicator = true;
        fingerprint=true;
        daemonize = true;
        image = "${config.xdg.userDirs.pictures}/wallpapers/bluewater.png";
        indicator-thickness = 5;
        ring-ver-color = "00000000";
        ring-wrong-color ="ff0000ff";
      };
    };
  };
}
