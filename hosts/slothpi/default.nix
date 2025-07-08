{ config, pkgs, lib, inputs, host, ... }:

{

  imports = [ 
    # ./hardware-configuration.nix
    #"${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ../common.nix
    ../../nixosModules
#    ./services/radicale.nix
#    ./services/grafana.nix
#    ./services/blocky.nix
#    ./services/navidrome.nix
#    ./services/nginx.nix
#    ./services/cups.nix
#    ./services/unbound.nix
#    ./services/wireguard.nix
#    ./services/nextcloud.nix
#    ./services/samba.nix
#    ./services/vaultwarden.nix
#    ./services/immich.nix
#    ./services/restic.nix
  ];

  radicale.enable = true;
  grafana.enable = true;
  blocky.enable = true;
  navidrome.enable = true;
  nginx.enable = true;
  cups.enable = true;
  unbound.enable = true;
  wireguard.enable = true;
  nextcloud.enable = true;
  samba.enable = true;
  vaultwarden.enable = true;
  immich.enable = true;
  restic.enable = true;
  authentik.enable = true;
  homepage-dashboard.enable = true;
  glances.enable = true;
  jellyfin.enable = true;

  users.users = {
    cyrusng = {
      extraGroups = [ "wheel" "nextcloud" "music" ];
    };
    rachelman = {
      isNormalUser = true;
      extraGroups = [ "nextcloud" "music" ];
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
      allowedUDPPorts = [ 22 67 ];
      allowedTCPPorts = [ 22 ];
    };

    defaultGateway = "192.168.2.1";

    # enableIPv6 = false;

    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    hostName = host;
    domain = "duckdns.org";
    interfaces = {
      end0 = {
        ipv4.addresses = [ 
          {
            address = "192.168.2.11";
            prefixLength = 24;
          }
        ];
        # ipv6.addresses = [ 
        #   # {
        #   #   address = "2607:9880:24e8:1c:5ece:2fab:e8c1:577d";
        #   #   prefixLength = 64;
        #   # }
        # ];
      };
    };
  };
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      interface = "end0";
      bind-dynamic = true;
      domain-needed = true;
      bogus-priv = true;
      dhcp-option = [ "6,192.168.2.11" "3,192.168.2.1" ];
      dhcp-range = "192.168.2.12,192.168.2.254,255.255.255.0,12h";
      # dhcp-host = [
      #   "e4:5f:01:ac:62:51,slothpi.duckdns.org,192.168.2.11,infinite"
      # ];
      port = 0;
    };
  };

  systemd.timers.duckdns = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "duckdns.server";
    };
  };

  systemd.services.duckdns = {
    script = ''
      echo url="https://www.duckdns.org/update?domains=slothpi&token=12c12ead-41be-40b1-8e4a-db944dd0cdd7&ip=" | ${lib.getExe pkgs.curl} -k -K - > /dev/null 2>&1
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  # Hardware Acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;
}
