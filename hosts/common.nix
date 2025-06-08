# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    ./${host}/hardware-configuration.nix
  ];

  nixpkgs = {
    config.allowUnfreePredicate = (pkg: true);
    overlays = [
      (final: prev: { 
        steam = prev.steam.override { 
          extraPkgs = pkgs: with pkgs; [ 
            openssl
          ]; 
        }; 
        agenix = inputs.agenix.packages.${pkgs.system}.default;
      })
    ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      auto-optimise-store = true;
      trusted-users = [ "cyrusng" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  networking = {
    hostName = host;
    wireless.iwd.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cyrusng = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    hashedPassword = "$y$j9T$XgXobCeRJMzoHs79Qh/wN1$d/PKmABq92qsGEkNUv7oC9.zgr.SxvgmIkIgkS7nXE7";
    uid = 1000;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    lsof
    unzip
    home-manager
    htop
    nix-prefetch-github
    alsa-utils
    wget
    agenix
    usbutils
    cifs-utils
  ];

  programs.git = {
    enable = true;
    config.user = {
      name = "dfangx";
      email = "github.oxfrj2ct@bged98.anonaddy.com";
    };
  };

  services = {
    logind = {
      killUserProcesses = true;
      powerKey = "suspend";
    };
    sshd.enable = true;
  };

  # For mount.cifs, required unless domain name resolution is not needed.
  fileSystems = let
    mountOpts = let
      automount_opts = [ 
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
      ];
    in
    automount_opts
    ++
    [ 
      "credentials=${config.age.secrets.samba.path}"
      "uid=${toString config.users.users.cyrusng.uid}"
      "gid=${toString config.users.groups.users.gid}"
    ];
  in
  {
    "/home/cyrusng/music" = {
      device = "//slothpi.duckdns.org/music";
      fsType = "cifs";
      options = mountOpts;
    };
    "/home/cyrusng/shared" = {
      device = "//slothpi.duckdns.org/data";
      fsType = "cifs";
      options = mountOpts;
    };
    "/home/cyrusng/data" = {
      device = "//slothpi.duckdns.org/cyrusng";
      fsType = "cifs";
      options = mountOpts;
    };
    "/home/cyrusng/pics" = {
      device = "//slothpi.duckdns.org/pics";
      fsType = "cifs";
      options = mountOpts;
    };
  };

  security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
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

