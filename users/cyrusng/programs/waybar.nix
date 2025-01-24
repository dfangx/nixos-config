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

      #custom-osk,
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
    systemd = {
      enable = true;
    };
  };

  systemd.user.services.waybar.Unit.After = lib.mkForce "graphical-session.target";
}
