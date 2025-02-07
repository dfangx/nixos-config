{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "ldap.${hostName}.${domain}";
  basedn = "dc=nixos-test,dc=duckdns,dc=org";
  schemaDir = "/etc/nixos/services/auth/schemas";
in
{
  services = {
    openldap = {
      enable = true;
      urlList = [
        "ldap://127.0.0.1/"
        "ldap://[::1]/"
        "ldap://${fqdn}/"
        "ldap://10.88.0.1/"
      ];
      settings = {
        children = {
          "cn=schema" = {
            attrs = {
              objectClass = "olcSchemaConfig";
              cn = "schema";
            };
            includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              "${schemaDir}/rfc2307bis.schema"
            ];
          };
          "olcDatabase=config" = {
            attrs = {
              objectClass = "olcDatabaseConfig";
              olcDatabase = "config";
              olcRootDN = "cn=admin,${basedn}";
            };
          };
          "olcDatabase=mdb" = {
            attrs = {
              objectClass = [
                "olcDatabaseConfig"
                "olcMdbConfig"
              ];
              olcDatabase = "mdb";
              olcSuffix = "${basedn}";
              olcRootDN = "cn=admin,${basedn}";
              olcRootPW = "{SSHA}t2E3A9/QYgaxN8YVvWyZ2CiBYs/Tt8bO"; 
              olcDbDirectory = "/var/lib/openldap/openldap-data";
              olcDbIndex = [
                "objectClass eq"
                "uid pres,eq"
                "mail pres,sub,eq"
                "cn,sn pres,sub,eq"
                "dc eq"
              ];
            };
          };
        };
        attrs = {
          objectClass = "olcGlobal";
          cn = "config";
        };
      };
    };

    nginx.virtualHosts."${fqdn}" = {
      # enableACME = true;
      useACMEHost = "${hostName}.${domain}";
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:62534/";
    };
  };

  networking.firewall.interfaces."cni-podman0" = {
    allowedUDPPorts = [ 389 ];
    allowedTCPPorts = [ 389 ];
  };

  virtualisation.oci-containers.containers = {
    ldapui = {
      image = "wheelybird/ldap-user-manager";
      environment = {
        SERVER_HOSTNAME = fqdn;
        LDAP_URI = "ldap://host.containers.internal";
        LDAP_BASE_DN = basedn;
        LDAP_ADMIN_BIND_DN = "cn=admin,${basedn}";
        LDAP_ADMIN_BIND_PWD = "admin";
        LDAP_ADMINS_GROUP = "admins";
        NO_HTTPS = "TRUE";
        USERNAME_FORMAT = "{first_name}{last_name}";
        # REMOTE_HTTP_HEADERS_LOGIN = "TRUE";
        # SESSION_DEBUG = "TRUE";
        # LDAP_DEBUG = "TRUE";
        # LDAP_VERBOSE_CONNECTION_LOGS = "TRUE";
      };
      ports = [
        "62534:80"
      ];
    };
  };
}
