{ config, pkgs, lib, inputs, host, ... }:
{
  options.bootOpts.enable = lib.mkEnableOption "Enable boot options";
  config = lib.mkIf config.bootOpts.enable {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
