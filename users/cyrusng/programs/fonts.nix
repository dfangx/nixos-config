{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    powerline-fonts
    material-design-icons
    corefonts
  ];
}
