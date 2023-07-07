{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "music.${hostName}.${domain}";
in
{
  # security.acme.certs."${fqdn}" = { };

  services = {
    navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/var/lib/music";
        Port = 4533;
        DefaultTheme = "Nord";
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
      group = "music";
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
}

