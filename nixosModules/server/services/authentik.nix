{ inputs, config, lib, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "auth.${hostName}.${domain}";
in
{
  imports = [
    inputs.authentik.nixosModules.default
  ];

  options.authentik.enable = lib.mkEnableOption "Enable authentik";

  config = lib.mkIf config.authentik.enable {
    age.secrets = {
      authentik.file = ../secrets/authentik.age;
      authentik-ldap.file = ../secrets/authentik-ldap.age;
    };

    services = {
      authentik = {
        enable = true;
        environmentFile = config.age.secrets.authentik.path;
        settings = {
          disable_startup_analytics = true;
        };
        nginx = {
            enable = true;
            host = fqdn;
        };
      };
      nginx.virtualHosts."${fqdn}" = {
          useACMEHost = "${hostName}.${domain}";
          forceSSL = lib.mkForce true;
      };
      authentik-ldap = {
        enable = true;
        environmentFile = config.age.secrets.authentik-ldap.path;
      };
    };
  };
}
