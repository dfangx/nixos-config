{ config, pkgs, ... }:
{
  programs.beets = {
    enable = true;
    package = pkgs.beets.override {
      pluginOverrides = {
        chroma.enable = true;
        replaygain.enable = true;
        edit.enable = true;
        unimported.enable = true;
        duplicates.enable = true;
        fetchart.enable = true;
        embedart.enable = true;
        lastgenre.enable = true;
        mbsync.enable = true;
        info.enable = true;
      };
    };
    settings = {
      threaded = "yes";
      directory = config.xdg.userDirs.music;
      library = "${config.xdg.userDirs.music}/.beets.db";
      plugins = "chroma replaygain edit unimported duplicates embedart fetchart lastgenre mbsync info";
      chroma = {
        auto = "yes";
      };
      replaygain = {
        backend = "ffmpeg";
        # r128_targetlevel = 89;
        threads = 16;
      };
      unimported.ignore_subdirectories = "tmp";
      lastgenre = {
        count = 3;
        source = "track";
      };
    };
  };
}
