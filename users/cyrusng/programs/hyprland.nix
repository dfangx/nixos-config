{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
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

  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "hyprland";
    XDG_CURRENT_DESKTOP = "hyprland";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    # reloadConfig = true;
    # recommendedEnvironment = true;
    extraConfig = let
      mainMod = "SUPER";
      notifyctl = "${lib.getExe (pkgs.callPackage ../../../pkgs/notifyctl { })}";
      playerctl = "${lib.getExe pkgs.playerctl}";
      wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
      brightnessctl = "${lib.getExe pkgs.brightnessctl}";
    in
    ''
      bind = ${mainMod} SHIFT, q, killactive
      bind = ${mainMod} SHIFT, e, exit 
      bind = ${mainMod}, space, togglefloating
      bind = ${mainMod}, semicolon, exec, ${config.home.sessionVariables.TERM}
      bind = ${mainMod}, b, exec, ${config.home.sessionVariables.BROWSER}
      bind = ${mainMod}, p, exec, ${config.home.sessionVariables.PSWD_MGR}
      bind = ${mainMod}, d, exec, exec $(${pkgs.coreutils-full}/bin/basename -a $(${pkgs.fd}/bin/fd -Lt x . --maxdepth 1 $(echo $PATH | sed "s/:/ /g" | ${pkgs.coreutils-full}/bin/sort -u)) | ${pkgs.fuzzel}/bin/fuzzel -d)
      bind = ${mainMod} SHIFT, s, exec, ${pkgs.grimblast}/bin/grimblast --notify copysave area ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots/$(date +%F_%H%M%S).png
      bind = ${mainMod} SHIFT, return, layoutmsg, swapwithmaster master
      bind = ${mainMod} SHIFT, r, exec, hyprctl reload

      bind = ${mainMod} SHIFT, p, pseudo # dwindle
      bind = ${mainMod}, s, togglesplit,  # dwindle
      bind = ${mainMod}, g, togglegroup, 
      bind = ${mainMod}, bracketleft, changegroupactive, b
      bind = ${mainMod}, bracketright, changegroupactive, f
      bind = ${mainMod} ALT, w, moveintogroup, u
      bind = ${mainMod} ALT, a, moveintogroup, l
      bind = ${mainMod} ALT, s, moveintogroup, d
      bind = ${mainMod} ALT, d, moveintogroup, r
      bind = ${mainMod} ALT, g, moveoutofgroup, 
      bind = , xF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 " " $3}' | ${notifyctl} audio
      bind = , xF86MonBrightnessUp, exec, ${brightnessctl} -m s +2% | cut -d, -f4 | ${notifyctl} backlight
      bind = , xF86MonBrightnessdown, exec, ${brightnessctl} -m s 2%- | cut -d, -f4 | ${notifyctl} backlight
      bind = , xF86AudioPlay, exec, ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris
      bind = , xF86AudioNext, exec, ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris
      bind = , xF86AudioPrev, exec, ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris
      bind = , xF86AudioStop, exec, ${playerctl} stop && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris
      bind = ${mainMod}, xF86AudioMute, exec, ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris
      bind = ${mainMod}, xF86AudioRaiseVolume, exec, ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris
      bind = ${mainMod}, xF86AudioLowerVolume, exec, ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris

      bind = ${mainMod}, h, movefocus, l
      bind = ${mainMod}, l, movefocus, r
      bind = ${mainMod}, k, movefocus, u
      bind = ${mainMod}, j, movefocus, d

      bind = ${mainMod} SHIFT, h, resizeactive, -10 0
      bind = ${mainMod} SHIFT, l, resizeactive, 10 0
      bind = ${mainMod} SHIFT, k, resizeactive, 0 10
      bind = ${mainMod} SHIFT, j, resizeactive, 0 -10

      # switch workspaces with mainMod + [0-9]
      bind = ${mainMod}, 1, workspace, 1
      bind = ${mainMod}, 2, workspace, 2
      bind = ${mainMod}, 3, workspace, 3
      bind = ${mainMod}, 4, workspace, 4
      bind = ${mainMod}, 5, workspace, 5
      bind = ${mainMod}, 6, workspace, 6
      bind = ${mainMod}, 7, workspace, 7
      bind = ${mainMod}, 8, workspace, 8
      bind = ${mainMod}, 9, workspace, 9
      bind = ${mainMod}, 0, workspace, 10

      bind = ${mainMod} SHIFT, 1, movetoworkspacesilent, 1
      bind = ${mainMod} SHIFT, 2, movetoworkspacesilent, 2
      bind = ${mainMod} SHIFT, 3, movetoworkspacesilent, 3
      bind = ${mainMod} SHIFT, 4, movetoworkspacesilent, 4
      bind = ${mainMod} SHIFT, 5, movetoworkspacesilent, 5
      bind = ${mainMod} SHIFT, 6, movetoworkspacesilent, 6
      bind = ${mainMod} SHIFT, 7, movetoworkspacesilent, 7
      bind = ${mainMod} SHIFT, 8, movetoworkspacesilent, 8
      bind = ${mainMod} SHIFT, 9, movetoworkspacesilent, 9
      bind = ${mainMod} SHIFT, 0, movetoworkspacesilent, 10
      bind = ${mainMod} CTRL, 1, movetoworkspace, 1
      bind = ${mainMod} CTRL, 2, movetoworkspace, 2
      bind = ${mainMod} CTRL, 3, movetoworkspace, 3
      bind = ${mainMod} CTRL, 4, movetoworkspace, 4
      bind = ${mainMod} CTRL, 5, movetoworkspace, 5
      bind = ${mainMod} CTRL, 6, movetoworkspace, 6
      bind = ${mainMod} CTRL, 7, movetoworkspace, 7
      bind = ${mainMod} CTRL, 8, movetoworkspace, 8
      bind = ${mainMod} CTRL, 9, movetoworkspace, 9
      bind = ${mainMod} CTRL, 0, movetoworkspace, 10

      bind = ${mainMod}, mouse_down, workspace, e+1
      bind = ${mainMod}, mouse_up, workspace, e-1

      bindel = , xF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3.0%+ && printf "%.0f" $(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100/150*100 " " $3}') | ${notifyctl} audio
      bindel = , xF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3.0%- && printf "%.0f" $(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100/150*100 " " $3}') | ${notifyctl} audio
      bindm = ${mainMod}, mouse:272, movewindow
      bindm = ${mainMod}, mouse:273, resizewindow

      env = NIXOS_OZONE_WL,1
      env = XDG_CURRENT_DESKTOP,${config.home.sessionVariables.XDG_CURRENT_DESKTOP}
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,${config.home.sessionVariables.XDG_SESSION_DESKTOP}
      env = MOZ_ENABLE_WAYLAND,1
      env = QT_QPA_PLATFORM,wayland
      # env = SDL_VIDEODRIVER,wayland
      env = GDK_BACKEND,wayland,x11
      env = CLUTTER_BACKEND,wayland
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

      exec-once = ${lib.getExe pkgs.swaybg} -i "$(find ${config.xdg.userDirs.pictures}/wallpapers/ -type f | shuf -n 1)" -m fill

      monitor = DP-3,preferred,0x0,1
      monitor = DP-2,preferred,2560x0,1
      workspace = 1, monitor:DP-3
      workspace = 2, monitor:DP-2

      # monitor = eDP-1,preferred,0x0,1
      # monitor = DP-3,preferred,1920x0,1
      # monitor = DP-4,preferred,3840x0,1
      # monitor = DP-5,preferred,1920x0,1
      # monitor = DP-6,preferred,3840x0,1

      # workspace = 1, monitor:eDP-1
      # workspace = 2, monitor:DP-3
      # workspace = 3, monitor:DP-4

      dwindle {
        preserve_split = yes
        pseudotile = yes
      }

      master {
        mfact = 0.550000
        new_is_master = true
        new_on_top = true
      }

      general {
        border_size = 4
        col.active_border = rgba(88c0d0ee)
        col.inactive_border = rgba(2e3440aa)
        gaps_in = 5
        gaps_out = 20
        layout = master
      }

      input {
        follow_mouse = 2
        kb_layout = us
        repeat_delay = 250
        repeat_rate = 50
        sensitivity = 0.5
        scroll_button = 13;

        touchpad {
          clickfinger_behavior = true
          disable_while_typing = true
          drag_lock = true
          middle_button_emulation = true
          natural_scroll = true
          tap-to-click = true
        }
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_cancel_ratio = 0.150000
      }

      decoration {
        col.shadow = rgba(1a1a1aee)
        drop_shadow = yes
        rounding = 10
        shadow_range = 4
        shadow_render_power = 3

        blur {
          enabled = true
          new_optimizations = on
          passes = 2
          size = 5
        }
      }

      animations {
        bezier = easeInBack, 0.360000, 0, 0.660000, -0.560000
        bezier = easeInCirc, 0.550000, 0, 1, 0.450000
        bezier = easeInCubic, 0.320000, 0, 0.670000, 0
        bezier = easeInExpo, 0.700000, 0, 0.840000, 0
        bezier = easeInOutBack, 0.680000, -0.600000, 0.320000, 1.600000
        bezier = easeInOutCirc, 0.850000, 0, 0.150000, 1
        bezier = easeInOutCubic, 0.650000, 0, 0.350000, 1
        bezier = easeInOutExpo, 0.870000, 0, 0.130000, 1
        bezier = easeInOutQuad, 0.450000, 0, 0.550000, 1
        bezier = easeInOutQuart, 0.760000, 0, 0.240000, 1
        bezier = easeInOutQuint, 0.830000, 0, 0.170000, 1
        bezier = easeInOutSine, 0.370000, 0, 0.630000, 1
        bezier = easeInQuad, 0.110000, 0, 0.500000, 0
        bezier = easeInQuart, 0.500000, 0, 0.750000, 0
        bezier = easeInQuint, 0.640000, 0, 0.780000, 0
        bezier = easeInSine, 0.120000, 0, 0.390000, 0
        bezier = easeOutBack, 0.340000, 1.560000, 0.640000, 1
        bezier = easeOutCirc, 0, 0.550000, 0.450000, 1
        bezier = easeOutCubic, 0.330000, 1, 0.680000, 1
        bezier = easeOutExpo, 0.160000, 1, 0.300000, 1
        bezier = easeOutQuad, 0.500000, 1, 0.890000, 1
        bezier = easeOutQuart, 0.250000, 1, 0.500000, 1
        bezier = easeOutQuint, 0.220000, 1, 0.360000, 1
        bezier = easeOutSine, 0.610000, 1, 0.880000, 1
        bezier = linear, 0, 0, 1, 1

        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = windows, 1, 7, default
        animation = windowsOut, 1, 7, default, popin 80%
        animation = workspaces, 1, 6, default
      }


      windowrulev2 = opacity 0.9 0.8, class:^(^(Alacritty)$)$
      windowrulev2 = float, class:^(^(blueberry.py)$)$
      windowrulev2 = float, class:^(^(org.keepassxc.KeePassXC)$)$

      misc {
        disable_autoreload = true
        disable_hyprland_logo = true
        enable_swallow = true
        key_press_enables_dpms = true
        mouse_move_enables_dpms = true
        mouse_move_focuses_monitor = false
        swallow_regex = ^(Alacritty)$
        vrr = 1
      }
    '';
    # keyBinds = let
    #   mainMod = "SUPER";
    #   notifyctl = "${lib.getExe (pkgs.callPackage ../../../pkgs/notifyctl { })}";
    #   playerctl = "${lib.getExe pkgs.playerctl}";
    #   wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
    #   brightnessctl = "${lib.getExe pkgs.brightnessctl}";
    # in
    # {
    #   bind = {
    #     "${mainMod} SHIFT, q" = "killactive";
    #     "${mainMod} SHIFT, e" = "exit"; 
    #     "${mainMod}, space" = "togglefloating";
    #     "${mainMod}, semicolon" = "exec, ${config.home.sessionVariables.TERM}";
    #     "${mainMod}, b" = "exec, ${config.home.sessionVariables.BROWSER}";
    #     "${mainMod}, p" = "exec, ${config.home.sessionVariables.PSWD_MGR}";
    #     "${mainMod}, d" = "exec, exec $(${pkgs.coreutils-full}/bin/basename -a $(${pkgs.fd}/bin/fd -Lt x . --maxdepth 1 $(echo $PATH | sed \"s/:/ /g\" | ${pkgs.coreutils-full}/bin/sort -u)) | ${pkgs.fuzzel}/bin/fuzzel -d)";
    #     "${mainMod} SHIFT, s" = "exec, ${pkgs.grimblast}/bin/grimblast --notify copysave area ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots/$(date +%F_%H%M%S).png";
    #     "${mainMod} SHIFT, return" = "layoutmsg, swapwithmaster master";
    #     "${mainMod} SHIFT, r" = "exec, hyprctl reload";

    #     "${mainMod} SHIFT, p" = "pseudo"; # dwindle
    #     "${mainMod}, s" = "togglesplit, "; # dwindle
    #     "${mainMod}, g" = "togglegroup, ";
    #     "${mainMod}, bracketleft" = "changegroupactive, b";
    #     "${mainMod}, bracketright" = "changegroupactive, f";
    #     "${mainMod} ALT, w" = "moveintogroup, u";
    #     "${mainMod} ALT, a" = "moveintogroup, l";
    #     "${mainMod} ALT, s" = "moveintogroup, d";
    #     "${mainMod} ALT, d" = "moveintogroup, r";
    #     "${mainMod} ALT, g" = "moveoutofgroup, ";
    #     ", xF86AudioMute" = "exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 \" \" $3}' | ${notifyctl} audio";
    #     ", xF86MonBrightnessUp" = "exec, ${brightnessctl} -m s +2% | cut -d, -f4 | ${notifyctl} backlight";
    #     ", xF86MonBrightnessdown" = "exec, ${brightnessctl} -m s 2%- | cut -d, -f4 | ${notifyctl} backlight";
    #     ", xF86AudioPlay" = "exec, ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";
    #     ", xF86AudioNext" = "exec, ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";
    #     ", xF86AudioPrev" = "exec, ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";
    #     ", xF86AudioStop" = "exec, ${playerctl} stop && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";
    #     "${mainMod}, xF86AudioMute" = "exec, ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";
    #     "${mainMod}, xF86AudioRaiseVolume" = "exec, ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";
    #     "${mainMod}, xF86AudioLowerVolume" = "exec, ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl} mpris";

    #     # move focus with mainMod + arrow keys
    #     "${mainMod}, h" = "movefocus, l";
    #     "${mainMod}, l" = "movefocus, r";
    #     "${mainMod}, k" = "movefocus, u";
    #     "${mainMod}, j" = "movefocus, d";

    #     "${mainMod} SHIFT, h" = "resizeactive, -10 0";
    #     "${mainMod} SHIFT, l" = "resizeactive, 10 0";
    #     "${mainMod} SHIFT, k" = "resizeactive, 0 10";
    #     "${mainMod} SHIFT, j" = "resizeactive, 0 -10";

    #     # switch workspaces with mainMod + [0-9]
    #     "${mainMod}, 1" = "workspace, 1";
    #     "${mainMod}, 2" = "workspace, 2";
    #     "${mainMod}, 3" = "workspace, 3";
    #     "${mainMod}, 4" = "workspace, 4";
    #     "${mainMod}, 5" = "workspace, 5";
    #     "${mainMod}, 6" = "workspace, 6";
    #     "${mainMod}, 7" = "workspace, 7";
    #     "${mainMod}, 8" = "workspace, 8";
    #     "${mainMod}, 9" = "workspace, 9";
    #     "${mainMod}, 0" = "workspace, 10";

    #     # move active window to a workspace with mainMod + SHIFT + [0-9]
    #     "${mainMod} SHIFT, 1" = "movetoworkspacesilent, 1";
    #     "${mainMod} SHIFT, 2" = "movetoworkspacesilent, 2";
    #     "${mainMod} SHIFT, 3" = "movetoworkspacesilent, 3";
    #     "${mainMod} SHIFT, 4" = "movetoworkspacesilent, 4";
    #     "${mainMod} SHIFT, 5" = "movetoworkspacesilent, 5";
    #     "${mainMod} SHIFT, 6" = "movetoworkspacesilent, 6";
    #     "${mainMod} SHIFT, 7" = "movetoworkspacesilent, 7";
    #     "${mainMod} SHIFT, 8" = "movetoworkspacesilent, 8";
    #     "${mainMod} SHIFT, 9" = "movetoworkspacesilent, 9";
    #     "${mainMod} SHIFT, 0" = "movetoworkspacesilent, 10";
    #     "${mainMod} CTRL, 1" = "movetoworkspace, 1";
    #     "${mainMod} CTRL, 2" = "movetoworkspace, 2";
    #     "${mainMod} CTRL, 3" = "movetoworkspace, 3";
    #     "${mainMod} CTRL, 4" = "movetoworkspace, 4";
    #     "${mainMod} CTRL, 5" = "movetoworkspace, 5";
    #     "${mainMod} CTRL, 6" = "movetoworkspace, 6";
    #     "${mainMod} CTRL, 7" = "movetoworkspace, 7";
    #     "${mainMod} CTRL, 8" = "movetoworkspace, 8";
    #     "${mainMod} CTRL, 9" = "movetoworkspace, 9";
    #     "${mainMod} CTRL, 0" = "movetoworkspace, 10";

    #     # scroll through existing workspaces with mainMod + scroll
    #     "${mainMod}, mouse_down" = "workspace, e+1";
    #     "${mainMod}, mouse_up" = "workspace, e-1";
    #   };
    #   bindel = {
    #     ", xF86AudioRaiseVolume" = "exec, ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3.0%+ && printf \"%.0f\" $(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100/150*100 \" \" $3}') | ${notifyctl} audio";
    #     ", xF86AudioLowerVolume" = "exec, ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 3.0%- && printf \"%.0f\" $(${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100/150*100 \" \" $3}') | ${notifyctl} audio";
    #   };
    #   bindm = {
    #     # move/resize windows with mainMod + lmb/rmb and dragging
    #     "${mainMod}, mouse:272" = "movewindow";
    #     "${mainMod}, mouse:273" = "resizewindow";
    #   };
    # };

    # windowRules = [
    #   {
    #     class = [ "^(Alacritty)$" ];
    #     rules = [ "opacity 0.9 0.8" ];
    #   }
    #   {
    #     class = [ "^(blueberry.py)$" ];
    #     rules = [ "float" ];
    #   }
    #   {
    #     class = [ "^(org.keepassxc.KeePassXC)$" ];
    #     rules = [ "float" ];
    #   }
    # ];

    # workspaceRules = {
    #   "1".monitor = "eDP-1";
    #   "2".monitor = "DP-3";
    #   "3".monitor = "DP-4";
    # };

    # animations.animation = {
    #   windows = {
    #     enable = true;
    #     duration = 700;
    #     curve = "default";
    #   };
    #   windowsOut = {
    #     enable = true;
    #     duration = 700;
    #     curve = "default";
    #     style = "popin 80%";
    #   };
    #   border = {
    #     enable = true;
    #     duration = 1000;
    #     curve = "default";
    #   };
    #   fade = {
    #     enable = true;
    #     duration = 700;
    #     curve = "default";
    #   };
    #   workspaces = {
    #     enable = true;
    #     duration = 600;
    #     curve = "default";
    #   };
    # };

    # config = {
    #   exec_once = [
    #     "${lib.getExe pkgs.swaybg} -i \"$(find ${config.xdg.userDirs.pictures}/wallpapers/ -type f | shuf -n 1)\" -m fill"
    #   ];

    #   decoration = {
    #     rounding = 10;
    #     blur = {
    #       enabled = true;
    #       size = 5;
    #       passes = 2;
    #       new_optimizations = "on";
    #     };
    #     drop_shadow = "yes";
    #     shadow_range = 4;
    #     shadow_render_power = 3;
    #     "col.shadow" = "rgba(1a1a1aee)";
    #   };

    #   gestures = {
    #     workspace_swipe = true;
    #     workspace_swipe_cancel_ratio = 0.15;
    #   };

    #   plugin.touch_gestures = {
    #     sensitivity = 4.0;
    #     workspace_swipe_fingers = 3;
    #   };

    #   input = {
    #     kb_layout = "us";
    #     natural_scroll = true;
    #     repeat_rate = 50;
    #     repeat_delay = 250;
    #     follow_mouse = 2;
    #     sensitivity = 0;

    #     touchpad = {
    #       natural_scroll = true;
    #       middle_button_emulation = true;
    #       clickfinger_behavior = true;
    #       tap-to-click = true;
    #       drag_lock = true;
    #       disable_while_typing = true;
    #     };
    #   };

    #   general = {
    #     gaps_in = 5;
    #     gaps_out = 20;
    #     border_size = 4;
    #     "col.active_border" = "rgba(88c0d0ee)";
    #     "col.inactive_border" = "rgba(2e3440aa)";

    #     layout = "master";
    #   };

    #   dwindle = {
    #     pseudotile = "yes";
    #     preserve_split = "yes";
    #   };

    #   master = {
    #     new_is_master = true;
    #     new_on_top = true;
    #     mfact = 0.55;
    #   };

    #   misc = {
    #     enable_swallow = true;
    #     swallow_regex = "^(Alacritty)$";
    #     mouse_move_focuses_monitor = false;
    #     disable_hyprland_logo = true;
    #     key_press_enables_dpms = true;
    #     mouse_move_enables_dpms = true;
    #     vrr = 1;
    #   };

    #   monitor = [
    #     "eDP-1,preferred,0x0,1"
    #     "DP-3,preferred,1920x0,1"
    #     "DP-4,preferred,3840x0,1"
    #     "DP-5,preferred,1920x0,1"
    #     "DP-6,preferred,3840x0,1"
    #   ];

    #   env = [
    #     "XDG_CURRENT_DESKTOP,${config.home.sessionVariables.XDG_CURRENT_DESKTOP}"
    #     "XDG_SESSION_TYPE,wayland"
    #     "XDG_SESSION_DESKTOP,${config.home.sessionVariables.XDG_SESSION_DESKTOP}"
    #     "MOZ_ENABLE_WAYLAND,1"
    #     "QT_QPA_PLATFORM,wayland"
    #     "SDL_VIDEODRIVER,wayland"
    #     "GDK_BACKEND,wayland,x11"
    #     "CLUTTER_BACKEND,wayland"
    #     "QT_AUTO_SCREEN_SCALE_FACTOR,1"
    #     "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    #   ];
    # };

    # extraConfig = ''
    #   plugin = ${inputs.hyprgrass.packages.${pkgs.system}.default}/lib/libhyprgrass.so
    # '';
  };
}
