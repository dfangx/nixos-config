{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "calendar.${hostName}.${domain}";
in
{
  options.baikal.enable = lib.mkEnableOption "Enable baikal";
  config = lib.mkIf config.baikal.enable {
    services = {
      baikal = {
        enable = true;
        virtualHost = fqdn;
      };
      nginx.virtualHosts."${fqdn}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
      };
    };
  };
}
