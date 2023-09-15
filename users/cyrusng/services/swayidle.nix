{ config, pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    systemdTarget = "${config.home.sessionVariables.XDG_SESSION_DESKTOP}-session.target";
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock"; } 
      { 
        event = "after-resume"; 
        command = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${pkgs.hyprland}/bin/hyprctl dispatch dpms on" 
          else
          "${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --on --output --on DP-1 --output HDMI-A-2 --on";
      }
    ];
    timeouts = [
      { timeout = 600;  command = "${pkgs.swaylock-effects}/bin/swaylock"; } 
      { 
        timeout = 900;  
        command = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${pkgs.hyprland}/bin/hyprctl dispatch dpms off"
          else
          "${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --off --output DP-1 --off --output HDMI-A-2 --off";
        resumeCommand = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${pkgs.hyprland}/bin/hyprctl dispatch dpms on" 
          else
          "${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --on --output --on DP-1 --output HDMI-A-2 --on";
      } 
      { 
        timeout = 1200; 
        command = "${pkgs.systemd}/bin/systemctl suspend-then-hibernate"; 
        resumeCommand = if config.home.sessionVariables.XDG_CURRENT_DESKTOP == "hyprland" then
          "${pkgs.hyprland}/bin/hyprctl dispatch dpms on" 
          else
          "${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --on --output --on DP-1 --output HDMI-A-2 --on";
      } 
    ];
  };
}
