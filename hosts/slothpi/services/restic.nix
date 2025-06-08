{ config, lib, pkgs, ... }:
{
  options.restic.enable = lib.mkEnableOption "Enable restic";
  config = lib.mkIf config.restic.enable {
    environment.systemPackages = with pkgs; [
      restic
    ];

    age.secrets = {
      restic = {
        file = ../secrets/restic.age;
      };
    };

    services.restic.backups.local = {
      initialize = true;
      passwordFile = config.age.secrets.restic.path;
      timerConfig = {
        OnCalendar = "*-*-* 03:00:00";
      };
      exclude = [
        "/home/*/.cache"
      ];
      paths = [ 
        "/srv" 
        "/home"
        "/var/lib/navidrome"
        "/var/lib/immich"
      ];
      repository = "/mnt/data/restic";
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
    };

    users.users.restic = {
      isNormalUser = true;
    };

    security.wrappers.restic = {
      source = "${pkgs.restic}/bin/restic";
      owner = "restic";
      group = "users";
      permissions = "u=rwx,g=,o=";
      capabilities = "cap_dac_read_search=+ep";
    };
  };
}
