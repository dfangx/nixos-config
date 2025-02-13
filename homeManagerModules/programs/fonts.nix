{ config, lib, pkgs, ... }:
{
  options.fonts.enable = lib.mkEnableOption "Enable fonts";
  config = lib.mkIf config.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      powerline-fonts
      material-design-icons
      corefonts
    ];
  };
}
