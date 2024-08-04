{ config, inputs, pkgs, lib, ... }:
{
  services.hypridle = let
    suspendScript = pkgs.writeShellScript "suspend-script" ''
      ${pkgs.gnugrep}/bin/grep -q RUNNING /proc/asound/card*/*p/*/status
      # only suspend if audio isn't running
      if [ $? == 1 ]; then
        ${pkgs.systemd}/bin/systemctl suspend
      fi
    '';
    hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
    hyprlock = "${lib.getExe config.programs.hyprlock.package}";
    loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
    killall = "${lib.getExe pkgs.killall}";
  in
  {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${hyprlock} -q --immediate";
        unlock_cmd = "${killall} -q -s $SIGUSR1 hyprlock";
        before_sleep_cmd = "${loginctl} lock-session";
        after_sleep_cmd = "${hyprctl} dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        { 
          timeout = 600;  
          on-timeout = "${hyprlock} -q"; 
        } 
        { 
          timeout = 900;  
          on-timeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on";
        } 
        { 
          timeout = 1200; 
          on-timeout = suspendScript.outPath;
          on-resume = "${hyprctl} dispatch dpms on";
        } 
      ];
    };
  };
}
