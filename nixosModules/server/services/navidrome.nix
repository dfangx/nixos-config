{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "music.${hostName}.${domain}";
in
{
  options.navidrome.enable = lib.mkEnableOption "Enable navidrome";
  config = lib.mkIf config.navidrome.enable {
    services = {
      navidrome = {
        enable = true;
        settings = {
          MusicFolder = "/srv/nfs/music";
          Port = 4533;
          DefaultTheme = "Nord";
          LastFM = {
            ApiKey = "a8d8d142450b9342682f5fc5599d2b6a";
            Secret = "f3d869d8784379d2feccebb8bc629a19";
          };
          Backup = {
            Path = "/var/lib/navidrome/backups";
            Count = 7;
            Schedule = "00 01 * * *";    # Backup every day at 01:00
          };
        };
      };

      nginx.virtualHosts."${fqdn}" = {
        # enableACME = true;
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.navidrome.settings.Port}/";
      };
    };

    users = {
      users.navidrome = {
        isSystemUser = true;
        extraGroups = [ "music" ];
      };
      groups.music = { };
    };

    system.activationScripts.makeMusicDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${config.services.navidrome.settings.MusicFolder}
      chown nextcloud:music ${config.services.navidrome.settings.MusicFolder}
      chmod 770 ${config.services.navidrome.settings.MusicFolder}
    '';
  };
}
