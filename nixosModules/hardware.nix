{ config, pkgs, lib, inputs, host, ... }:
{
  options.desktopHardware.enable = lib.mkEnableOption "Enable desktop hardware options";
  config = lib.mkIf config.desktopHardware.enable {
    hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        bluetooth.enable = true;
        xpadneo.enable = true;
        steam-hardware.enable = true;
    };
  };
}
