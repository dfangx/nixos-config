{ inputs, config, pkgs, lib, ... }:
{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = lib.mkForce false;
      };
      treesitter-refactor.enable = lib.mkForce false;
    };
  };
}
