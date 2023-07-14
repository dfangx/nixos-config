{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "nextcloud.${hostName}.${domain}";
in
{
  age.secrets = {
    nextcloud = {
      file = ../secrets/nextcloud.age;
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = fqdn;
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        adminuser = "cyrusng";
        adminpassFile = config.age.secrets.nextcloud.path;
      };
      https = true;
      nginx = {
        recommendedHttpHeaders = true;
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
        }
      ];
    };

    nginx.virtualHosts."${fqdn}" = {
      # enableACME = true;
      useACMEHost = "${hostName}.${domain}";
      forceSSL = true;
    };
  };

  users.users.nextcloud.extraGroups = [ "music" ];

  systemd = {
    services = {
      nextcloud-setup = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };

      nextcloud-autosync = {
        unitConfig = {
          Description = "Auto sync Nextcloud";
          After = "network-online.target"; 
        };
        serviceConfig = {
          Type = "simple";
          ExecStart= "${pkgs.bash}/bin/bash -c \"${pkgs.nextcloud-client}/bin/nextcloudcmd -h -u ${config.services.nextcloud.config.adminuser} -p $(cat ${config.services.nextcloud.config.adminpassFile}) --path /music /var/lib/music https://nextcloud.slothpi.duckdns.org\""; 
          TimeoutStopSec = "180";
          KillMode = "process";
          KillSignal = "SIGINT";
          User = "nextcloud";
          Group = "music";
          UMask = "007";
        };
        wantedBy = ["multi-user.target"];
      };
    };
    timers.nextcloud-autosync = {
      unitConfig.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
      timerConfig.OnUnitActiveSec = "60min";
      wantedBy = ["multi-user.target" "timers.target"];
    };
  };
}
