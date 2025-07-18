# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.hyprland.nixosModules.default
    inputs.nix-gaming.nixosModules.platformOptimizations
    ./${host}/hardware-configuration.nix
    ./hardware.nix
    ./qemu.nix
    ./steam.nix
  ];

  options.desktop.enable = lib.mkEnableOption "Enable desktop configuration";
  desktopHardware.enable = true;
  qemu.enable = true;
  steam.enable = true;

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

  networking = {
    wg-quick.interfaces = {
      wg0 = {
        dns = [ "10.200.200.1" ];
        privateKeyFile = config.age.secrets.wgPrivate.path;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  age.secrets = {
    wgPrivate = {
      file = ./${host}/secrets/wgPrivate.age;
      mode = "400";
    };
    wgPsk = {
      file = ./${host}/secrets/wgPsk.age;
      mode = "400";
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
    alacritty
    virtiofsd
    libimobiledevice
    ifuse
  ];

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    dconf.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };

  security = {
    rtkit.enable = true;
    pam.services.hyprlock = { };
    polkit.enable = true;
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
  '';

  services = {
    geoclue2 = {
      enable = true;
      enableDemoAgent = true;
    };
    kmscon = {
      enable = false;
      hwRender = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --issue --remember --remember-session";
      };
    };
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    interception-tools = {
      enable = true;
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY [KEY_CAPSLOCK, KEY_ESC]
      '';
    };
    usbmuxd.enable = true;
  };

  systemd.services.greetd = {
    unitConfig = {
      After = lib.mkOverride 0 [ "multi-user.target" ];
    };
    serviceConfig = {
      Type = "idle";
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

