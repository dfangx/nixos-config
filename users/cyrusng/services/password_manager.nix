{ pkgs, lib, ... }:
let
  passwordManager = "${lib.getExe' pkgs.keepassxc "keepassxc"}";
in
{
  home.sessionVariables.PSWD_MGR = "${passwordManager}";

  xdg.dataFile."dbus-1/services/org.freedesktop.secrets.service" = {
    enable = true;
    text = ''
      [D-BUS Service]
      Name=org.freedesktop.secrets
      Exec=${passwordManager}
    '';
  };
    # systemd.user.services.pswd-mgr = {
    #   Unit = {
    #     Description = "Launch ${passwordManager} at startup";
    #     After = [ "graphical-session-pre.target" ];
    #     PartOf=[ "graphical-session.target" ];
    #   };
    #   Install.WantedBy = [ "graphical-session.target" ];
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${passwordManager}";
    #   };
    # };

}
