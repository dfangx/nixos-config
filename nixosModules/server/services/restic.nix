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

    services.restic.backups.slothpi = {
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
        "/var/lib/acme"
        "/var/lib/authentik"
        "/var/lib/bitwarden_rs"
        "/var/lib/blocky"
        "/var/lib/dhcpcd"
        "/var/lib/dnsmasq"
        "/var/lib/grafana"
        "/var/lib/homepage-dashboard"
        "/var/lib/immich"
        "/var/lib/jellyfin"
        "/var/lib/mysql"
        "/var/lib/navidrome"
        "/var/lib/postgresql"
        "/var/lib/private"
        "/var/lib/prometheus2"
        "/var/lib/radicale"
        "/var/lib/redis-immich"
        "/var/lib/redis-authentik"
        "/var/lib/unbound"
        "/var/lib/wg-access-server"
      ];
      repository = "/mnt/backup/slothpi";
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
