{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    reloadConfig = true;
    recommendedEnvironment = true;
    keyBinds = let
      mainMod = "SUPER";
      notifyctl = pkgs.callPackage ../../../pkgs/notifyctl { };
      audioctl = pkgs.callPackage ../../../pkgs/audioctl { };
      playerctl = "${pkgs.playerctl}/bin/playerctl";
    in
    {
      bind = {
        "${mainMod} SHIFT, q" = "killactive";
        "${mainMod} SHIFT, e" = "exit"; 
        "${mainMod}, space" = "togglefloating";
        "${mainMod}, semicolon" = "exec, ${config.home.sessionVariables.TERM}";
        "${mainMod}, b" = "exec, ${config.home.sessionVariables.BROWSER}";
        "${mainMod}, p" = "exec, ${config.home.sessionVariables.PSWD_MGR}";
        "${mainMod}, d" = "exec, exec $(${pkgs.coreutils-full}/bin/basename -a $(${pkgs.fd}/bin/fd -Lt x . --maxdepth 1 $(echo $PATH | sed \"s/:/ /g\" | ${pkgs.coreutils-full}/bin/sort -u)) | ${pkgs.fuzzel}/bin/fuzzel -d)";
        "${mainMod} SHIFT, s" = "exec, ${pkgs.grimblast}/bin/grimblast --notify copysave area ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots/$(date +%F_%H%M%S).png";
        "${mainMod} SHIFT, return" = "layoutmsg, swapwithmaster master";
        "${mainMod} SHIFT, r" = "exec, hyprctl reload";

        "${mainMod} SHIFT, p" = "pseudo"; # dwindle
        "${mainMod}, s" = "togglesplit, "; # dwindle
        "${mainMod}, g" = "togglegroup, ";
        "${mainMod}, bracketleft" = "changegroupactive, b";
        "${mainMod}, bracketright" = "changegroupactive, f";
        "${mainMod} ALT, w" = "moveintogroup, u";
        "${mainMod} ALT, a" = "moveintogroup, l";
        "${mainMod} ALT, s" = "moveintogroup, d";
        "${mainMod} ALT, d" = "moveintogroup, r";
        "${mainMod} ALT, g" = "moveoutofgroup, ";
        ", xF86AudioMute" = "exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 \" \" $3}' | ${notifyctl}/bin/notifyctl audio";
        ", xF86MonBrightnessUp" = "exec, brightnessctl -m s +2% | cut -d, -f4 | ${notifyctl}/bin/notifyctl backlight";
        ", xF86MonBrightnessdown" = "exec, brightnessctl -m s 2%- | cut -d, -f4 | ${notifyctl}/bin/notifyctl backlight";
        ", xF86AudioPlay" = "exec, ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";
        ", xF86AudioNext" = "exec, ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";
        ", xF86AudioPrev" = "exec, ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";
        ", xF86AudioStop" = "exec, ${playerctl} stop && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";
        "${mainMod}, xF86AudioMute" = "exec, ${playerctl} play-pause && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";
        "${mainMod}, xF86AudioRaiseVolume" = "exec, ${playerctl} next && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";
        "${mainMod}, xF86AudioLowerVolume" = "exec, ${playerctl} previous && ${playerctl} metadata -f '{{title}},{{artist}}' | ${notifyctl}/bin/notifyctl mpris";

        # move focus with mainMod + arrow keys
        "${mainMod}, h" = "movefocus, l";
        "${mainMod}, l" = "movefocus, r";
        "${mainMod}, k" = "movefocus, u";
        "${mainMod}, j" = "movefocus, d";

        "${mainMod} SHIFT, h" = "resizeactive, -10 0";
        "${mainMod} SHIFT, l" = "resizeactive, 10 0";
        "${mainMod} SHIFT, k" = "resizeactive, 0 10";
        "${mainMod} SHIFT, j" = "resizeactive, 0 -10";

        # switch workspaces with mainMod + [0-9]
        "${mainMod}, 1" = "workspace, 1";
        "${mainMod}, 2" = "workspace, 2";
        "${mainMod}, 3" = "workspace, 3";
        "${mainMod}, 4" = "workspace, 4";
        "${mainMod}, 5" = "workspace, 5";
        "${mainMod}, 6" = "workspace, 6";
        "${mainMod}, 7" = "workspace, 7";
        "${mainMod}, 8" = "workspace, 8";
        "${mainMod}, 9" = "workspace, 9";
        "${mainMod}, 0" = "workspace, 10";

        # move active window to a workspace with mainMod + SHIFT + [0-9]
        "${mainMod} SHIFT, 1" = "movetoworkspacesilent, 1";
        "${mainMod} SHIFT, 2" = "movetoworkspacesilent, 2";
        "${mainMod} SHIFT, 3" = "movetoworkspacesilent, 3";
        "${mainMod} SHIFT, 4" = "movetoworkspacesilent, 4";
        "${mainMod} SHIFT, 5" = "movetoworkspacesilent, 5";
        "${mainMod} SHIFT, 6" = "movetoworkspacesilent, 6";
        "${mainMod} SHIFT, 7" = "movetoworkspacesilent, 7";
        "${mainMod} SHIFT, 8" = "movetoworkspacesilent, 8";
        "${mainMod} SHIFT, 9" = "movetoworkspacesilent, 9";
        "${mainMod} SHIFT, 0" = "movetoworkspacesilent, 10";
        "${mainMod} CTRL, 1" = "movetoworkspace, 1";
        "${mainMod} CTRL, 2" = "movetoworkspace, 2";
        "${mainMod} CTRL, 3" = "movetoworkspace, 3";
        "${mainMod} CTRL, 4" = "movetoworkspace, 4";
        "${mainMod} CTRL, 5" = "movetoworkspace, 5";
        "${mainMod} CTRL, 6" = "movetoworkspace, 6";
        "${mainMod} CTRL, 7" = "movetoworkspace, 7";
        "${mainMod} CTRL, 8" = "movetoworkspace, 8";
        "${mainMod} CTRL, 9" = "movetoworkspace, 9";
        "${mainMod} CTRL, 0" = "movetoworkspace, 10";

        # scroll through existing workspaces with mainMod + scroll
        "${mainMod}, mouse_down" = "workspace, e+1";
        "${mainMod}, mouse_up" = "workspace, e-1";
      };
      bindel = {
        ", xF86AudioRaiseVolume" = "exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 2%+ && ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 \" \" $3}' | ${notifyctl}/bin/notifyctl audio";
        ", xF86AudioLowerVolume" = "exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- && ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 \" \" $3}' | ${notifyctl}/bin/notifyctl audio";
      };
      bindm = {
        # move/resize windows with mainMod + lmb/rmb and dragging
        "${mainMod}, mouse:272" = "movewindow";
        "${mainMod}, mouse:273" = "resizewindow";
      };
    };

    windowRules = [
      {
        class = [ "^(Alacritty)$" ];
        rules = [ "opacity 0.9 0.8" ];
      }
    ];

    workspaceRules = {
      "1".monitor = "eDP-1";
      "2".monitor = "DP-3";
      "3".monitor = "DP-4";
    };

    animations.animation = {
      windows = {
        enable = true;
        duration = 700;
        curve = "default";
      };
      windowsOut = {
        enable = true;
        duration = 700;
        curve = "default";
        style = "popin 80%";
      };
      border = {
        enable = true;
        duration = 1000;
        curve = "default";
      };
      fade = {
        enable = true;
        duration = 700;
        curve = "default";
      };
      workspaces = {
        enable = true;
        duration = 600;
        curve = "default";
      };
    };

    config = {
      exec_once = [
        "${pkgs.swaybg}/bin/swaybg -i \"$(find ${config.xdg.userDirs.pictures}/wallpapers/ -type f | shuf -n 1)\" -m fill"
      ];

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
          new_optimizations = "on";
        };
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      gestures = {
        workspace_swipe = true;
      };

      plugin.touch_gestures = {
        sensitivity = 4.0;
        workspace_swipe_fingers = 3;
      };

      input = {
        kb_layout = "us";
        natural_scroll = true;
        repeat_rate = 50;
        repeat_delay = 250;
        follow_mouse = 2;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
          middle_button_emulation = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          drag_lock = true;
          disable_while_typing = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 4;
        "col.active_border" = "rgba(88c0d0ee)";
        "col.inactive_border" = "rgba(2e3440aa)";

        layout = "master";
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_is_master = true;
        new_on_top = true;
        mfact = 0.55;
      };

      misc = {
        enable_swallow = true;
        swallow_regex = "^(Alacritty)$";
        mouse_move_focuses_monitor = false;
        disable_hyprland_logo = true;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
        vrr = 1;
      };

      monitor = [
        "eDP-1,preferred,0x0,1"
        "DP-3,preferred,1920x0,1"
        "DP-4,preferred,3840x0,1"
        "DP-5,preferred,1920x0,1"
        "DP-6,preferred,3840x0,1"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "GDK_BACKEND,wayland,x11"
        "CLUTTER_BACKEND,wayland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];
    };

    # extraConfig = ''
    #   plugin = ${pkgs.hyprgrass}/lib/libhyprgrass.so
    # '';
  };
}
