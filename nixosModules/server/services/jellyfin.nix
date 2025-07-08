{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "media.${hostName}.${domain}";
in
{
  options.jellyfin.enable = lib.mkEnableOption "Enable jellyfin";
  config = lib.mkIf config.jellyfin.enable {
    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
      };
      nginx.virtualHosts."${fqdn}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8096";
          };
        };
      };
    };
  };
}
