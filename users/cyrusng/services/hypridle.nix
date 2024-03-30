{ config, inputs, pkgs, lib, ... }:
{
  imports = [
    inputs.hypridle.homeManagerModules.default
  ];

  services.hypridle = let
    hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
    hyprlock = "${lib.getExe config.programs.hyprlock.package}";
    loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
    killall = "${lib.getExe pkgs.killall}";
  in
  {
    enable = true;
    lockCmd = "pidof hyprlock || ${hyprlock} -q --immediate";
    unlockCmd = "${killall} -q -s $SIGUSR1 hyprlock";
    beforeSleepCmd = "loginctl lock-session";
    afterSleepCmd = "${hyprctl} dispatch dpms on";
    ignoreDbusInhibit = false;
    listeners = [
      { 
        timeout = 600;  
        onTimeout = "${hyprlock} -q"; 
      } 
      { 
        timeout = 900;  
        onTimeout = "${hyprctl} dispatch dpms off";
        onResume = "${hyprctl} dispatch dpms on";
      } 
      { 
        timeout = 1200; 
        onTimeout = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        onResume = "${hyprctl} dispatch dpms on";
      } 
    ];
  };
}
