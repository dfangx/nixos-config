{ config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "pictures.${hostName}.${domain}";
in
{
  options.immich.enable = lib.mkEnableOption "Enable Immich";
  config = lib.mkIf config.immich.enable {
    services = {
      immich = {
        enable = true;
        port = 23456;
        accelerationDevices = [ "/dev/dri/renderD128" ];
        machine-learning.enable = false;
        host = "0.0.0.0";
        openFirewall = true;
      };
      nginx.virtualHosts."${fqdn}" = {
        # enableACME = true;
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.immich.port}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    };

    users.users.immich.extraGroups = [ "video" "render" "users" ];

    hardware.graphics.enable = true;
  };
}
