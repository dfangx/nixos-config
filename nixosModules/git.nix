{ config, lib, ... }:
{
  options.git.enable = lib.mkEnableOption "Enable git";
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      config.user = {
        name = "dfangx";
        email = "github.oxfrj2ct@bged98.anonaddy.com";
      };
    };
  };
}
