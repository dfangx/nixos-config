{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    settings.bar = {
      layer = "top";
      modules-left = [
        "hyprland/workspaces"
      ];
      modules-center = [
        "clock"
      ];
      wireplumber = {
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
        format-muted = "󰝟";
        format = "{icon}";
        max-volume = 150;
      };
      battery = {
        format = "{icon}";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂂" "󰂁" "󰂂" "󰁹" ];
        tooltip-format = "{capacity}% {timeTo}";
      };
      clock = {
        interval = 60;
        format = "{:%F %H:%M}";
      };
      network = {
        interval = 5;
        format = "{icon}";
        format-ethernet= "󰌘";
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        tooltip-format = ''
          Interface: {ifname}
          IP Address: {ipaddr}
          Gateway: {gwaddr}
          SSID: {essid}
          Signal: {signalStrength}%
          Total: {bandwidthTotalBytes}
          Upload: {bandwidthUpBytes}
          Download: {bandwidthDownBytes}'';
      };
      memory = {
        interval = 2.5;
        format = "RAM: {percentage}%";
        tooltip-format = ''
        RAM: {used:0.1f}GiB / {total:0.1f}GiB
        Swap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB'';
      };
      cpu = {
        interval = 2.5;
        format = "CPU: {usage}%";
      };
      bluetooth = {
        format-disabled = "󰂲";
        format-off = "󰂲";
        format-connected = "󰂱";
        format-on = "󰂯";
        format = "󰂯";
        tooltip-format = "Bluetooth {status}";
        on-click = "${lib.getExe' pkgs.util-linux "rfkill"} unblock bluetooth && ${lib.getExe' pkgs.blueberry "blueberry"}";
        on-right-click = "${lib.getExe' pkgs.util-linux "rfkill"} block bluetooth";
      };
      "river/window" = {
        max-length = 80;
      };
      "hyprland/workspaces" = {
        format = "{name}";
        disable-scroll = true;
        all-outputs = true;
        on-click = "activate";
      };
      tray = {
        show-passive-items = true;
        icon-size = 15;
        spacing = 10;
      };
    };
    systemd = {
      enable = true;
    };
  };

  systemd.user.services.waybar.Unit.After = lib.mkForce "graphical-session.target";
}
