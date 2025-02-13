{ config, lib, pkgs, ... }:
let
  backup = pkgs.callPackage ../../../pkgs/backup { };
in
{
  options.backup.enable = lib.mkEnableOption "Enable backup";
  config = lib.mkIf config.backup.enable {
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
  };
}
