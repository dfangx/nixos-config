{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    settings.bar = {
      modules-right = [
        "tray"
        "bluetooth"
        "wireplumber"
        "network"
        "battery"
        "cpu"
        "memory"
      ];
    };
    style = ''
      window#waybar {
        background-color: #3b4252;
        color: #e5e9f0;
        font-family: "Source Code Pro for Powerline";
        font-size: 15px;
      }

      .modules-left {
        margin-left: 20px;
      }

      .modules-right {
        margin-right: 20px;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #tray,
      #bluetooth,
      #wireplumber,
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

      #workspaces button:hover,
      #tags button:hover {
        background-color: #4c566a;
        border-color: #4c566a;
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
  };
}
