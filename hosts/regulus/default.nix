# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, ... }:

{
  imports = [
    ../desktop.nix
    ../common.nix
  ];

  # systemd.tmpfiles.rules = [ 
  #   "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  # ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        # amdvlk
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        # amdvlk
      ];
    };
  };

  programs.tuxclocker = {
    enable = true;
    enableAMD = true;
  };
 
  networking = {
    wireless.iwd.enable = true;
    firewall.interfaces = {
      "wlan0".allowedTCPPorts = [ 63236 ];
    };
    wg-quick.interfaces.wg0 = {
      address = [ "10.200.200.6/32" ];
      autostart = false;
      peers = [
        {
          publicKey = "i2bnqjKWvfdpUDeMDObiivfEvAYoZCTZQfcLjlBDni0=";
          presharedKeyFile = config.age.secrets.wgPsk.path;
          allowedIPs = [ 
            "0.0.0.0/0" 
          ];
          endpoint = "slothpi.duckdns.org:51820";
        }
      ];
    };
    hosts = {
      "192.168.2.11" = [ "slothpi.duckdns.org" ];
    };
  };

  services = {
    printing = {
      enable = true;
      drivers = with pkgs; [ 
        cnijfilter2
      ];
    };
    avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
