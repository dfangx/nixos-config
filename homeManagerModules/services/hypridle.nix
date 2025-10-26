{ config, pkgs, lib, ... }:
{
  options.hypridle.enable = lib.mkEnableOption "Enable hypridle";
  config = lib.mkIf config.hypridle.enable {
    services.hypridle = let
      uwsmLauncher = "${lib.getExe pkgs.uwsm} app --";
      hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
      hyprlock = "${uwsmLauncher} ${lib.getExe config.programs.hyprlock.package}";
      loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
      killall = "${lib.getExe pkgs.killall}";
    in
    {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock} -q --immediate";
          ignore_dbus_inhibit = false;
          before_sleep_cmd = "${loginctl} lock-session"; 
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
        };
        listener = [
          { 
            timeout = 600;  
            on-timeout = "pidof hyprlock || ${hyprlock} -q --immediate}"; 
          } 
          { 
            timeout = 900;  
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          } 
          { 
            timeout = 1200; 
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          } 
        ];
      };
    };
    systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  };
}
