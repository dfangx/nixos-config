{ config, pkgs, lib, inputs, host, ... }:
let
  terminal = "${lib.getExe pkgs.alacritty}";
in
{
  imports = [
    # Programs
    ./programs/alacritty.nix
    ./programs/firefox.nix
    ./programs/fuzzel.nix
    ./programs/mako.nix
    ./programs/mpv.nix
    ./programs/wayland.nix
    ./programs/wallust.nix
    ./programs/zathura.nix

    # Services
    ./services/gammastep.nix
    ./services/password_manager.nix
  ];

  home = {
    sessionVariables = {
      TERM = "${terminal}";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    };
    packages = with pkgs; [
      discord
      adwaita-icon-theme
      libadwaita
      imv
      libreoffice
      hunspell
      hunspellDicts.en_CA
      wl-clipboard
      xorg.xeyes
      runelite
      wev
      zoom-us
      rsgain
      yt-dlp
      picard
      obsidian
      pavucontrol
      wallust
    ];
  };

  systemd = {
    user.services = {
      hyprpolkitagent = {
        Unit = {
          Description = "hyprpolkitagent";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      nextcloud-client = {
        Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
        Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
        Unit = {
          After = lib.mkForce [ "graphical-session.target" ];
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

  programs.foot = {
    enable = false;  
    settings = {
      main = {
        term = "xterm-256color";
        font = "Source Code Pro for Powerline:size=12";
        bold-text-in-bright = true;
        locked-title = false;
        include = "${config.xdg.configHome}/foot/colors-foot.ini";
        pad = "10x10";
        box-drawings-uses-font-glyphs = true;
      };
    };
  };
}

