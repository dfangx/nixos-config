{ config, pkgs, lib, inputs, ... }:
let
  terminal = "${lib.getExe pkgs.alacritty}";
in
{
  imports = [
    ./programs/wayland.nix
    ./programs/waybar.nix
    ./programs/fzf.nix
    ./programs/mako.nix
    ./programs/alacritty.nix
    ./programs/zathura.nix
    ./programs/git.nix
    ./programs/mpv.nix
    ./programs/dircolors.nix
    ./programs/bash.nix
    ./programs/tmux.nix
    ./programs/firefox.nix
    ./programs/fuzzel.nix
    ./programs/xdg.nix
    ./programs/fonts.nix
    ./programs/nixneovim.nix
    ./services/kanshi.nix
    ./services/gammastep.nix
    ./services/password_manager.nix
    # ./services/backup.nix
  ];

  home = rec {
    username = "cyrusng";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      TERM = "${terminal}";
      PROMPT_DIRTRIM = 3;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };
    shellAliases = {
      po = "poweroff";
      rb = "reboot";
      ls = "ls --color=auto";
      la = "ls -a";
      lh = "ls -h";
      ll = "ls -lh";
      lal = "ls -lha";
      rm = "rm -I";
      rr = "rm -Ir";
      mv = "mv -v";
      rmdir = "rmdir -v";
      mkdir = "mkdir -pv";
      df = "df -h";
      diff = "diff --color=auto";
      grep = "grep --color=auto";
      ZZ = "exit";
      e = "$EDITOR";
      g = "git";
      gst = "git status";
      gcm = "git commit";
      gps = "git push";
      gpl = "git pull";
      gmg = "git merge";
      gco = "git checkout";
      ga = "git add";
      gdf = "git diff";
      gbr = "git branch";
      gap = "git apply";
      gl = "git log";
      gcl = "git clone";
      grb = "git rebase";
      gsmu = "git submodule foreach git pull";
      rpi = "ssh -4 ${username}@slothpi.duckdns.org";
    };
    stateVersion = "22.11";
    packages = let 
      feishin = pkgs.callPackage ../../pkgs/feishin { };
      obsidian = pkgs.obsidian.override {
          electron = pkgs.electron_25.overrideAttrs (_: {
            preFixup = "patchelf --add-needed ${pkgs.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
            meta.knownVulnerabilities = [ ]; # NixOS/nixpkgs#273611
          });
        };
    in
    with pkgs; [
      gnome.adwaita-icon-theme
      fd
      bat
      imv
      libreoffice
      wl-clipboard
      tridactyl-native
      xorg.xeyes
      runelite
      # neovim-nix
      wev
      xdg-user-dirs
      zoom-us
      rsgain
      yt-dlp
      unzip
      xournalpp
      picard
      zettlr
      # wlvncc
      obsidian
      feishin
      pavucontrol
    ];
  };

  xdg.desktopEntries = {
    feishin = {
      name = "Feishin";
      exec = "feishin %u";
      icon = "feishin";
      comment = "Full-featured Subsonic/Jellyfin compatible desktop music player";
      genericName = "Subsonic Client";
      categories = [ "Audio" "AudioVideo" ];
      mimeType = [ "x-scheme-handler/feishin" ];
    };
  };

  nix = {
    package = pkgs.nix;
    checkConfig = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
    '';
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      auto-optimise-store = true;
    };
  };
  
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  programs.home-manager.enable = true;

  programs.beets = {
    enable = true;
    package = pkgs.beets.override {
      pluginOverrides = {
        chroma.enable = true;
        replaygain.enable = true;
        edit.enable = true;
        unimported.enable = true;
        duplicates.enable = true;
        fetchart.enable = true;
        embedart.enable = true;
      };
    };
    settings = {
      threaded = "no";
      directory = config.xdg.userDirs.music;
      library = "${config.xdg.userDirs.music}/.beets.db";
      plugins = "chroma replaygain edit unimported duplicates embedart fetchart";
      chroma = {
        auto = "yes";
      };
      replygain.backend = "ffmpeg";
      unimported.ignore_subdirectories = "tmp";
    };
  };
  
  systemd = {
    user.services = {
      polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      wvkbd = {
        Unit = {
          Description = "Virtual Keyboard";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe' pkgs.wvkbd "wvkbd-mobintl"} -L 480 --hidden";
        };
      };
    };
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.file."${config.xdg.configHome}/Nextcloud/sync-exclude.lst".text = ''
    # This file contains fixed global exclude patterns
    
    ~$*
    .~lock.*
    ~*.tmp
    ]*.~*
    ]Icon\r*
    ].DS_Store
    ].ds_store
    *.textClipping
    ._*
    ]Thumbs.db
    ]photothumb.db
    System Volume Information
    
    .*.sw?
    .*.*sw?
    
    ].TemporaryItems
    ].Trashes
    ].DocumentRevisions-V100
    ].Trash-*
    .fseventd
    .apdisk
    .Spotlight-V100
    
    .directory
    
    *.part
    *.filepart
    *.crdownload
    
    *.kate-swp
    *.gnucash.tmp-*
    
    .synkron.*
    .sync.ffs_db
    .symform
    .symform-store
    .fuse_hidden*
    *.unison
    .nfs*
    
    My Saved Places.
    
    \#*#
    
    *.sb-*
  '';

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };
}

