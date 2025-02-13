{ config, lib, ... }:
{
  options.mpv.enable = lib.mkEnableOption "Enable mpv";
  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      config = {
        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
      };
    };
  };
}
