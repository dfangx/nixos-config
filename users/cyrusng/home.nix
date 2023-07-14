{ config, pkgs, ... }:
{
  imports = [
    ./programs/hyprland.nix
    ./programs/xdg.nix
    ./programs/waybar.nix
    ./programs/river.nix
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
      XDG_SESSION_DESKTOP = "hyprland";
      XDG_CURRENT_DESKTOP = "hyprland";
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
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
      swaybg
      imv
      wlr-randr
      powerline-fonts
      pkgsStable.libreoffice
      wl-clipboard
      tridactyl-native
      xorg.xeyes
      adwaita-icon-theme-without-gnome
      brightnessctl
      freetube
      runelite
      backup
      neovim-nix
      youtube-dl
      gparted
      nextcloud-client
      picard
      exiftool
      playerctl
      wev
      xdg-user-dirs
      spotify-player
      zoom-us
      r128gain
      yt-dlp
      spotdl
      unzip
      powershell
    ];

    file.".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
  };
  
  programs = {
    home-manager.enable = true;
  };
  
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=WaylandWindowDecorations
    --ozone-platform-hint=auto
  '';

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install.wantedBy = [ "graphical-session.target" ];
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
