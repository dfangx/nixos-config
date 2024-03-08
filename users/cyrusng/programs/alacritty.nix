{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        normal = {
          family = "Source Code Pro for Powerline";
          style = "Regular";
        };
        bold = {
          family = "Source Code Pro for Powerline";
          style = "Bold";
        };
        italic = {
          family = "Source Code Pro for Powerline";
          style = "Italic";
        };
        bold_italic = {
          family = "Source Code Pro for Powerline";
          style = "Bold Italic";
        };
        size = 12.0;
      };
      keyboard.bindings = [
        {
          key = "Space";
          mods = "Control";
          mode = "Vi|~Search";
          action = "ScrollToBottom";
        }
        {
          key = "Space";
          mods = "Control";
          mode = "~Search";
          action = "ToggleViMode";
        }
      ];
      colors = {
        primary = {
          background = "#2e3440";
          foreground = "#d8dee9";
          dim_foreground = "#a5abb6";
        };
        cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };
        vi_mode_cursor = {
          text = "#2e3440";
          cursor = "#d8dee9";
        };
        selection = {
          text = "CellForeground";
          cursor = "#4c566a";
        };
        search = {
          matches = {
            foreground = "CellBackground";
            background = "#88c0d0";
          };
          # footer_bar = {
          #   foreground = "#434c5e";
          #   background = "#d8dee9";
          # };
        };
        normal = {
          black = "#3b4252";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#88c0d0";
          white = "#e5e9f0";
        };
        bright = {
          black = "#4c566a";
          red = "#bf616a";
          green = "#a3be8c";
          yellow = "#ebcb8b";
          blue = "#81a1c1";
          magenta = "#b48ead";
          cyan = "#8fbcbb";
          white = "#eceff4";
        };
        dim = {
          black = "#373e4d";
          red = "#94545d";
          green = "#809575";
          yellow = "#b29e75";
          blue = "#68809a";
          magenta = "#8c738c";
          cyan = "#6d96a5";
          white = "#aeb3bb";
        };
        draw_bold_text_with_bright_colors = true;
      };
    };
  };
}
