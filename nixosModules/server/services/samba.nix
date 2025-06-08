{ config, lib, ... }:

{
  options.samba.enable = lib.mkEnableOption "Enable samba";
  config = lib.mkIf config.samba.enable {
    networking.firewall = {
      allowedUDPPorts = [ 137 139 ];
      allowedTCPPorts = [ 139 445 ];
    };

    services = {
      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
      samba = {
        enable = true;
        openFirewall = true;
        securityType = "user";
        settings = {
          global = {
            workgroup = "FAMILY";
            "server string" = "slothpi";
            "hosts allow" = [
              "192.168.2."
              "127." 
              "10.200.200."
              "localhost"
            ];
            "hosts deny" = [
              "0.0.0.0"
            ];
            "log file" = "/var/log/samba/%m";
            "vfs objects" = [ 
              "streams_xattr" 
            ];
            # "create mask" = 664;
            # "force create mode" = 664;
            # "directory mask" = 775;
            # "force directory mask" = 775;
            # "store dos attributes" = "no";
            "map archive" = "no";
            "map system" = "no";
            "map hidden" = "no";
          };
          music = {
            path = "/srv/nfs/music";
            writable = "yes";
            browseable = "yes";
          };
          data = {
            path = "/srv/nfs/data";
            writable = "yes";
            browseable = "yes";
          };
          pics = {
            path = "/srv/nfs/pics";
            writable = "yes";
            browseable = "yes";
          };
          vids = {
            path = "/srv/nfs/vids";
            writable = "yes";
            browseable = "yes";
          };
          homes = {
            browseable = "no";
            writable = "yes";
          };
        };
      };
    };
  };
}
