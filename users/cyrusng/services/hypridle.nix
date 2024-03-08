{ config, inputs, pkgs, lib, ... }:
{
  imports = [
    inputs.hypridle.homeManagerModules.default
  ];

  services.hypridle = let
    hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
    hyprlock = "${lib.getExe config.programs.hyprlock.package}";
  in
  {
    enable = true;
    listeners = [
      { 
        timeout = 600;  
        onTimeout = "${hyprlock}"; 
      } 
      { 
        timeout = 900;  
        onTimeout = "${hyprctl} dispatch dpms off";
        onResume = "${hyprctl} dispatch dpms on";
      } 
      { 
        timeout = 1200; 
        onTimeout = "${lib.getExe' pkgs.systemd "systemctl"} suspend-then-hibernate";
        onResume = "${hyprctl} dispatch dpms on";
      } 
    ];
    afterSleepCmd = "${hyprctl} dispatch dpms on";
    beforeSleepCmd = "${hyprlock}";
  };
}
