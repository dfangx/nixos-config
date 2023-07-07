{ config, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 2049 ];
  };

  fileSystems = {
    "/srv/nfs/music" = {
      device = "/var/lib/music";
      options = [ "bind" "x-systemd.automount" "noauto" ];
    };
  };

  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /srv/nfs          192.168.0.0/24(rw,fsid=0,sync,no_subtree_check) nixos-test.duckdns.org(rw,fsid=0,sync,no_subtree_check) 10.0.0.0/8(rw,fsid=0,sync,no_subtree_check) 192.168.122.1(rw,fsid=0,sync,no_subtree_check)
        /srv/nfs/music    192.168.0.0/24(rw,sync,crossmnt) nixos-test.duckdns.org(rw,sync,crossmnt) 10.0.0.0/8(rw,sync,crossmnt) 192.168.122.1(rw,sync,crossmnt) 
      '';
    };
  };
}
