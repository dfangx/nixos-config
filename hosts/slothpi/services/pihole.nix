{ config, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "pihole.${hostName}.${domain}";
in
{
  # security.acme.certs."${fqdn}" = { };

  networking = {
    firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 4711 ];
    };

    nameservers = [
      "127.0.0.1"
      "::1"
    ];
  };

  systemd.services.podman-pihole = {
    after = [ "network.target" ];
    wants = [ "unbound.service" ];
    wantedBy = [ "multi-user.target" ];
  };

  services.nginx.virtualHosts."${fqdn}" = {
    # enableACME = true;
    useACMEHost = "${hostName}.${domain}";
    forceSSL = true;
    locations."/".proxyPass = "http://localhost:64137";
  };

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    # user = "pihole:pihole";
    volumes = [ 
      "/var/lib/pihole:/etc/pihole" 
      "/var/lib/dnsmasq.d:/etc/dnsmasq.d"
    ];
    # ports = [
    #   "53:53/tcp"
    #   "53:53/udp"
    #   "127.0.0.1:64137:80"
    # ];
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--net=host"
      "--dns=127.0.0.1"
      "--dns=::1"
      # "--ip=10.88.0.2"
    ];
    environment = {
      TZ = config.time.timeZone;
      PIHOLE_DNS_ = "127.0.0.1#57863";
      # PIHOLE_DNS_ = "10.88.0.1#57863";
      WEBPASSWORD = "admin";
      CUSTOM_CACHE_SIZE = "0";
      WEB_PORT = "64137";
      VIRTUAL_HOST = fqdn;
      DNSMASQ_LISTENING = "local";
      DNS_FQDN_REQUIRED = "true";
      DNS_BOGUS_PRIV = "true";
      FTLCONF_LOCAL_IPV4 = "127.0.0.1";
      FTLCONF_LOCAL_IPV6 = "::1";
      INTERFACE = "enp1s0";
      # REV_SERVER = "true";
      # REV_SERVER_TARGET = "10.88.0.1"; # Router IP.
      # REV_SERVER_CIDR = "10.88.0.0/16";
      # CORS_HOSTS = "pihole.nixos-test.duckdns.org";
    };
  };
}



