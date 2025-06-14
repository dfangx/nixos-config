{ config, lib, pkgs, ... }:
let
  inherit (config.networking) domain hostName;
  fqdn = "vpn.${hostName}.${domain}";
in
{
  options.wireguard.enable = lib.mkEnableOption "Enable wireguard";
  config = lib.mkIf config.wireguard.enable {
    age.secrets = {
      wireguard = {
        file = ../secrets/wireguard.age;
        mode = "400";
      };

      # oneplus 8T
      wgPskPeer0 = {
        file = ../secrets/wgPskPeer0.age;
        mode = "400";
      };

      # Asus Zenbook
      wgPskPeer1 = {
        file = ../secrets/wgPskPeer1.age;
        mode = "400";
      };

      # Rachel iPhone
      wgPskPeer2 = {
        file = ../secrets/wgPskPeer2.age;
        mode = "400";
      };

      # Thinkpad X1 Yoga
      wgPskPeer3 = {
        file = ../secrets/wgPskPeer3.age;
        mode = "400";
      };

      # regulus
      wgPskPeer4 = {
        file = ../secrets/wgPskPeer4.age;
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
          ${pkgs.iptables}/bin/iptables -A FORWARD -i ${config.networking.nat.externalInterface} -j ACCEPT;
          ${pkgs.iptables}/bin/iptables -A FORWARD -o ${config.networking.nat.externalInterface} -j ACCEPT;
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ${config.networking.nat.externalInterface} -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i ${config.networking.nat.externalInterface} -j ACCEPT; 
          ${pkgs.iptables}/bin/iptables -D FORWARD -o ${config.networking.nat.externalInterface} -j ACCEPT; 
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ${config.networking.nat.externalInterface} -j MASQUERADE
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
            publicKey = "oyz7gkKth2WJwQWoNcqRoJge/bzwisgxkmUwtomt1GQ=";
            presharedKeyFile = config.age.secrets.wgPskPeer2.path;
            allowedIPs = [ "10.200.200.4/32" ];
          }
          {
            publicKey = "pEDH9TULaafSfuRKB24pTXRAs99tmR2fAmAxwV2lp3o=";
            presharedKeyFile = config.age.secrets.wgPskPeer3.path;
            allowedIPs = [ "10.200.200.5/32" ];
          }
          {
            publicKey = "Fa0sMrruLzit404InxFu29AKBAswtKesYx3ofp//OCI=";
            presharedKeyFile = config.age.secrets.wgPskPeer4.path;
            allowedIPs = [ "10.200.200.6/32" ];
          }
        ];
      };
    };
  };
}
