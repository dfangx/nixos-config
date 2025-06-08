{ config, lib, ... }:
{
  options.sshd.enable = lib.mkEnableOption "Enable sshd";
  config = lib.mkIf config.sshd.enable {
    services = {
      sshd.enable = true;
    };
  };
}
