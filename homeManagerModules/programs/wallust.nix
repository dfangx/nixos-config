{ config, lib, pkgs, ... }:
{ 
  options.wallust.enable = lib.mkEnableOption "Enable wallust";
  config = lib.mkIf config.wallust.enable {
    home = {
      packages = with pkgs; [
        wallust
      ];
    };

    xdg.configFile = let
      templateDir = "wallust/templates";
    in
    {
      "${templateDir}/colors-kvantum.kvconfig".text = ''
        [ColorEffects:Disabled]
        ChangeSelectionColor=
        Color={{color0}}
        ColorAmount=0
        ColorEffect=0
        ContrastAmount=0.65
        ContrastEffect=1
        Enable=
        IntensityAmount=0.1
        IntensityEffect=2
        
        [ColorEffects:Inactive]
        ChangeSelectionColor=true
        Color={{color1}}
        ColorAmount=0.025000000000000001
        ColorEffect=2
        ContrastAmount=0.10000000000000001
        ContrastEffect=2
        Enable=false
        IntensityAmount=0
        IntensityEffect=0
        
        [Colors:Button]
        BackgroundAlternate={{background}}
        BackgroundNormal={{background}}
        DecorationFocus={{color2}}
        DecorationHover={{color3}}
        ForegroundActive={{foreground}}
        ForegroundInactive={{color4}}
        ForegroundLink={{color5}}
        ForegroundNegative={{color6}}
        ForegroundNeutral={{color7}}
        ForegroundNormal={{foreground}}
        ForegroundPositive={{color8}}
        ForegroundVisited={{color9}}
        
        [Colors:Selection]
        BackgroundAlternate={{color10}}
        BackgroundNormal={{color2}}
        DecorationFocus={{color2}}
        DecorationHover={{color3}}
        ForegroundActive={{foreground}}
        ForegroundInactive={{color4}}
        ForegroundLink={{color11}}
        ForegroundNegative={{color6}}
        ForegroundNeutral={{color7}}
        ForegroundNormal={{foreground}}
        ForegroundPositive={{color8}}
        ForegroundVisited={{color12}}
        
        [Colors:Tooltip]
        BackgroundAlternate={{background}}
        BackgroundNormal={{background}}
        DecorationFocus={{color2}}
        DecorationHover={{color3}}
        ForegroundActive={{foreground}}
        ForegroundInactive={{color4}}
        ForegroundLink={{color5}}
        ForegroundNegative={{color6}}
        ForegroundNeutral={{color7}}
        ForegroundNormal={{foreground}}
        ForegroundPositive={{color8}}
        ForegroundVisited={{color9}}
        
        [Colors:View]
        BackgroundAlternate={{background}}
        BackgroundNormal={{background}}
        DecorationFocus={{color2}}
        DecorationHover={{color3}}
        ForegroundActive={{foreground}}
        ForegroundInactive={{color4}}
        ForegroundLink={{color5}}
        ForegroundNegative={{color6}}
        ForegroundNeutral={{color7}}
        ForegroundNormal={{foreground}}
        ForegroundPositive={{color8}}
        ForegroundVisited={{color12}}
        
        [Colors:Window]
        BackgroundAlternate={{background}}
        BackgroundNormal={{background}}
        DecorationFocus={{color2}}
        DecorationHover={{color3}}
        ForegroundActive={{foreground}}
        ForegroundInactive={{color4}}
        ForegroundLink={{color5}}
        ForegroundNegative={{color6}}
        ForegroundNeutral={{color7}}
        ForegroundNormal={{foreground}}
        ForegroundPositive={{color8}}
        ForegroundVisited={{color9}}
        
        [DirSelect Dialog]
        DirSelectDialog Size=867,590
        History Items[$e]=file:${config.xdg.configHome}/Kvantum/Wallust,file:${config.xdg.configHome}/Kvantum/Dracula-purple,file:$HOME,file:${config.xdg.configHome}/Kvantum/Dracula-purple
        
        [General]
        ColorSchemeHash=e44c8d483c47a28c7d0e32e6b41dd227803affe5
        TerminalApplication=kitty
        TerminalService=kitty.desktop
        
        [Icons]
        Theme=Magna-Dark-Icons
        
        [KDE]
        LookAndFeelPackage=Dracula
        ShowDeleteCommand=false
        widgetStyle=qt6ct-style
        
        [KFileDialog Settings]
        Allow Expansion=false
        Automatically select filename extension=true
        Breadcrumb Navigation=false
        Decoration position=2
        LocationCombo Completionmode=5
        PathCombo Completionmode=5
        Show Bookmarks=false
        Show Full Path=false
        Show Inline Previews=true
        Show Preview=false
        Show Speedbar=true
        Show hidden files=true
        Sort by=Name
        Sort directories first=true
        Sort hidden files last=false
        Sort reversed=true
        Speedbar Width=154
        View Style=Detail
        
        [KScreen]
        ScreenScaleFactors=eDP-1=1;HDMI-A-1=1;
        XwaylandClientsScale=false
        
        [PreviewSettings]
        MaximumRemoteSize=0
        
        [WM]
        activeBackground={{background}}
        activeBlend={{background}}
        activeForeground={{foreground}}
        inactiveBackground={{background}}
        inactiveBlend={{background}}
        inactiveForeground={{color4}}
      '';
      "${templateDir}/colors-waybar.css".text = ''
        @define-color cursor {{cursor}};
        @define-color background {{background}};
        @define-color foreground {{foreground}};
        @define-color color0  {{color0 }};
        @define-color color1  {{color1 }};
        @define-color color2  {{color2 }};
        @define-color color3  {{color3 }};
        @define-color color4  {{color4 }};
        @define-color color5  {{color5 }};
        @define-color color6  {{color6 }};
        @define-color color7  {{color7 }};
        @define-color color8  {{color8 }};
        @define-color color9  {{color9 }};
        @define-color color10 {{color10}};
        @define-color color11 {{color11}};
        @define-color color12 {{color12}};
        @define-color color13 {{color13}};
        @define-color color14 {{color14}};
        @define-color color15 {{color15}};
      '';
      "${templateDir}/colors-alacritty.toml".text = ''
        [colors.primary]
        background = '{{background}}'
        foreground = '{{foreground}}'
        
        [colors.cursor]
        text = '{{foreground}}'
        cursor = '{{cursor}}'
        
        [colors.normal]
        black   = '{{color0}}'
        red     = '{{color1}}'
        green   = '{{color2}}'
        yellow  = '{{color3}}'
        blue    = '{{color4}}'
        magenta = '{{color5}}'
        cyan    = '{{color6}}'
        white   = '{{color7}}'
        
        [colors.bright]
        black   = '{{color8}}'
        red     = '{{color9}}'
        green   = '{{color10}}'
        yellow  = '{{color11}}'
        blue    = '{{color12}}'
        magenta = '{{color13}}'
        cyan    = '{{color14}}'
        white   = '{{color15}}'
      '';
      "${templateDir}/colors-hyprland.conf".text = ''
        general {
          col.active_border = rgb({{color1 | saturate(0.6) | strip}}) rgb({{color2 | saturate(0.6) | strip}}) rgb({{color3 | saturate(0.6) | strip}}) rgb({{color4 | saturate(0.6) | strip}}) rgb({{color5 | saturate(0.6) | strip}}) rgb({{color6 | saturate(0.6) | strip}})
          col.inactive_border = rgba({{color0 | strip}}ee)
        }
      '';
      "${templateDir}/colors-firefox.json".text = ''
        {
          "wallpaper": "{{wallpaper}}",
          "alpha": "100",

          "special": {
              "background": "{{background}}",
              "foreground": "{{foreground}}",
              "cursor": "{{cursor}}"
          },
          "colors": {
              "color0": "{{color0}}",
              "color1": "{{color1}}",
              "color2": "{{color2}}",
              "color3": "{{color3}}",
              "color4": "{{color4}}",
              "color5": "{{color5}}",
              "color6": "{{color6}}",
              "color7": "{{color7}}",
              "color8": "{{color8}}",
              "color9": "{{color9}}",
              "color10": "{{color10}}",
              "color11": "{{color11}}",
              "color12": "{{color12}}",
              "color13": "{{color13}}",
              "color14": "{{color14}}",
              "color15": "{{color15}}"
          }
        }
      '';
      "${templateDir}/colors-foot.ini".text = ''
        [colors]
        background={{background | strip}}
        foreground={{foreground | strip}}
        
        regular0={{color0 | strip}}
        regular1={{color1 | strip}}
        regular2={{color2 | strip}}
        regular3={{color3 | strip}}
        regular4={{color4 | strip}}
        regular5={{color5 | strip}}
        regular6={{color6 | strip}}
        regular7={{color7 | strip}}
        
        bright0={{color8 | strip}}
        bright1={{color9 | strip}}
        bright2={{color10 | strip}}
        bright3={{color11 | strip}}
        bright4={{color12 | strip}}
        bright5={{color13 | strip}}
        bright6={{color14 | strip}}
        bright7={{color15 | strip}}
      '';
      "${templateDir}/colors-fzf.sh".text = ''
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:{{background}},spinner:{{color5}},hl:{{color8}},fg:{{foreground}},header:{{color8}},info:{{color4}},pointer:{{color2}},marker:{{color2}},fg+:{{color1}},prompt:{{color4}},hl+:{{color8}}"
      '';
      "wallust/wallust.toml".text = ''
        backend = "wal"
        palette = "dark16"
        color_space = "lch"

        [templates]
        waybar.template = 'colors-waybar.css'
        waybar.target = '${config.xdg.configHome}/waybar/wallust/colors-waybar.css'

        alacritty.template = 'colors-alacritty.toml'
        alacritty.target = '${config.xdg.configHome}/alacritty/colors-alacritty.toml'

        hyprland.template = 'colors-hyprland.conf'
        hyprland.target = '${config.xdg.configHome}/hypr/colors-hyprland.conf'

        firefox.template = 'colors-firefox.json'
        firefox.target = '${config.xdg.cacheHome}/wal/colors.json'

        foot.template = 'colors-foot.ini'
        foot.target = '${config.xdg.configHome}/foot/colors-foot.ini'

        fzf.template = 'colors-fzf.sh'
        fzf.target = '${config.xdg.configHome}/fzf/colors-fzf.sh'

        kvantum.template = 'colors-kvantum.kvconfig'
        kvantum.target = '${config.xdg.configHome}/Kvantum/Wallust/Wallust.kvconfig'
      '';
    };

    programs.bash.bashrcExtra=''. ${config.xdg.configHome}/fzf/colors-fzf.sh'';
  };
}
