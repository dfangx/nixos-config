{ config, pkgs, lib, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ 
      "https://timhae-firefly.cachix.org" 
    ];
    trusted-public-keys = [ 
      "timhae-firefly.cachix.org-1:TMexYUvP5SKkeKG11WDbYUVLh/4dqvCqSE/c028sqis=" 
    ];
  };


  imports = [ 
    ./hardware-configuration.nix
    "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"
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
    ./services/hydroxide.nix
  ];

  # boot.kernelPackages = lib.mkForce pkgs.linuxPackages_rpi4;

  time.timeZone = "America/Toronto";

  users.users = {
    cyrusng = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$XgXobCeRJMzoHs79Qh/wN1$d/PKmABq92qsGEkNUv7oC9.zgr.SxvgmIkIgkS7nXE7";
      extraGroups = [ "wheel" "nextcloud" "music" ];
    };
  };

  programs.git = {
    enable = true;
    config.user = {
      name = "dfangx";
      email = "github.oxfrj2ct@bged98.anonaddy.com";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      nix-prefetch-git
      unzip
      bind
      neovim-nix
      git
      htop
      sops
      agenix
      qrencode
      bc
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
    openssh.enable = true;
    mysql.package = lib.mkForce pkgs.mariadb;
  };

  networking = {
    wireless.iwd.enable = true;
    firewall = {
      allowedUDPPorts = [ 22 ];
      allowedTCPPorts = [ 22 ];
    };

    # defaultGateway = "192.168.0.1";

    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    hostName = "slothpi";
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

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.05";
}
