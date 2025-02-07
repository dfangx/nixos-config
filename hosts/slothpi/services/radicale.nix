{ config, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "calendar.${hostName}.${domain}";
in
{
  # security.acme.certs."${fqdn}" = { };

  services = {
    radicale = {
      enable = true;
      settings = {
        auth = {
          type = "htpasswd";
          htpasswd_filename = config.age.secrets.radicale.path;
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    nginx.virtualHosts."${fqdn}" = {
      useACMEHost = "${hostName}.${domain}";
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:5232/";
    };
  };

  age.secrets.radicale = {
    file = ../secrets/radicale.age;
    owner = "radicale";
    group = "radicale";
  };
}


