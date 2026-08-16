{ config, lib, ... }:
{
  options.ftp.enable = lib.mkEnableOption "Enable ftp server";
  config = lib.mkIf config.ftp.enable {
    services.vsftpd = {
      enable = true;
      localUsers = true;
      userlist = [ "cyrusng" ];
      writeEnable = true;
      localRoot = "/srv/ftp/doorbell";
    };
  };
}
