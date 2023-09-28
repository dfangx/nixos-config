{ config, pkgs, lib, ... }:
{
  services.swayidle = let 
    hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
    wlr-randr = "${lib.getExe pkgs.wlr-randr}";
    swaylock = "${lib.getExe' pkgs.swaylock-effects "swaylock"}";
  in 
  {
    enable = true;
    systemdTarget = "${config.home.sessionVariables.XDG_SESSION_DESKTOP}-session.target";
    events = [
      { event = "before-sleep"; command = "${swaylock}"; } 
      { 
        event = "after-resume"; 
        command = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${hyprctl} dispatch dpms on" 
          else
          "${wlr-randr} --output eDP-1 --on --output --on DP-1 --output HDMI-A-2 --on";
      }
    ];
    timeouts = [
      { timeout = 600;  command = "${swaylock}"; } 
      { 
        timeout = 900;  
        command = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${hyprctl} dispatch dpms off"
          else
          "${wlr-randr} --output eDP-1 --off --output DP-1 --off --output HDMI-A-2 --off";
        resumeCommand = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${hyprctl} dispatch dpms on" 
          else
          "${wlr-randr} --output eDP-1 --on --output --on DP-1 --output HDMI-A-2 --on";
      } 
      { 
        timeout = 1200; 
        command = "${lib.getExe' pkgs.systemd "systemctl"} suspend-then-hibernate"; 
        resumeCommand = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${hyprctl} dispatch dpms on" 
          else
          "${wlr-randr} --output eDP-1 --on --output --on DP-1 --output HDMI-A-2 --on";
      } 
    ];
  };
}
