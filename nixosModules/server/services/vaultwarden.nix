{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "vaultwarden.${hostName}.${domain}";
in
{
  options.vaultwarden.enable = lib.mkEnableOption "Enable vaultwarden";
  config = lib.mkIf config.vaultwarden.enable {
    services = {
      vaultwarden = {
        enable = true;
        backupDir = "/var/backup/vaultwarden";
        config = {
          ROCKET_PORT = 8754;
          ROCKET_ADDRESS = "127.0.0.1";
          DOMAIN = "https://${fqdn}";
          ADMIN_TOKEN = "$argon2id$v=19$m=19456,t=2,p=1$WFZBNE1hVExaZ2tYOWJ1WnNvOU9FOVBDVzJGN051MXE4dHh5dUc4bVZpQT0$yjtsulF35E588VAuMVj6N8ZSj8XNLR94mCtbA27ce7M";
        };
      };

      nginx = {
        virtualHosts."${fqdn}" = {
          useACMEHost = "${hostName}.${domain}";
          forceSSL = true;
          locations."/".proxyPass = "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        };
      };

      bitwarden-directory-connector-cli = {
        enable = true;
        domain = "https://${fqdn}";
        ldap = {
          rootPath = "DC=ldap,DC=vaultwarden,DC=slothpi,DC=duckdns,DC=org";
          port = 3389;
          hostname = "auth.slothpi.duckdns.org";
          username = "cn=ldapservice,ou=users,DC=ldap,DC=vaultwarden,DC=slothpi,DC=duckdns,DC=org";
        };
        secrets = {
          ldap = config.age.secrets.bw-ldap-bind.path;
          bitwarden = {
            client_path_secret = config.age.secrets.bw-client-secret.path;
            client_path_id = config.age.secrets.bw-client-id.path;
          };
        };
        sync = {
          users = true;
          groups = true;
          removeDisabled = true;
        };
      };
    };
    age.secrets = {
      bw-ldap-bind = {
        file = ../secrets/ldap-bind.age;
        owner = config.services.bitwarden-directory-connector-cli.user;
      };
      bw-client-id = {
        file = ../secrets/bitwarden-client-id.age;
        owner = config.services.bitwarden-directory-connector-cli.user;
      };
      bw-client-secret = {
        file = ../secrets/bitwarden-client-secret.age;
        owner = config.services.bitwarden-directory-connector-cli.user;
      };
    };
  };
}
