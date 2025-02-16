{ config, lib, pkgs, ... }:
let 
  notifyctl = pkgs.callPackage ../../../pkgs/notifyctl { };
  audioctl = pkgs.callPackage ../../../pkgs/audioctl { };
in
{
  options.river.enable = lib.mkEnableOption "Enable river";
  config = lib.mkIf config.river.enable {
    home.packages = with pkgs; [
      river
    ];

    xdg.configFile."river/init" = {
      text = ''
        #!/bin/sh

        touchpad="pointer-1267-12377-ELAN1200:00_04F3:3059_Touchpad"
        mod="Super"

        riverctl background-color 0x2e3440
        riverctl border-color-focused 0x88c0d0
        riverctl border-color-unfocused 0x2e3440
        riverctl border-width 4
        
        riverctl input $touchpad disable-whlie-typing enabled
        riverctl input $touchpad middle-emulation enabled
        riverctl input $touchpad natural-scroll enabled
        riverctl input $touchpad tap enabled
        
        riverctl map normal $mod Semicolon spawn ${config.home.sessionVariables.TERM};
        riverctl map normal $mod B spawn ${config.home.sessionVariables.BROWSER};
        riverctl map normal $mod P spawn ${config.home.sessionVariables.PSWD_MGR};
        riverctl map normal $mod D spawn 'riverctl spawn $(fd -Lt x . --maxdepth 1 $(echo $PATH | sed "s/:/ /g") | fuzzel -d)';
        riverctl map normal $mod+Shift R spawn '~/.config/river/init && pkill -SIGUSR2 waybar';
        riverctl map normal $mod+Shift S spawn snip;
        riverctl map normal $mod+Shift Q close;
        riverctl map normal $mod+Shift E exit;
        riverctl map normal $mod J focus-view next;
        riverctl map normal $mod K focus-view previous;
        riverctl map normal $mod+Shift J swap next;
        riverctl map normal $mod+Shift K swap previous;
        riverctl map normal $mod Period focus-output next;
        riverctl map normal $mod Comma focus-output previous;
        riverctl map normal $mod+Shift Period send-to-output next;
        riverctl map normal $mod+Shift Comma send-to-output previous;
        riverctl map normal $mod+Shift Return zoom;
        riverctl map normal $mod Space toggle-float;
        riverctl map normal $mod F toggle-fullscreen;

        # Various media key mapping examples for both normal and locked mode which do
        # not have a modifier
        for mode in normal locked
        do
          riverctl map $mode None XF86AudioRaiseVolume spawn '${audioctl}/bin/audioctl + | ${notifyctl}/bin/notifyctl audio';
          riverctl map $mode None XF86AudioLowerVolume spawn '${audioctl}/bin/audioctl - | ${notifyctl}/bin/notifyctl audio';
          riverctl map $mode None XF86AudioMute spawn '${audioctl}/bin/audioctl x | ${notifyctl}/bin/notifyctl audio';
          riverctl map $mode None XF86MonBrightnessUp spawn 'brightnessctl -m s +2% | cut -d, -f4 | ${notifyctl}/bin/notifyctl backlight';
          riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl -m s 2%- | cut -d, -f4 | ${notifyctl}/bin/notifyctl backlight';
        done

        for i in $(seq 1 9)
        do
            tags=$((1 << ($i - 1)))
        
            # Super+Ctrl+[1-9] to focus tag [0-8]
            riverctl map normal Super+Control $i set-focused-tags $tags
        
            # Super+Shift+[1-9] to tag focused view with tag [0-8]
            riverctl map normal Super+Shift $i set-view-tags $tags
        
            # Super+[1-9] to toggle focus of tag [0-8]
            riverctl map normal Super $i toggle-focused-tags $tags
        
            # Super+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
            riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
        done

        all_tags=$(((1 << 32) - 1))
        riverctl map normal $mod 0 set-focused-tags $(((1 << 32) - 1));
        riverctl map normal $mod+Shift 0 set-view-tags $(((1 << 32) - 1));

        riverctl map normal $mod+Shift H send-layout-cmd rivertile "main-ratio -0.05";
        riverctl map normal $mod+Shift L send-layout-cmd rivertile "main-ratio +0.05";
        riverctl map normal $mod I send-layout-cmd rivertile "main-count +0.05";
        riverctl map normal $mod+Shift I send-layout-cmd rivertile "main-count -1";
        riverctl map normal $mod Up send-layout-cmd rivertile "main-location top";
        riverctl map normal $mod Right send-layout-cmd rivertile "main-location right";
        riverctl map normal $mod Down send-layout-cmd rivertile "main-location bottom";
        riverctl map normal $mod Left send-layout-cmd rivertile "main-location left";
        
        riverctl float-filter-add app-id float
        riverctl float-filter-add title "popup title with spaces"
        riverctl float-filter-add app-id fzf-run
        riverctl float-filter-add title "Zoom Cloud Meetings"
        riverctl float-filter-add title "Zoom"
        riverctl float-filter-add title "audio conference options"
        riverctl float-filter-add title "KeePassXC - Browser Access Request"
        
        # Set app-ids and titles of views which should use client side decorations
        riverctl csd-filter-add app-id "gedit"
        
        riverctl set-repeat 50 300
        riverctl focus-output right
        riverctl declare-mode passthrough
        riverctl map normal Mod4 F11 enter-mode passthrough
        riverctl map passthrough Mod4 F11 enter-mode normal
        
        swaybg_pid="$(pgrep swaybg)"
        riverctl spawn "swaybg -i \"$(find ~/pics/wallpapers/ -type f | shuf -n 1)\" -m fill && kill $swaybg_pid"
        
        systemctl --user import-environment
        systemctl --user start river-session.target
        
        riverctl default-layout rivertile
        rivertile -view-padding 6 -outer-padding 6
        
        systemctl --user stop river-session.target
      '';
      executable = true;
    };
  };
}
