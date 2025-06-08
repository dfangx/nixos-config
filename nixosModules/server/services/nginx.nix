{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
in
{
  options.nginx.enable = lib.mkEnableOption "Enable nginx";
  config = lib.mkIf config.nginx.enable {
    age.secrets = {
      duckdns = {
        file = ../secrets/duckdns.age;
        mode = "400";
        owner = "acme";
        group = "acme";
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };

    security.acme = {
      defaults = {
        email = "cyrus.ng@protonmail.com";
        credentialsFile = config.age.secrets.duckdns.path;
        dnsProvider = "duckdns";
      };
      acceptTerms = true;
      certs = {
        "${hostName}.${domain}" = { 
          dnsProvider = "duckdns";
          extraDomainNames = [
            "*.${hostName}.${domain}"
          ];
        };
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
    };
  };
}




