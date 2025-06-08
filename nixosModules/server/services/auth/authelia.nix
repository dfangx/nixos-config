{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "auth.${hostName}.${domain}";
in
{
  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [
        "authelia"
      ];
      ensureUsers = [
        {
          name = "cyrusng";
          ensurePermissions = {
            "DATABASE \"\authelia\"" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    redis = {
      servers."authelia" = {
        enable = true;
        bind = "127.0.0.1";
        port = 6379;
      };
    };

    nginx.virtualHosts."${fqdn}" = {
      useACMEHost = "${hostName}.${domain}";
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:9091/";
    };
  };

  networking.firewall.interfaces."cni-podman0" = {
    allowedUDPPorts = [ 6379 ];
    allowedTCPPorts = [ 6379 ];
  };

  virtualisation.oci-containers.containers = {
    authelia = {
      image = "authelia/authelia";
      volumes = [
        "/var/lib/authelia/config:/config"
        "/var/lib/authelia/secrets:/secrets"
      ];
      # ports = [
      #   "9091:9091"
      # ];
      extraOptions = [
        "--network=host"
      ];
      environment = {
        AUTHELIA_JWT_SECRET_FILE = "/secrets/JWT_SECRET";
        AUTHELIA_SESSION_SECRET_FILE = "/secrets/SESSION_SECRET";
        AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE = "/secrets/STORAGE_PASSWORD";
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/secrets/STORAGE_ENCRYPTION_KEY";
      };
    };
  };
}

