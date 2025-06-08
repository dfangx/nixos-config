{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "etebase.${hostName}.${domain}";
  etebaseSocketDir = "/run/etebase-server";
in
{
  options.etebase.enable = lib.mkEnableOption "Enable Etebase Calendar";
  config = lib.mkIf config.etebase.enable {
    # security.acme.certs."${fqdn}" = { };
    age.secrets = {
      etebase = {
        file = ../secrets/fireflyIII.age;
        mode = "400";
        owner = "etebase-server";
      };
    };

    services = {
      etebase-server = {
        enable = true;
        unixSocket = "${etebaseSocketDir}/etebase-server.sock";
        settings = {
          global.secret_file = config.age.secrets.etebase.path;
          allowed_hosts.allowed_host1 = fqdn;
        };
      };

      etesync-dav.enable = true;

      nginx.upstreams.etebase.extraConfig = ''
        server unix://${config.services.etebase-server.unixSocket};
      '';

      nginx.virtualHosts."${fqdn}" = {
        # enableACME = true;
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations = {
          "/static/".alias = "/var/lib/etebase-server/static/";
          "/".proxyPass = "http://etebase";
          "/dav/".proxyPass = "http://localhost:37358";
        };
      };
      nginx.virtualHosts."etebase-dav.${hostName}.${domain}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations = {
          "/".proxyPass = "http://localhost:37358";
        };
      };
    };

    system.activationScripts.makeEtebaseDir.text = ''
      mkdir -p ${etebaseSocketDir}
      chown ${config.services.etebase-server.user}:${config.services.etebase-server.user} ${etebaseSocketDir}
    '';
  };
}


