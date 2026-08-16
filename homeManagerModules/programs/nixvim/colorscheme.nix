{pkgs, ... }:
{
  colorschemes.nightfox = {
    enable = true;
    autoLoad = true;
    flavor = "carbonfox";
    settings.options.transparent = true;
  };
  colorschemes.nord = {
    enable = false;
    settings = {
      borders = true;
      cursorline_transparent = true;
      disable_background = true;
      italic = true;
    };
  };
}
