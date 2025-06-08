{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "vaultwarden.${hostName}.${domain}";
in
{
  options.vaultwarden.enable = lib.mkEnableOption "Enable vaultwarden";
  config = lib.mkIf config.vaultwarden.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      config = {
        ROCKET_PORT = 8754;
        ROCKET_ADDRESS = "127.0.0.1";
        DOMAIN = "https://${fqdn}";
        ADMIN_TOKEN = "$argon2id$v=19$m=19456,t=2,p=1$WFZBNE1hVExaZ2tYOWJ1WnNvOU9FOVBDVzJGN051MXE4dHh5dUc4bVZpQT0$yjtsulF35E588VAuMVj6N8ZSj8XNLR94mCtbA27ce7M";
      };
    };

    services.nginx = {
      virtualHosts."${fqdn}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations."/".proxyPass = "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };
    };
  };
}
