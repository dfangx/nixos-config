{ config, lib, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
  unboundLogDir = "/var/log/unbound";
in
{
  options.unbound.enable = lib.mkEnableOption "Enable unbound";
  config = lib.mkIf config.unbound.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          logfile = "${unboundLogDir}/unbound.log";
          verbosity = 1;
          num-threads = 4;
          infra-cache-slabs = 4;
          rrset-cache-slabs = 4;
          msg-cache-slabs = 4;
          key-cache-slabs = 4;
          interface = "127.0.0.1";
          port = 57863;
          prefer-ip6 = false;
          so-rcvbuf = "1m";
          so-sndbuf = "1m";
          so-reuseport = true;
          prefetch = true;
          prefetch-key = true;
          serve-expired = true;
          serve-expired-ttl = 86400;
          serve-expired-client-timeout = 1800;
          cache-min-ttl = 3600;
          cache-max-ttl = 86400;
          edns-buffer-size = 1232;
          do-ip4 = true;
          do-ip6 = false;
          do-udp = true;
          do-tcp = true;
          harden-glue = true;
          harden-dnssec-stripped = true;
          harden-below-nxdomain = true;
          use-caps-for-id = false;
          private-address = [
            "192.168.2.0/24" 
            "192.168.0.0/16" 
            "169.254.0.0/16" 
            "172.16.0.0/12" 
            "10.0.0.0/8" 
            "fd00::/8" 
          ];
          local-zone = [
            "\"${fqdn}\" redirect"
          ];
          local-data = [
            "\"${fqdn} A 192.168.2.2\""
          ];
        };
        remote-control = {
          control-enable = true;
          control-interface = "127.0.0.1";
          control-port = 8953;
          server-key-file = "/etc/unbound/unbound_server.key";
          server-cert-file = "/etc/unbound/unbound_server.pem";
          control-key-file = "/etc/unbound/unbound_control.key";
          control-cert-file = "/etc/unbound/unbound_control.pem";
        };
      };
    };

    boot.kernel.sysctl = {
      "net.core.rmem_max" = 1048576;
      "net.core.wmem_max" = 1048576;
    };
  };
}
