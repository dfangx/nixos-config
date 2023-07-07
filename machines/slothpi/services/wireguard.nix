{ config, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "vpn.${hostName}.${domain}";
in
{
  age.secrets = {
    wireguard = {
      file = ../secrets/wireguard.age;
      mode = "400";
    };
    wgPskPeer0 = {
      file = ../secrets/wgPskPeer0.age;
      mode = "400";
    };
    wgPskPeer1 = {
      file = ../secrets/wgPskPeer1.age;
      mode = "400";
    };
    wgPskPeer2 = {
      file = ../secrets/wgPskPeer1.age;
      mode = "400";
    };
  };

  networking = {
    nat = {
      enable = true;
      externalInterface = "end0";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];
    };

    wireguard.interfaces.wg0 = {
      ips = [ "10.200.200.1/24" ];
      listenPort = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i end0 -j ACCEPT;
        ${pkgs.iptables}/bin/iptables -A FORWARD -o end0 -j ACCEPT;
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o end0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i end0 -j ACCEPT; 
        ${pkgs.iptables}/bin/iptables -D FORWARD -o end0 -j ACCEPT; 
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o end0 -j MASQUERADE
      '';
      generatePrivateKeyFile = true;
      privateKeyFile = config.age.secrets.wireguard.path;

      peers = [
        {
          publicKey = "7J5JPNT4BlZjDrrbclVMhmYcm87TF6Qn5JW8LWCOPgc=";
          presharedKeyFile = config.age.secrets.wgPskPeer0.path;
          allowedIPs = [ "10.200.200.2/32" ];
        }
        {
          publicKey = "KVkRx9Uv1uY7VQhVpHuOeYvcrVedyaGD+WnWIxr9Png=";
          presharedKeyFile = config.age.secrets.wgPskPeer1.path;
          allowedIPs = [ "10.200.200.3/32" ];
        }
        {
          publicKey = "Ka+n3OpeGDjqVUa6Hwal4KOfZVx39SVJ1aPqcTe4t3s=";
          # presharedKeyFile = config.age.secrets.wgPskPeer2.path;
          allowedIPs = [ "10.200.200.4/32" ];
        }
      ];
    };
  };
}
