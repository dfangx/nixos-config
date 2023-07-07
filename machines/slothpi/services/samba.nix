{ config, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ 137 139 ];
    allowedTCPPorts = [ 139 445 ];
  };

  services = {
    samba-wsdd.enable = true;
    samba = {
      enable = true;
      securityType = "user";
      extraConfig = ''
        workgroup = FAMILY
        server string = nixos-test
        server role = standalone server
        hosts allow = 192.168.0. 127. 10.200.200. localhost 192.168.122.
        hosts deny = 0.0.0.0
        log file = /var/log/samba/%m
        max log size = 50
        guest account = nobody
      '';
      shares = {
        public = {
          path = "/srv/public";
          writable = "yes";
          browseable = "yes";
        };
        private = {
        };
        homes = {
          browseable = "no";
          writable = "yes";
        };
      };
    };
  };
}
