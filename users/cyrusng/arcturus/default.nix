{ pkgs, lib, pkgsStable, ... }:
{
  imports = [
    ../desktop.nix
    ./programs/waybar.nix
    ./programs/hyprland.nix
    ./services/hyprpaper.nix
  ];

  home = {
    packages = [
      pkgs.zoom-us
      pkgsStable.xournalpp
    ];
  };

  systemd = {
    user.services = {
      wvkbd = {
        Unit = {
          Description = "Virtual Keyboard";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe' pkgs.wvkbd "wvkbd-mobintl"} -L 480 --hidden";
        };
      };
    };
  };
}
