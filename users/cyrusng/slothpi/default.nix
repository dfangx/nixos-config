{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./programs/nixvim.nix
  ];
}
