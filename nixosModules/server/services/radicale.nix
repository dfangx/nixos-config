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
            # type = "http_x_remote_user";
            # type = "ldap";
            # ldap_uri = "ldap://auth.slothpi.duckdns.org:3389";
            # ldap_base = "dc=ldap,dc=goauthentik,dc=io";
            # ldap_reader_dn = "cn=cyrusng,ou=users,dc=ldap,dc=goauthentik,dc=io";
            # ldap_secret_file = config.age.ldapbind.path;
            # ldap_filter = "(objectClass=user)";
            # ldap_ignore_attribute_create_modify_timestamp = true;
            type = "htpasswd";
            htpasswd_filename = config.age.secrets.radicale.path;
            htpasswd_encryption = "bcrypt";
          };
        };
      };

      nginx.virtualHosts."${fqdn}" = {
        useACMEHost = "${hostName}.${domain}";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:5232/";
          };
        };
      };
    };

    age.secrets.radicale = {
      file = ../secrets/radicale.age;
      owner = "radicale";
      group = "radicale";
    };
  };
}
