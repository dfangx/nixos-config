{ pkgs, ... }:
let
  backup = pkgs.callPackage ../../../pkgs/backup { };
in
{
  systemd.user  = {
    timers."backup" = {
      Unit.Description = "Backup home biweekly";
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnCalendar = "*-*-1,15 0:00:00";
        Persistent = true;
      };
    };
  
    services."backup" = {
      Unit.Description = "Backup script";
      Service.ExecStart = "${backup}/bin/backup";
    };
  };
}
