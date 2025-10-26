{ config, lib, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "vpn.${hostName}.${domain}";
in
{
  options.wireguard.enable = lib.mkEnableOption "Enable wireguard";
  config = lib.mkIf config.wireguard.enable {
    age.secrets = {
      wireguard = {
        file = ../secrets/wireguard.age;
        mode = "400";
      };

      # oneplus 8T
      wgPskPeer0 = {
        file = ../secrets/wgPskPeer0.age;
        mode = "400";
      };

      # Asus Zenbook
      wgPskPeer1 = {
        file = ../secrets/wgPskPeer1.age;
        mode = "400";
      };

      # Rachel iPhone
      wgPskPeer2 = {
        file = ../secrets/wgPskPeer2.age;
        mode = "400";
      };

      # Thinkpad X1 Yoga
      wgPskPeer3 = {
        file = ../secrets/wgPskPeer3.age;
        mode = "400";
      };

      # regulus
      wgPskPeer4 = {
        file = ../secrets/wgPskPeer4.age;
        mode = "400";
      };
    };

    services = {
      wg-access-server = {
        enable = true;
        secretsFile = config.age.secrets.wireguard.path;
        settings = {
          httpHost = "127.0.0.1";
          externalHost = fqdn;
          port = 8000;
          auth.oidc = {
            name = "Authentik";
            issuer = "https://auth.slothpi.duckdns.org/application/o/wireguard/";
            redirectURL = "https://vpn.slothpi.duckdns.org/callback";
            clientID = "DLSe0D2zWq8Ws0CowlMVSapWWikTFXJMM8acpHc2";
            scopes = [
              "openid"
            ];
            "wireguard.port" = 51820;
            # claimMapping.admin = "'authentik Admins' in groups";
          };
        };
      };

      nginx = {
        virtualHosts."${fqdn}" = {
          useACMEHost = "${hostName}.${domain}";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString config.services.wg-access-server.settings.port}/";
            };
          };
        };
      };
    };

    networking = {
      firewall = {
        allowedUDPPorts = [ config.services.wg-access-server.settings."wireguard.port" ];
      };
    };
  };
}
