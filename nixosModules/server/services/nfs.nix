{ config, lib, ... }:
{
  options.nfs.enable = lib.mkEnableOption "Enable nfs";
  config = lib.mkIf config.nfs.enable {
    networking.firewall = {
      # allowedTCPPorts = [ 2049 ];
      allowedTCPPorts = [ 111  2049 4000 4001 4002 20048 ];
      allowedUDPPorts = [ 111 2049 4000 4001  4002 20048 ];
    };

    fileSystems = {
      "/srv/nfs/music" = {
        device = "/var/lib/music";
        options = [ "bind" ];
      };
    };

    services.nfs = {
      server = {
        enable = true;
        lockdPort = 4001;
        mountdPort = 4002;
        statdPort = 4000;
        exports = ''
          /srv/nfs          192.168.2.0/24(rw,fsid=0,sync,no_subtree_check,root_squash) 10.0.0.0/8(rw,fsid=0,sync,no_subtree_check,root_squash,anonuid=1000,anongid=100)
          /srv/nfs/music    192.168.2.0/24(rw,sync,crossmnt,root_squash,anonuid=1000,anongid=100) 10.0.0.0/8(rw,sync,crossmnt,root_squash,anonuid=1000,anongid=100) 
        '';
        createMountPoints = true;
      };
      settings = {
        nfsd = {
          rdma = true;
          vers2 = false;
          vers3 = true;
          vers4 = true;
        };
      };
    };

    boot.extraModprobeConfig = ''
      options nfsd nfs4_disable_idmapping=N
    '';
  };
}
