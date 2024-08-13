{ config, pkgs, lib, inputs, host, ... }:
let
  terminal = "${lib.getExe pkgs.alacritty}";
in
{
  imports = [
    inputs.nur.nixosModules.nur

    ./${host}

    # Programs
    ./programs/alacritty.nix
    ./programs/bash.nix
    ./programs/dircolors.nix
    ./programs/firefox.nix
    ./programs/fonts.nix
    ./programs/fuzzel.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/mako.nix
    ./programs/mpv.nix
    ./programs/nixvim.nix
    ./programs/tmux.nix
    ./programs/xdg.nix
    ./programs/wayland.nix
    ./programs/zathura.nix

    # Services
    ./services/gammastep.nix
    ./services/password_manager.nix
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
    packages = with pkgs; [
      discord
      adwaita-icon-theme
      libadwaita
      fd
      bat
      imv
      libreoffice
      hunspell
      hunspellDicts.en_CA
      wl-clipboard
      xorg.xeyes
      runelite
      wev
      xdg-user-dirs
      zoom-us
      rsgain
      yt-dlp
      unzip
      picard
      obsidian
      feishin
      pavucontrol
    ];
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
        # "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      auto-optimise-store = true;
    };
  };
  
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
        lastgenre.enable = true;
      };
    };
    settings = {
      threaded = "yes";
      directory = config.xdg.userDirs.music;
      library = "${config.xdg.userDirs.music}/.beets.db";
      plugins = "chroma replaygain edit unimported duplicates embedart fetchart lastgenre";
      chroma = {
        auto = "yes";
      };
      replaygain = {
        backend = "ffmpeg";
        r128_targetlevel = 89;
        threads = 16;
      };
      unimported.ignore_subdirectories = "tmp";
      lastgenre = {
        count = 3;
        source = "track";
      };
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

      nextcloud-client = {
        Install.WantedBy = lib.mkForce [ "${config.home.sessionVariables.XDG_SESSION_DESKTOP}-session.target" ];
        Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
        Unit = {
          After = lib.mkForce [ "${config.home.sessionVariables.XDG_SESSION_DESKTOP}-session.target" ];
          PartOf = lib.mkForce [];
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
  
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Nordic
    '';

    "Kvantum/Nordic".source = "${pkgs.nordic}/share/Kvantum/Nordic";
  };
}

