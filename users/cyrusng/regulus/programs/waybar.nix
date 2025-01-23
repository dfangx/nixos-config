{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    settings.bar = {
      modules-right = [
        "tray"
        "bluetooth"
        "privacy"
        "wireplumber"
        "network"
        "group/group-hardware"
        "group/group-hub"
      ];
      privacy = {
        icon-size = 14;
      };
      "group/group-hardware" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          children-class = "hardware-drawer";
          transition-left-to-right = false;
        };
        modules = [
          "custom/hardware"
          "cpu"
          "load"
          "temperature"
          "memory"
          "disk"
        ];
      };
      "group/group-hub" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 500;
          children-class = "hub-drawer";
          transition-left-to-right = false;
        };
        modules = [
          "custom/linux" 
          "custom/shutdown" 
          "custom/quit"
          "custom/lock"
          "custom/reboot"
        ];
      };
      disk = {
        format = "󰋊 {percentage_used}%";
        path = "/home";
      };
      temperature = {
        format = "󰔏: {temperatureC}°C";
        thermal-zone = 1;
      };
      "custom/hardware" = {
        format = "󰟀";
        tooltip = false;
      };
      "custom/quit" = let
        loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
      in
      {
        format = "󰗼";
        tooltip = false;
        on-click = "${loginctl} terminate-user \"\"";
      };
      "custom/lock" = {
        format = "󰍁";
        tooltip = false;
        on-click = lib.getExe pkgs.hyprlock;
      };
      "custom/reboot" = {
        format = "󰜉";
        tooltip = false;
        on-click = "reboot";
      };
      "custom/shutdown" = {
        format = "󰐥";
        tooltip = false;
        on-click = "shutdown now";
      };
      "custom/linux" = {
        format = "󰻀";
        tooltip = false;
        on-click = lib.getExe pkgs.fuzzel;
      };
    };
    style = let
      border-radius = "20px";
      margin = "15px";
    in
    ''
      @import '${config.xdg.configHome}/waybar/wallust/colors-waybar.css';
    
      window#waybar {
        background: transparent;
        color: @foreground;
        font-family: "Source Code Pro for Powerline";
        font-size: 17px;
        padding-top: 3px;
        padding-bottom: 3px;
      }

      #window,
      #taskbar,
      #custom-hardware,
      #custom-linux,
      #custom-shutdown,
      #custom-reboot,
      #custom-lock,
      #custom-quit,
      #privacy,
      #clock,
      #taskbar,
      #workspaces,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #load,
      #disk,
      #tray,
      #bluetooth,
      #wireplumber,
      #network {
        background-color: @background;
        padding-right: 7px;
        padding-left: 7px;
      }

      #tray {
        border-bottom-left-radius: ${border-radius};
        border-top-left-radius: ${border-radius};
        padding-left: 15px;
      }

      #network {
        border-bottom-right-radius: ${border-radius};
        border-top-right-radius: ${border-radius};
        padding-right: 15px;
      }

      #window,
      #group-hardware,
      #group-hub {
        margin-left: ${margin};
        padding-right: 15px;
        padding-left: 15px;
        background-color: @background;
      }

      #window,
      #group-hardware,
      #group-hub,
      #clock,
      #taskbar,
      #workspaces {
        border-radius: ${border-radius};
      }

      #clock,
      #taskbar,
      #workspaces {
        padding-right: 15px;
        padding-left: 15px;
      }

      #workspaces {
        border-color: @color3;
      }

      #taskbar {
        margin-left: ${margin};
      }



      #workspaces button,
      #tags button {
        border-radius: 50%;
      }

      #taskbar button,
      #workspaces button,
      #tags button {
        color: @color4;
      }

      #custom-linux,
      #custom-shutdown,
      #custom-reboot,
      #custom-lock,
      #custom-quit,
      #taskbar button,
      #workspaces button,
      #tags button {
        padding-top: 1px;
        padding-bottom: 1px;
        padding-right: 5px;
        padding-left: 5px;
        margin: 4px;
      }

      #custom-linux:hover,
      #custom-shutdown:hover,
      #custom-reboot:hover,
      #custom-lock:hover,
      #custom-quit:hover,
      #taskbar button
      {
        border-radius: 7px;
      }

      #custom-linux:hover,
      #custom-shutdown:hover,
      #custom-reboot:hover,
      #custom-lock:hover,
      #custom-quit:hover,
      #taskbar button:hover,
      #workspaces button:hover,
      #tags button:hover {
        background-color: @color3;
        border-color: @color3;
        color: @foreground;
        box-shadow: inherit;
        text-shadow: inherit;
      }

      #workspaces button.occupied,
      #tags button.occupied {
        background-color: @background;
        color: @color4;
      }

      #workspaces button.active,
      #tags button.focused {
        background-color: @color2;
        color: @foreground;
      }

      #workspaces button.urgent,
      #tags button.urgent {
        background-color: @color9;
      }
    '';
  };
}
