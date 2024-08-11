# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, host, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.hyprland.nixosModules.default
    ./${host}/configuration.nix
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
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
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
    hostName = host;
    wireless.iwd.enable = true;
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
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "audio" "libvirtd" ]; 
    hashedPassword = "$y$j9T$XgXobCeRJMzoHs79Qh/wN1$d/PKmABq92qsGEkNUv7oC9.zgr.SxvgmIkIgkS7nXE7";
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
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
      swtpm.enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    lsof
    home-manager
    htop
    nix-prefetch-github
    alsa-utils
    wget
    agenix
    lm_sensors
    alacritty
    usbutils
    virtiofsd
  ];

  programs = {
    virt-manager.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    gamescope = {
      enable = true;
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
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
    logind = {
      killUserProcesses = true;
    };
    sshd.enable = true;
    geoclue2 = {
      enable = true;
      enableDemoAgent = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --issue --cmd ${lib.getExe' config.programs.hyprland.package "Hyprland"}";
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

