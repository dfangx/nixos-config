{ lib, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];

  desktop.enable = true;

  home = {
    packages = with pkgs; [
      xournalpp
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
