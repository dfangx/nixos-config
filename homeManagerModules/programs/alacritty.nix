{ config, lib, ... }:
{
  options.alacritty.enable = lib.mkEnableOption "Enable alacritty settings";
  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          dynamic_title = true;
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
          draw_bold_text_with_bright_colors = true;
        };
        general = {
          import = [ "${config.xdg.configHome}/alacritty/colors-alacritty.toml" ];
        };
      };
    };
  };
}
