{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "system.${hostName}.${domain}";
in
{
  options.glances.enable = lib.mkEnableOption "Enable glances";
  config = lib.mkIf config.glances.enable {
    services = {
      glances = {
        enable = true;
        port = 54578;
        extraArgs = [
          "--webserver"
        ];
      };
      nginx = {
        virtualHosts."${fqdn}" = {
          # enableACME = true;
          useACMEHost = "${hostName}.${domain}";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.glances.port}/";
            };
          };
        };
      };
    };
  };
}
