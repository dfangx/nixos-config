{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar-hyprland;
    settings.bar = {
      layer = "top";
      modules-left = [
        # "river/tags"
        "wlr/workspaces"
      ];
      modules-center = [
        # "river/window"
        "hyprland/window"
      ];
      modules-right = [
        "tray"
        # "mpris"
        "cpu"
        "memory"
        "network"
        "battery"
        "clock"
      ];
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
      };
      cpu = {
        interval = 2.5;
        format = "CPU: {usage}%";
      };
      "river/window" = {
        max-length = 80;
      };
      "wlr/workspaces" = {
        format = "{name}";
        disable-scroll = true;
        all-outputs = true;
      };
      tray = {
        show-passive-items = true;
        icon-size = 15;
        spacing = 10;
      };
    };
    style = ''
      window#waybar {
        background-color: #3b4252;
        color: #e5e9f0;
        font-family: "Source Code Pro for Powerline";
        font-size: 15px;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network {
        padding-top: 3px;
        padding-bottom: 3px;
        padding-right: 7px;
        padding-left: 7px;
      }

      #workspaces button,
      #tags button {
        padding-top: 1px;
        padding-bottom: 1px;
        padding-right: 5px;
        padding-left: 5px;
        border-radius: 50%;
        color: #d8dee9;
        margin: 6px;
      }

      #tags button:hover {
        background: #434c5e;
        box-shadow: inherit;
        text-shadow: inherit;
      }

      #workspaces button.occupied,
      #tags button.occupied {
        background-color: #4c566a;
        color:#d8dee9;
      }

      #workspaces button.active,
      #tags button.focused {
        background-color: #5e81ac;
        color: #e5e9f0;
      }

      #workspaces button.urgent,
      #tags button.urgent {
        background-color: #d08770;
      }
    '';
    systemd = {
      enable = true;
      target = "${config.home.sessionVariables.XDG_SESSION_DESKTOP}-session.target";
    };
  };
}
