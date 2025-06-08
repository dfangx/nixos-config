{ inputs, config, pkgs, lib, ... }:
{
  programs.nixvim = {
    plugins = {
      neorg.enable = lib.mkForce false;
      treesitter.enable = lib.mkForce false;
      treesitter-refactor.enable = lib.mkForce false;
      lsp.enable = lib.mkForce false;
    };
  };
}
