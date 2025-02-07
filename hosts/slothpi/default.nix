{ config, pkgs, lib, inputs, host, ... }:

{

  imports = [ 
    # ./hardware-configuration.nix
    #"${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ../common.nix
    # ./services/etebase.nix
    # ./services/auth.nix
    ./services/radicale.nix
    # ./services/nfs.nix
    # ./services/pihole.nix
    # ./services/samba.nix
    # ./services/monica.nix
    # ./services/firefly-iii.nix
    ./services/grafana.nix
    ./services/blocky.nix
    ./services/navidrome.nix
    ./services/nginx.nix
    ./services/cups.nix
    ./services/unbound.nix
    ./services/wireguard.nix
    ./services/nextcloud.nix
    # ./services/hydroxide.nix
  ];

  users.users = {
    cyrusng = {
      extraGroups = [ "wheel" "nextcloud" "music" ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      bind
      sops
      qrencode
      bc
      neovim
    ];

    variables = {
      EDITOR = "nvim";
    };

    pathsToLink = [
      "/share/bash-completion"
    ];
  };

  services = {
    fail2ban.enable = true;
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 22 ];
      allowedTCPPorts = [ 22 ];
    };

    # defaultGateway = "192.168.0.1";

    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    hostName = host;
    domain = "duckdns.org";
    interfaces = {
      end0 = {
        ipv4.addresses = [ 
          # {
          #   address = "192.168.0.116";
          #   prefixLength = 24;
          # }
          # {
          #   address = "10.0.0.116";
          #   prefixLength = 24;
          # }
        ];
        ipv6.addresses = [ 
          {
            address = "2607:9880:24e8:1c:5ece:2fab:e8c1:577d";
            prefixLength = 64;
          }
        ];
      };
      wlan0 = {
        # ipv4.addresses = [ 
        #   {
        #     address = "10.0.0.116";
        #     prefixLength = 24;
        #   }
        # ];
      };
    };
  };
}
