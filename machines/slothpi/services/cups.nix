{ config, pkgs, ... }:

let
  inherit (config.networking) domain hostName;
  fqdn = "print.${hostName}.${domain}";
in
{
  networking.firewall = {
    allowedTCPPorts = [ 631 ];
  };

  services = {
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
      nssmdns = true;
    };

    printing = {
      enable = true;
      logLevel = "debug";
      drivers = with pkgs; [ 
        # samsung-unified-linux-driver 
        splix
        # gutenprint
      ];
      browsing = true;
      defaultShared = true;
      listenAddresses = [ ];
      extraConf = ''
        Port 61523
      '';
    };
    
    nginx.virtualHosts."${fqdn}" = {
      # enableACME = true;
      useACMEHost = "${hostName}.${domain}";
      forceSSL = true;
      listen = let 
          addrs = config.services.nginx.defaultListenAddresses;
        in
             (map (addr: { inherit addr; port = 443; ssl = true; }) addrs) 
          ++ (map (addr: { inherit addr; port = 80; ssl = false; }) addrs)
          ++ (map (addr: { inherit addr; port = 631; ssl = false; }) addrs);
      locations."/" = {
        proxyPass = "http://localhost:61523/";
        recommendedProxySettings = false;
        extraConfig = ''
          proxy_set_header Host "127.0.0.1";
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Host $server_name;
          proxy_redirect off;
        '';
      };
    };
  };
}
