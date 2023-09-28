{ config, pkgs, lib, ... }:
{
  imports = [
    ./programs/hyprland.nix
    ./programs/waybar.nix
    ./programs/fzf.nix
    ./programs/mako.nix
    ./programs/swaylock.nix
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
    # ./programs/nixneovim.nix
    ./services/swayidle.nix
    ./services/kanshi.nix
    ./services/gammastep.nix
    ./services/backup.nix
  ];

  home = rec {
    username = "cyrusng";
    homeDirectory = "/home/${username}";
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERM = "alacritty";
      PSWD_MGR = "keepassxc";
      XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";
      PROMPT_DIRTRIM = 3;
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
      GOPATH = "${config.xdg.dataHome}/go";
      XDG_SESSION_TYPE = "wayland";
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      GDK_BACKEND = "wayland,x11";
      CLUTTER_BACKEND = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
    sessionPath = [
      config.home.sessionVariables."XDG_BIN_HOME"
    ];
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
      backup = pkgs.callPackage ../../pkgs/backup { };
    in
    with pkgs; [
      keepassxc
      signal-desktop
      fd
      bat
      imv
      powerline-fonts
      material-design-icons
      pkgsStable.libreoffice
      wl-clipboard
      tridactyl-native
      xorg.xeyes
      brightnessctl
      sonixd
      runelite
      backup
      neovim-nix
      youtube-dl
      gparted
      picard
      exiftool
      playerctl
      wev
      xdg-user-dirs
      spotify-player
      zoom-us
      rsgain
      yt-dlp
      spotdl
      unzip
      powershell
      xournalpp
    ];

    file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
  };
  
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
  };
  
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';

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

      keepassxc = {
        Unit = {
          Description = "Launch KeePassXC at startup";
          After = [ "graphical-session-pre.target" ];
          PartOf=[ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
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

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };

  # services.blueman-applet.enable = true;
  # services.easyeffects = {
  #   enable = true;
  #   preset = "Laptop";
  # };
}
