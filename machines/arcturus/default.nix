# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
    ../desktop.nix
    ../common.nix
  ];

  nixpkgs.overlays = [
    (final: prev: { 
      nbfc-linux = inputs.nbfc-linux.packages.${pkgs.system}.nbfc;
    })
  ];

  boot = {
    resumeDevice = "/dev/disk/by-uuid/a9aa5ab2-ea77-4b71-8986-805313638e97";
    kernelParams = [ 
      "resume_offset=5081088" 
    ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
      ];
    };
  };

  networking = {
    hosts = {
      "192.168.2.116" = [ "slothpi.duckdns.org" ];
    };
    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.200.200.5/32" ] ;
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
    };
  };

  system.activationScripts.rfkillUnblockAll = {
    text = ''
      rfkill unblock all
    '';
    deps = [];
  };

  services = {
    logind = {
      lidSwitch = "suspend-then-hibernate";
    };
    fwupd.enable = true;
    fprintd = {
      enable = false;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 85;
        STOP_CHARGE_THRESH_BAT0 = 95;
        DEVICES_TO_ENABLE_ON_STARTUP="bluetooth wifi";
      };
    };
    pipewire = {
      extraConfig = {
        pipewire = {
          sink-dolby-surround.conf = {
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
        pipewire-pulse = {
          switch-on-connect = {
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
        };
      };
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
