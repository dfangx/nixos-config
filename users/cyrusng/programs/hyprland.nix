{ config, pkgs, lib, inputs, ... }:
let
  cursorName = "HyprBibataModernClassicSVG";
in
{
  imports = [
    ./hyprcursor.nix
  ];

  nixpkgs.overlays = [
    inputs.hyprland-contrib.overlays.default
  ];

  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  home = {
    sessionVariables = {
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
    };
    file = {
      "${config.xdg.configHome}/uwsm/env".text = ''
        export NIXOS_OZONE_WL = 1
        export XDG_CURRENT_DESKTOP = ${config.home.sessionVariables.XDG_CURRENT_DESKTOP}
        export XDG_SESSION_TYPE = ${config.home.sessionVariables.XDG_SESSION_TYPE}
        export XDG_SESSION_DESKTOP = ${config.home.sessionVariables.XDG_SESSION_DESKTOP}
        export MOZ_ENABLE_WAYLAND = ${toString config.home.sessionVariables.MOZ_ENABLE_WAYLAND}
        export GDK_BACKEND = ${config.home.sessionVariables.GDK_BACKEND}
        export CLUTTER_BACKEND = ${config.home.sessionVariables.CLUTTER_BACKEND}
        export QT_AUTO_SCREEN_SCALE_FACTOR = ${toString config.home.sessionVariables.QT_AUTO_SCREEN_SCALE_FACTOR}
        export QT_QPA_PLATFORM = ${config.home.sessionVariables.QT_QPA_PLATFORM}
        export QT_WAYLAND_DISABLE_WINDOWDECORATION = ${toString config.home.sessionVariables.QT_WAYLAND_DISABLE_WINDOWDECORATION}
        export QT_QPA_PLATFORM_THEME = qt5ct
      '';
      "${config.xdg.configHome}/uwsm/env-hyprland".text = ''
        export HYPRCURSOR_THEME = ${cursorName}"
        export HYPRCRSOR_SIZE = ${toString config.home.pointerCursor.size}"
      '';
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = false;
      variables = [ "--all" ];
    };
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-virtual-desktops.packages.${pkgs.system}.default
      # inputs.hyprspace.packages.${pkgs.system}.default
    ];
    settings = let
      mainMod = "SUPER";
      wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
      notifyctl = "${lib.getExe (pkgs.callPackage ../../../pkgs/notifyctl { })}";
      uwsm = lib.getExe pkgs.uwsm;
      uwsmLaunch = "${uwsm} app --";
      loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
    in
    {
      source = [
        "${config.xdg.configHome}/hypr/colors-hyprland.conf"
      ];
      exec-once = [
        "${uwsmLaunch} ${lib.getExe pkgs.xorg.xrandr} --noprimary"
        "${uwsmLaunch} ${config.home.sessionVariables.TERM} --class term-general"
        "[workspace 1]${uwsmLaunch} ${config.home.sessionVariables.BROWSER}"
        "hyprctl setcursor ${cursorName} ${toString config.home.pointerCursor.size}"
        "${uwsmLaunch} ${lib.getExe pkgs.hyprdim}"
      ];

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      master = {
        mfact = 0.550000;
        new_status = "master";
        new_on_top = true;
      };

      general = {
        border_size = 4;
        gaps_in = 5;
        gaps_out = 10;
        layout = "master";
      };

      input = {
        follow_mouse = 2;
        kb_layout = "us";
        repeat_delay = 250;
        repeat_rate = 50;
        sensitivity = 0.5;
        scroll_button = 13;

        touchpad = {
          clickfinger_behavior = true;
          disable_while_typing = true;
          drag_lock = true;
          middle_button_emulation = true;
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_cancel_ratio = 0.150000;
      };

      decoration = {
        rounding = 10;

        shadow = {
          enabled = true;
          color = "rgba(1a1a1aee)";
          range = 4;
          render_power = 3;
        };

        blur = {
          enabled = true;
          new_optimizations = true;
          passes = 3;
          size = 4;
          ignore_opacity = true;
        };
      };

      animations = {
        bezier = [
          "easeInBack, 0.360000, 0, 0.660000, -0.560000"
          "easeInCirc, 0.550000, 0, 1, 0.450000"
          "easeInCubic, 0.320000, 0, 0.670000, 0"
          "easeInExpo, 0.700000, 0, 0.840000, 0"
          "easeInOutBack, 0.680000, -0.600000, 0.320000, 1.600000"
          "easeInOutCirc, 0.850000, 0, 0.150000, 1"
          "easeInOutCubic, 0.650000, 0, 0.350000, 1"
          "easeInOutExpo, 0.870000, 0, 0.130000, 1"
          "easeInOutQuad, 0.450000, 0, 0.550000, 1"
          "easeInOutQuart, 0.760000, 0, 0.240000, 1"
          "easeInOutQuint, 0.830000, 0, 0.170000, 1"
          "easeInOutSine, 0.370000, 0, 0.630000, 1"
          "easeInQuad, 0.110000, 0, 0.500000, 0"
          "easeInQuart, 0.500000, 0, 0.750000, 0"
          "easeInQuint, 0.640000, 0, 0.780000, 0"
          "easeInSine, 0.120000, 0, 0.390000, 0"
          "easeOutBack, 0.340000, 1.560000, 0.640000, 1"
          "easeOutCirc, 0, 0.550000, 0.450000, 1"
          "easeOutCubic, 0.330000, 1, 0.680000, 1"
          "easeOutExpo, 0.160000, 1, 0.300000, 1"
          "easeOutQuad, 0.500000, 1, 0.890000, 1"
          "easeOutQuart, 0.250000, 1, 0.500000, 1"
          "easeOutQuint, 0.220000, 1, 0.360000, 1"
          "easeOutSine, 0.610000, 1, 0.880000, 1"
          "linear, 0, 0, 1, 1"
        ];

        animation = [
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "windows, 1, 7, default"
          "windowsOut, 1, 7, default, popin 80%"
          "workspaces, 1, 6, default"
        ];
      };

      misc = {
        allow_session_lock_restore = true;
        disable_hyprland_logo = true;
        enable_swallow = false;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
        mouse_move_focuses_monitor = false;
        swallow_regex = "^(Alacritty)$";
        new_window_takes_over_fullscreen = 2;
        vrr = 1;
      };

      plugin = {
        # virtual-desktops = {
        #   cycleworkspaces = 0;
        #   rememberlayout = "size";
        # };
        overview = {};
      };

      windowrulev2 = [ 
        "float, class:^(^(blueberry.py)$)$"
        "opacity 0.55, class:^(^(Alacritty)$)$"
        "opacity 0.55, class:^(^(foot)$)$"
        "opacity 0.55, class:^(^(term-general)$)$"
        "float, class:^(^(org.keepassxc.KeePassXC)$)$"
        "center 1, class:^(^(org.keepassxc.KeePassXC)$)$"
        "size 60%,75%, class:^(^(org.keepassxc.KeePassXC)$)$"
        "workspace 2, class:^(^(term-general)$)$"
        "float, class:^(^(org.pulseaudio.pavucontrol)$)$"
        "size 60%,75%, class:^(^(org.pulseaudio.pavucontrol)$)$"
      ];

      bind = let
        playerctl = "${lib.getExe pkgs.playerctl}";
        brightnessctl = "${lib.getExe pkgs.brightnessctl}";
      in
      [
        "${mainMod} SHIFT, q, killactive"
        "${mainMod} SHIFT, e, exec, ${loginctl} terminate-user \"\""
        "${mainMod}, space, togglefloating"
        "${mainMod}, semicolon, exec, ${uwsmLaunch} ${config.home.sessionVariables.TERM}"
        "${mainMod}, b, exec, ${uwsmLaunch} ${config.home.sessionVariables.BROWSER}"
        "${mainMod}, p, exec, ${uwsmLaunch} ${config.home.sessionVariables.PSWD_MGR}"
        "${mainMod}, d, exec, ${lib.getExe pkgs.fuzzel}"
        "${mainMod} SHIFT, s, exec, ${uwsmLaunch}  ${lib.getExe pkgs.grimblast} --notify copysave area ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots/$(date +%F_%H%M%S).png"
        "${mainMod} SHIFT, return, layoutmsg, swapwithmaster master"
        "${mainMod} SHIFT, r, exec, hyprctl reload"

        "${mainMod} SHIFT, p, pseudo # dwindle"
        "${mainMod}, s, togglesplit,  # dwindle"
        "${mainMod}, g, togglegroup, "
        "${mainMod}, bracketleft, changegroupactive, b"
        "${mainMod}, bracketright, changegroupactive, f"
        "${mainMod} ALT, w, moveintogroup, u"
        "${mainMod} ALT, a, moveintogroup, l"
        "${mainMod} ALT, s, moveintogroup, d"
        "${mainMod} ALT, d, moveintogroup, r"
        "${mainMod} ALT, g, moveoutofgroup, "
        ", xF86AudioMute, exec, ${uwsmLaunch} ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 \" \" $3}' | ${notifyctl} audio"
        ", xF86MonBrightnessUp, exec, ${uwsmLaunch} ${brightnessctl} -m s +2% | cut -d, -f4 | ${notifyctl} backlight"
        ", xF86MonBrightnessdown, exec, ${uwsmLaunch} ${brightnessctl} -m s 2%- | cut -d, -f4 | ${notifyctl} backlight"
        ", xF86AudioPlay, exec, ${uwsmLaunch} ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"
        ", xF86AudioNext, exec, ${uwsmLaunch} ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"
        ", xF86AudioPrev, exec, ${uwsmLaunch} ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"
        ", xF86AudioStop, exec, ${uwsmLaunch} ${playerctl} stop && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"
        "${mainMod}, xF86AudioMute, exec, ${uwsmLaunch} ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"
        "${mainMod}, xF86AudioRaiseVolume, exec, ${uwsmLaunch} ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"
        "${mainMod}, xF86AudioLowerVolume, exec, ${uwsmLaunch} ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris"

        "${mainMod}, h, movefocus, l"
        "${mainMod}, l, movefocus, r"
        "${mainMod}, k, movefocus, u"
        "${mainMod}, j, movefocus, d"

        "${mainMod} SHIFT, h, resizeactive, -10 0"
        "${mainMod} SHIFT, l, resizeactive, 10 0"
        "${mainMod} SHIFT, k, resizeactive, 0 10"
        "${mainMod} SHIFT, j, resizeactive, 0 -10"

        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"

        # "${mainMod}, TAB, overview:toggle"
        # "${mainMod}, TAB, nextdesk"
        # "${mainMod} SHIFT, TAB, prevdesk"
      ]
      ++ (
        # workspaces
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
            builtins.toString (x + 1 - (c * 10));
          in [
            "${mainMod}, ${ws}, workspace, ${toString (x + 1)}"
            "${mainMod} SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
            "${mainMod} CTRL, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );

      bindel = [
        ", xF86AudioRaiseVolume, exec, ${uwsmLaunch} ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3.0%+ && printf \"%.0f\" $(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100/150*100 \" \" $3}') | ${notifyctl} audio"
        ", xF86AudioLowerVolume, exec, ${uwsmLaunch} ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3.0%- && printf \"%.0f\" $(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100/150*100 \" \" $3}') | ${notifyctl} audio"
      ];

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      env = [
                # "NIXOS_OZONE_WL,1"
                # "XDG_CURRENT_DESKTOP,${config.home.sessionVariables.XDG_CURRENT_DESKTOP}"
                # "XDG_SESSION_TYPE,${config.home.sessionVariables.XDG_SESSION_TYPE}"
                # "XDG_SESSION_DESKTOP,${config.home.sessionVariables.XDG_SESSION_DESKTOP}"
                # "MOZ_ENABLE_WAYLAND,${toString config.home.sessionVariables.MOZ_ENABLE_WAYLAND}"
                # "QT_QPA_PLATFORM,${config.home.sessionVariables.QT_QPA_PLATFORM}"
                # "GDK_BACKEND,${config.home.sessionVariables.GDK_BACKEND}"
                # "CLUTTER_BACKEND,${config.home.sessionVariables.CLUTTER_BACKEND}"
                # "QT_AUTO_SCREEN_SCALE_FACTOR,${toString config.home.sessionVariables.QT_AUTO_SCREEN_SCALE_FACTOR}"
                # "QT_WAYLAND_DISABLE_WINDOWDECORATION,${toString config.home.sessionVariables.QT_WAYLAND_DISABLE_WINDOWDECORATION}"
                # "HYPRCURSOR_THEME,${cursorName}"
                # "HYPRCRSOR_SIZE,${toString config.home.pointerCursor.size}"
      ];
    };
  };
}
