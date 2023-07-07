{ config, lib, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "${hostName}.${domain}";
  unboundLogDir = "/var/log/unbound";
in
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
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
        cache-min-ttl = 3600;
        cache-max-ttl = 86400;
        edns-buffer-size = 1232;
        do-ip4 = "yes";
        do-ip6 = "yes";
        do-udp = "yes";
        do-tcp = "yes";
        harden-glue = true;
        harden-dnssec-stripped = true;
        harden-below-nxdomain = true;
        use-caps-for-id = false;
        private-address = [
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
          "\"${fqdn} A 192.168.0.116\""
        ];
      };
      remote-control.control-enable = true;
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 1048576;
    "net.core.wmem_max" = 1048576;
  };
}
