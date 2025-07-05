{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "auth.${hostName}.${domain}";
in
{
  options.keycloak.enable = lib.mkEnableOption "Enable keycloak";
  config = lib.mkIf config.keycloak.enable {
    age.secrets.keycloak.file = ../secrets/keycloak.age;
    services = {
      keycloak = {
        enable = true;
        settings = {
          hostname = fqdn;
          http-enabled = true;
          proxy-headers  = "xforwarded";
          http-port = 46349;
          optimize = true;
          # proxy-trusted-addresses = [
          #   "music.slothpi.duckdns.org"
          #   "pictures.slothpi.duckdns.org"
          #   "dashboards.slothpi.duckdns.org"
          #   "radicale.slothpi.duckdns.org"
          # ];
        };
        database = {
          type = "postgresql";
          passwordFile = config.age.secrets.keycloak.path;
        };
      };
      nginx.virtualHosts."${fqdn}" = {
          useACMEHost = "${hostName}.${domain}";
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:${toString config.services.keycloak.settings.http-port}/";
      };
    };
  };
}
