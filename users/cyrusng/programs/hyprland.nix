{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = let 
      notifyctl = pkgs.callPackage ../../../pkgs/notifyctl { };
      audioctl = pkgs.callPackage ../../../pkgs/audioctl { };
    in
    ''
      # Refer to the wiki for more information.
      
      #
      # Please note not all available settings / options are set here.
      # For a full list, see the wiki
      #

      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = MOZ_ENABLE_WAYLAND,1
      env = QT_QPA_PLATFORM,wayland;xcb
      env = SDL_VIDEODRIVER,wayland
      env = GDK_BACKEND,wayland,x11
      env = CLUTTER_BACKEND,wayland
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = eDP-1,preferred,0x0,1
      monitor = DP-3,preferred,1920x0,1
      monitor = DP-4,preferred,3840x0,1
      monitor = DP-5,preferred,1920x0,1
      monitor = DP-6,preferred,3840x0,1
      
      wsbind = 1,eDP-1
      wsbind = 2,DP-3
      wsbind = 3,DP-4
      wsbind = 2,DP-5
      wsbind = 3,DP-6
      
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      
      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      exec-once = ${pkgs.swaybg}/bin/swaybg -i "$(find ${config.xdg.userDirs.pictures}/wallpapers/ -type f | shuf -n 1)" -m fill 
      exec-once = ${pkgs.keepassxc}/bin/keepassxc
      
      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf
      
      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =
      
          follow_mouse = 0
          natural_scroll = true
          repeat_rate = 50
          repeat_delay = 250
          follow_mouse = 2
      
          touchpad {
              natural_scroll = true
              middle_button_emulation = true
              clickfinger_behavior = true
              tap-to-click = true
              drag_lock = true
              disable_while_typing = true
          }
      
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }
      
      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
      
          gaps_in = 5
          gaps_out = 20
          border_size = 4
          col.active_border = rgba(88c0d0ee) 
          col.inactive_border = rgba(2e3440aa)
      
          layout = master
      }
      
      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
      
          rounding = 10
          blur = yes
          blur_size = 5
          blur_passes = 2
          blur_new_optimizations = on
      
          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }
      
      animations {
          enabled = yes
      
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      
          bezier = myBezier, 0.05, 0.9, 0.1, 1.05
      
          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }
      
      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }
      
      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
          new_on_top = true
          mfact = 0.55
      }
      
      misc {
        enable_swallow = true
        swallow_regex = ^(Alacritty)$
        mouse_move_focuses_monitor = false
        vrr = 1
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      windowrulev2 = opacity 0.9 0.8,class:^(Alacritty)$
      
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER
      
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod SHIFT, Q, killactive, 
      bind = $mainMod SHIFT, E, exit, 
      bind = $mainMod, Space, togglefloating, 
      bind = $mainMod, Semicolon, exec, ${config.home.sessionVariables.TERM}
      bind = $mainMod, B, exec, ${config.home.sessionVariables.BROWSER}
      bind = $mainMod, P, exec, ${config.home.sessionVariables.PSWD_MGR}
      bind = $mainMod, D, exec, exec $(${pkgs.fd}/bin/fd -Lt x . --maxdepth 1 $(echo $PATH | sed "s/:/ /g") | ${pkgs.fuzzel}/bin/fuzzel -d)
      bind = $mainMod SHIFT, S , exec, ${pkgs.grimblast}/bin/grimblast --notify copysave area ${config.xdg.userDirs.pictures}/$(date +%Y)/screenshots/$(date +%F_%H%M%S).png
      bind = $mainMod SHIFT, Return, layoutmsg, swapwithmaster master
      bind = $mainMod SHIFT, R, exec, hyprctl reload

      bind = $mainMod SHIFT, P, pseudo, # dwindle
      bind = $mainMod, S, togglesplit, # dwindle
      bind = $mainMod, G, togglegroup, 
      bind = $mainMod, bracketleft, changegroupactive, b
      bind = $mainMod, bracketright, changegroupactive, f
      bind = $mainMod SHIFT, W, moveintogroup, u
      bind = $mainMod SHIFT, A, moveintogroup, l
      bind = $mainMod SHIFT, S, moveintogroup, d
      bind = $mainMod SHIFT, D, moveintogroup, r
      bind = $mainMod SHIFT, G, moveoutofgroup, 
      
      bindel = , XF86AudioRaiseVolume, exec, ${audioctl}/bin/audioctl + | ${notifyctl}/bin/notifyctl audio
      bindel = , XF86AudioLowerVolume, exec, ${audioctl}/bin/audioctl - | ${notifyctl}/bin/notifyctl audio
      bind = , XF86AudioMute, exec, ${audioctl}/bin/audioctl x | ${notifyctl}/bin/notifyctl audio
      bind = , XF86MonBrightnessUp, exec, brightnessctl -m s +2% | cut -d, -f4 | ${notifyctl}/bin/notifyctl backlight
      bind = , XF86MonBrightnessDown, exec, brightnessctl -m s 2%- | cut -d, -f4 | ${notifyctl}/bin/notifyctl backlight
      bind = , XF86AudioPlay, exec, playerctl play-pause
      bind = , XF86AudioNext, exec, playerctl next
      bind = , XF86AudioPrev, exec, playerctl previous
      bind = , XF86AudioStop, exec, playerctl stop

      # Move focus with mainMod + arrow keys
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d
      
      bind = $mainMod SHIFT, h, resizeactive, -10 0
      bind = $mainMod SHIFT, l, resizeactive, 10 0
      bind = $mainMod SHIFT, k, resizeactive, 0 10
      bind = $mainMod SHIFT, j, resizeactive, 0 -10

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      
      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10
      bind = $mainMod CTRL, 1, movetoworkspace, 1
      bind = $mainMod CTRL, 2, movetoworkspace, 2
      bind = $mainMod CTRL, 3, movetoworkspace, 3
      bind = $mainMod CTRL, 4, movetoworkspace, 4
      bind = $mainMod CTRL, 5, movetoworkspace, 5
      bind = $mainMod CTRL, 6, movetoworkspace, 6
      bind = $mainMod CTRL, 7, movetoworkspace, 7
      bind = $mainMod CTRL, 8, movetoworkspace, 8
      bind = $mainMod CTRL, 9, movetoworkspace, 9
      bind = $mainMod CTRL, 0, movetoworkspace, 10
      
      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1
      
      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };
}
