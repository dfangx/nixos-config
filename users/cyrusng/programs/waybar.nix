{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    settings.bar = {
      margin = "10 10 0 10";
      reload_style_on_change = true;
      modules-left = [
        "hyprland/workspaces"
        "wlr/taskbar"
        "hyprland/window"
      ];
      modules-center = [
        "clock"
      ];
      wireplumber = {
        format-icons = [ "󰕿" "󰖀" "󰕾" ];
        format-muted = "󰝟";
        format = "{icon}";
        max-volume = 150;
        on-click = "${lib.getExe pkgs.pavucontrol}";
      };
      battery = {
        format = "{icon}";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂂" "󰂁" "󰂂" "󰁹" ];
        tooltip-format = "{capacity}% {timeTo}";
      };
      clock = {
        interval = 60;
        format = "{:%F %H:%M}";
        tooltip-format = "<tt><big>{calendar}</big></tt>";
        calendar = {
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
        };
        actions =  {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
      network = {
        interval = 5;
        format = "{ifname}";
        format-ethernet= "󰌘";
        format-linked = "󰣻";
        format-disconnected = "󰌙";
        format-wifi = "{icon}";
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
        format = "󰍛 {percentage}%";
        tooltip-format = ''
        RAM: {used:0.1f}GiB / {total:0.1f}GiB
        Swap: {swapUsed:0.1f}GiB / {swapTotal:0.1f}GiB'';
      };
      load = {
        format = "󰄪 {load1}"; 
      };
      cpu = {
        interval = 2.5;
        format = "󰻠 {usage}%";
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
      "hyprland/window" = {
        icon = true;
        icon-size = 17;
        max-length = 24;
      };
      tray = {
        show-passive-items = true;
        icon-size = 17;
        spacing = 10;
      };
      "wlr/taskbar" = {
        format = "{icon}";
        on-click = "activate";
        sort-by-app-id = true;
      };
    };
    systemd = {
      enable = true;
    };
  };

  systemd.user.services.waybar.Unit.After = lib.mkForce "graphical-session.target";
}
