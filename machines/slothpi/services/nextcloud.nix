{ config, pkgs, lib, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "nextcloud.${hostName}.${domain}";
  nextcloudExcludes = pkgs.writeText "sync-exclude.lst" ''
    # This file contains fixed global exclude patterns
    
    ~$*
    .~lock.*
    ~*.tmp
    ]*.~*
    ]Icon\r*
    ].DS_Store
    ].ds_store
    *.textClipping
    ._*
    ]Thumbs.db
    ]photothumb.db
    System Volume Information

    .*.sw?
    .*.*sw?

    ].TemporaryItems
    ].Trashes
    ].DocumentRevisions-V100
    ].Trash-*
    .fseventd
    .apdisk
    .Spotlight-V100

    .directory

    *.part
    *.filepart
    *.crdownload

    *.kate-swp
    *.gnucash.tmp-*

    .synkron.*
    .sync.ffs_db
    .symform
    .symform-store
    .fuse_hidden*
    *.unison
    .nfs*

    # (default) metadata files created by Syncthing
    .stfolder
    .stignore
    .stversions

    My Saved Places.

    \#*#

    *.sb-*
  '';
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
      package = pkgs.nextcloud29;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit previewgenerator;
        # memories = pkgs.fetchNextcloudApp rec {
        #   url = "https://github.com/pulsejet/memories/releases/download/v6.1.5/memories.tar.gz";
        #   sha256 = "sha256-VSRQmvfnCkUetOQmGODqPrXK2vlLjiK9hOZvoOO84Oc=";
        #   license = "agpl3";
        # };
      };
      hostName = fqdn;
      configureRedis = true;
      caching = {
        apcu = true;
        redis = true;
      };
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
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
        "output_buffering" = "off";
      };
      settings = {
        default_phone_region = "CA";
        enabledPreviewProviders = [
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
        ];
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
          # ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
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
          ExecStart= "${pkgs.bash}/bin/bash -c \"${pkgs.nextcloud-client}/bin/nextcloudcmd -h -u ${config.services.nextcloud.config.adminuser} -p $(cat ${config.services.nextcloud.config.adminpassFile}) --exclude ${nextcloudExcludes} --path /music /var/lib/music https://nextcloud.slothpi.duckdns.org\""; 
          TimeoutStopSec = "180";
          KillMode = "process";
          KillSignal = "SIGINT";
          User = "nextcloud";
          Group = "music";
          UMask = "007";
        };
        wantedBy = ["multi-user.target"];
      };
      nextcloud-preview-generator = {
        unitConfig = {
          Description = "Auto sync Nextcloud";
          After = "network-online.target"; 
        };
        serviceConfig = {
          Type = "simple";
          ExecStart= "${lib.getExe config.services.nextcloud.occ} preview:pre-generate"; 
          TimeoutStopSec = "180";
          KillMode = "process";
          KillSignal = "SIGINT";
          User = "nextcloud";
        };
        wantedBy = ["multi-user.target"];
      };
    };
    timers = {
      nextcloud-autosync = {
        unitConfig.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
        timerConfig.OnUnitActiveSec = "60min";
        wantedBy = ["multi-user.target" "timers.target"];
      };
      nextcloud-preview-generator = {
        unitConfig.Description = "Automatically generate photo previews";
        timerConfig.OnUnitActiveSec = "10min";
        wantedBy = ["multi-user.target" "timers.target"];
      };
    };
  };

}
