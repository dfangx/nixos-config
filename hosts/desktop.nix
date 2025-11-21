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

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
    xpadneo.enable = true;
    steam-hardware.enable = true;
  };


  # Use the GRUB 2 boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cyrusng = {
    extraGroups = [ "input" "audio" "libvirtd" "gamemode" ]; 
  };

  age.secrets = {
    wgPrivate = {
      file = ./${host}/secrets/wgPrivate.age;
      mode = "400";
    };
    wgPsk = {
      file = ./${host}/secrets/wgPsk.age;
      mode = "400";
    };
    samba  = {
      file = ./${host}/secrets/samba.age;
      mode = "400";
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
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
    virt-manager.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    steam = {
      enable = true;
      protontricks.enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "--hdr-enabled"
          "--adaptive-sync"
          "-W $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select( .focused==true) | .width')"
          "-H $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select( .focused==true) | .height')"
        ];
      };
      remotePlay.openFirewall = true;
      platformOptimizations.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = false;
      args = [
        "--rt"
        "--hdr-enabled"
        "--adaptive-sync"
        # "-W $(${pkgs.hyprland}/bin/hyprctl monitors -j | jq -r '.[] | select( .focused==true) | .width')"
        # "-H $(${pkgs.hyprland}/bin/hyprctl monitors -j | jq -r '.[] | select( .focused==true) | .height')"
      ];
    };
    gamemode.enable = true;
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
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
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
    "/home/cyrusng/vids" = {
      device = "//slothpi.duckdns.org/vids";
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

