{ config, pkgs, lib, ... }:
let
  passwordManager = "${lib.getExe' pkgs.keepassxc "keepassxc"}";
in
{
  options.password_mgr.enable = lib.mkEnableOption "Enable password_mgr";
  config = lib.mkIf config.password_mgr.enable {
    home.sessionVariables.PSWD_MGR = "${passwordManager}";

    xdg.dataFile."dbus-1/services/org.freedesktop.secrets.service" = {
      enable = true;
      text = ''
        [D-BUS Service]
        Name=org.freedesktop.secrets
        Exec=${passwordManager}
      '';
    };
  };
}
