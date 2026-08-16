{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  options.themes.enable = lib.mkEnableOption "Enable stylix";

  config = lib.mkIf config.stylix.enable {
    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    };
  };
}
