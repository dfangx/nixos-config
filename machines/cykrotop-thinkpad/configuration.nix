# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.resumeDevice = "/dev/disk/by-uuid/a9aa5ab2-ea77-4b71-8986-805313638e97";
  boot.kernelParams = [ "resume_offset=4231168" ];

  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  hardware.bluetooth.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Use the GRUB 2 boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "cykrotop"; # Define your hostname.
    wireless.iwd.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.200.200.5/32" ] ;
        dns = [ "10.200.200.1" ];
        privateKeyFile = config.age.secrets.wgPrivate.path;
        mtu = 1420;
        peers = [
          {
            publicKey = "i2bnqjKWvfdpUDeMDObiivfEvAYoZCTZQfcLjlBDni0=";
            presharedKeyFile = config.age.secrets.wgPsk.path;
            allowedIPs = [ 
              "0.0.0.0/0" 
              "::/0" 
            ];
            endpoint = "slothpi.duckdns.org:51820";
          }
        ];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cyrusng = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "audio" "libvirtd" ]; 
    hashedPassword = "$y$j9T$XgXobCeRJMzoHs79Qh/wN1$d/PKmABq92qsGEkNUv7oC9.zgr.SxvgmIkIgkS7nXE7";
  };

  age.secrets = {
    wgPsk.file = ./secrets/wgPsk.age;
    wgPrivate.file = ./secrets/wgPrivate.age;
  };

  virtualisation.libvirtd.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    lsof
    virt-manager
    home-manager
    htop
    nix-prefetch-github
    alsa-utils
    wget
    agenix
    lm_sensors
  ];

  programs = {
    hyprland.enable = true;
    steam.enable = true;
    dconf.enable = true;
  };

  xdg.portal.enable = true;

  security = {
    rtkit.enable = true;
    pam.services.swaylock = { };
    polkit.enable = true;
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1h
  '';

  services = {
    logind = {
      lidSwitch = "suspend-then-hibernate";
      killUserProcesses = true;
    };
    fwupd.enable = true;
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };
    sshd.enable = true;
    geoclue2 = {
      enable = true;
      enableDemoAgent = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --issue --cmd Hyprland";
      };
    };
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 85;
        STOP_CHARGE_THRESH_BAT0 = 95;
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
  };

  environment.etc = let
    json = pkgs.formats.json {};
  in {
    "pipewire/pipewire-pulse.conf.d/switch-on-connect.conf".source = json.generate "switch-on-connect.conf" {
      pulse.cmd = [
        {
          cmd = "load-module";
          args = "module-always-sink";
          flags = [ ];
        }
        {
          cmd = "load-module";
          args = "module-switch-on-connect";
        }
      ];
    };
    "pipewire/pipewire.conf.d/sink-dolby-surround.conf".source = json.generate "sink-dolby-surround.conf" {
      context.modules = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            node.description = "Dolby Surround Sink";
            media.name = "Dolby Surround Sink";
            filter.graph = {
              nodes = [ 
                {
                  type  = "builtin";
                  name  = "mixer";
                  label = "mixer";
                  control = { 
                    "Gain 1" = 0.5;
                    "Gain 2" = 0.5;
                  };
                }
                {
                  type = "ladspa";
                  name = "enc";
                  plugin = "surround_encoder_1401";
                  label = "surroundEncoder";
                }
              ];
              links = [
                { 
                  output = "mixer:Out"; 
                  input = "enc:S";
                }
              ];
              inputs  = [ "enc:L" "enc:R" "enc:C" "null" "mixer:In 1" "mixer:In 2" ];
              outputs = [ "enc:Lt" "enc:Rt" ];
            };
            capture.props = {
              node.name      = "effect_input.dolby_surround";
              media.class    = "Audio/Sink";
              audio.channels = 6;
              audio.position = [ "FL" "FR" "FC" "LFE" "SL" "SR" ];
            };
            playback.props = {
              node.name      = "effect_output.dolby_surround";
              node.passive   = true;
              audio.channels = 2;
              audio.position = [ "FL" "FR" ];
            };
          };
        }
      ];
    };
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
