{ config, lib, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "calendar.${hostName}.${domain}";
in
{
  options.radicale.enable = lib.mkEnableOption "Enable radicale";
  config = lib.mkIf config.radicale.enable {
    services = {
      radicale = {
        enable = true;
        settings = {
          auth = {
            type = "ldap";
            ldap_uri = "ldap://localhost:3389";
            ldap_base = "DC=ldap,DC=radicale,DC=slothpi,DC=duckdns,DC=org";
            ldap_reader_dn = "cn=ldapservice,ou=users,DC=ldap,DC=radicale,DC=slothpi,DC=duckdns,DC=org";
            ldap_secret_file = config.age.secrets.radicale-ldap-bind.path;
            ldap_filter = "(&(objectClass=user)(cn={0}))";
            ldap_user_attribute = "cn";
            ldap_ignore_attribute_create_modify_timestamp = true;
            lc_username = true;
            # type = "htpasswd";
            # htpasswd_filename = config.age.secrets.radicale.path;
            # htpasswd_encryption = "bcrypt";
          };
        };
      };

      nginx.virtualHosts."${fqdn}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:5232/";
            extraConfig = ''
              proxy_set_header  X-Forwarded-Port $server_port;
              proxy_pass_header Authorization;
            '';
          };
        };
      };
    };

    age.secrets = {
      radicale-ldap-bind = {
        file = ../secrets/ldap-bind.age;
        owner = "radicale";
      };
    };

    age.secrets.radicale = {
      file = ../secrets/radicale.age;
      owner = "radicale";
      group = "radicale";
    };
  };
}
